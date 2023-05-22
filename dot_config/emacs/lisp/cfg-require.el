;;; cfg-require.el --- Declare dependencies

;;; Commentary:

;;; Code:
(eval-when-compile (require 'cl-macs))
(autoload 'package--delete-directory "package")
(autoload 'package-desc-dir "package")
(autoload 'package-desc-name "package")

(autoload 'vc-deduce-backend "vc")
(autoload 'vc-dir-marked-files "vc-dir")
(autoload 'vc-git--call "vc-git")
(autoload 'vc-git-checkout "vc-git")
(autoload 'vc-git-root "vc-git")
(autoload 'vc-resynch-buffer "vc-dispatcher")

(autoload 'time-stamp-string "time-stamp")
(defvar package-alist)

(defun cr--vc-git-stash-all (name)
  "Create a stash given the name NAME, including untracked files."
  (interactive "sStash name: ")
  (when-let ((root (vc-git-root default-directory)))
    ;; Remove the PKG-autoloads.el{,c} and PKG-pkg.el{c} files
    ;; first.
    'todo
    (apply #'vc-git--call nil "stash" "push" "-u" "-m" name
           (when (derived-mode-p 'vc-dir-mode)
             (vc-dir-marked-files)))
    (vc-resynch-buffer root t t)))

(defun cr-1 (pkg section)
  "See `cfg-require', where PKG is an element of BODY.
SECTION is the symbol of the current section."
  (cond
   ((memq pkg '(:package :vc :vc-local :local)) pkg)
   ((null section)
    (error "Must start with valid keyword, got `%S'" pkg))
   ((eq section :package)
    (package-install pkg)
    (let* ((pkg-sym
            (if (symbolp pkg) pkg (package-desc-name pkg)))
           (pkg (cadr (assq pkg-sym package-alist))))
      (cons (list (package-desc-dir pkg)) pkg-sym)))
   ((eq section :vc)
    ;; Since `package-vc-install' tries to delete previously
    ;; checked out installs, I would have to roll my own.
    (let* ((pkg-name (if (symbolp pkg) pkg (car pkg)))
           (pkg-desc 'todo-get-desc)
           (pkg-dir (expand-file-name
                     (symbol-name pkg-name)
                     (locate-user-emacs-file "elpa"))))
      (cond
       ((not (file-exists-p pkg-dir))
        'todo-clone)
       ((vc-deduce-backend pkg-dir)
        'todo-fetch)
       (t 'todo-error)))
    'todo-checkout-rev
    (error ":vc currently not supported"))
   ((eq section :vc-local)
    (cl-destructuring-bind
        (pkg checkout &optional anchor) pkg
      (unless
          (eq 'Git (vc-responsible-backend checkout))
        (error "Not a git controlled directory: %s"
               checkout))
      (let* ((checkout (expand-file-name checkout))
             (default-directory checkout)
             (pkg-name (symbol-name pkg))
             ;; Without this sometimes stashing
             ;; untracked files do not remove them.
             ;; Maybe a git bug?
             (vc-git-use-literal-pathspecs nil))
        ;; When anchor is non-nil, stash current
        ;; changes if any, and switch to this anchor.
        (when anchor
          (unless (stringp anchor)
            (error "Anchor not string: `%S'" anchor))
          (cr--vc-git-stash-all
           (format "cfg-require@%s"
                   (time-stamp-string
                    "%Y%02m%02dT%02H%02M%02S")))
          (vc-git-checkout checkout anchor))
        (let ((pkg-dir
               (expand-file-name pkg-name package-user-dir)))
          (when (file-exists-p pkg-dir)
            (package--delete-directory pkg-dir)))
        (package-vc-install-from-checkout
         checkout pkg-name)
        (cons (list checkout) pkg))))
   ((eq section :local) (cons nil pkg))))

(defmacro cr (&rest body)
  "Declare dependencies.
BODY is separated into sections, led by one of the following
symbols:

- :package: Each element of the section should be a package
            symbol of `package-desc' to install via
            `package-install'.

- :vc: Each element of the section must be either a symbol naming
       the package, or a cons cell whose `car' is the package
       name, and whose `cdr' is a plist.  The plist must contain
       all mandatory keys listed in info node `(emacs) Fetching
       Package Sources'.  An additional optional key is :rev, see
       REV in `package-vc-install'.

- :vc-local: Each element of the section should be a list:
             \\=(PKG-NAME CHECKOUT &optional ANCHOR), where
             CHECKOUT is a string naming an existing directory
             under version control where code should be located.
             ANCHOR, if non-nil, is a commit-ish
             identifier.  (Can be any reference, commit hash,
             tag, etc.)

- :local: Each element of the section should be a package symbol
          which is locally-findable."
  (declare (indent 0))
  (let (section eval)
    (dolist (pkg body)
      ;; (ADDL-LOAD-PATHS . PKG-NAME) or keywordp
      (let* ((cr-single (cr-1 pkg section)))
        (pcase cr-single
          ((pred keywordp) (setq section cr-single))
          (`(,loads . ,pkg)
           (let ((add-loads
                  (apply-partially #'add-to-list 'load-path))
                 (autoload
                   (intern
                    (concat (symbol-name pkg) "-autoloads"))))
             (when loads
               (mapc add-loads loads)
               (push `(mapc ',add-loads ',loads) eval))
             (require autoload nil t)

             (push `(require ',autoload nil t) eval))))))
    (let ((eval (macroexp-progn (nreverse eval))))
      (pp eval)
      eval)))

(provide 'cfg-require)
;;; cfg-require.el ends here.

;; Local Variables:
;; read-symbol-shorthands: (("cr" . "cfg-require"))
;; End:

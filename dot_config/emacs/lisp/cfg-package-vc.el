;;; cfg-package-vc.el --- Handle VC packages

;;; Commentary:

;;; Code:
(eval-when-compile (require 'rx))
(eval-when-compile (require 'cl-macs))
(require 'cl-lib)
(require 'cfg-package)
(require 'package-vc)


;; * `defconst'
(defconst cpv--package-proxies
  `((,(rx string-start (group) "https://github.com")
     "https://ghproxy.com/" 1))
  "List of proxy definitions.
Each proxy definition should match (REGEXP REPLACE &optional
GROUP), where REGEXP is the regexp to be replaced, REPLACE is the
target replacement string.  When GROUP is nil, replace the entire
match with REPLACE; otherwise replace the matching group number
or name with REPLACE.")

;; * `defun'
(defun cpv--package-proxy (package)
  "Proxy the package definition PACKAGE."
  (declare (pure t) (side-effect-free t))
  (let* ((pname (car-safe package))
         (plist (cdr-safe package))
         (url (plist-get plist :url)))
    (unless url
      (user-error "Package `%s' should include a `:url' spec"
                  package))
    (cl-dolist (proxy cfg-package-vc--package-proxies package)
      (cl-destructuring-bind
          (regexp replace &optional group) proxy
        (save-match-data
          (when (string-match regexp url)
            (let* ((group (or group 0))
                   (url (replace-match replace nil t url group)))
              (cl-return (cl-list* pname :url url plist)))))))))

(defun cpv-install--advice (args)
  "Advice for `package-vc-install' filtering ARGS."
  (declare (pure t) (side-effect-free t))
  (cl-destructuring-bind (package &optional rev backend) args
    (list (cfg-package-vc--package-proxy package) rev backend)))

;;;###autoload
(defun cpv-install (direct &optional proxied)
  "Install packages specified from DIRECT and PROXIED.
DIRECT means direct installation; PROXIED means under a proxy."
  (let* ((all-packages (mapcar #'car (append direct proxied)))
         (all-pkgs (seq-uniq all-packages)))
    (unless (eq (length all-packages) (length all-pkgs))
      (user-error "Duplicate packages specified in %S"
                  `((direct ,direct) (proxied ,proxied))))
    (setq package-vc-selected-packages
          (append direct
                  (mapcar #'cfg-package-vc--package-proxy proxied)
                  (seq-filter (lambda (e) (memq (car e) all-pkgs))
                              package-vc-selected-packages)))
    (package-install-selected-packages)
    (package-vc-install-selected-packages)))

(defvar cpv-install-queue nil
  "An alist of packages queued for installation.
the alist is from the package name symbol to a plist of the
following properties:

- :installed BOOL (default nil): whether the package has already
  been installed.

- :unspecified BOOL (default nil): whether the recipe of this
  package is unspecified.

- :KEYWORD VALUE: see `cfg-package-vc-package-p' under the
  specification of PLIST for other unrecognized keywords.")

(defvar cpv-install-queue--pending nil
  "List of package names pending.")

(eval-and-compile
  (defun cpv-package-name-p (pkg)
    "Return the canonical package name of PKG if it is a package name.
That is, which should mean a package name with an
unspecified means of installation.  It can also be quoted at
any depths."
    (pcase pkg
      ((pred symbolp) pkg)
      ((or `',pkg ``,pkg `#',pkg)
       (cpv-package-name-p pkg))))

  (defvar cpv-package-p--hash (make-hash-table :test #'eq))

  (defun cpv-package-p (pkg)
    "Return whether PKG is a valid package specification.
In fact, return its canonical package name.

A valid package specification should satisfy one of the following
conditions:

1. PKG can satisfy `cfg-package-vc-package-name-p', which
   specifies a package name without specifying its means of
   installation.

2. PKG can be a cons cell (NAME . PLIST), where NAME is the name
   of the package as a symbol, and PLIST is a plist with the
   following keys:

  - :proxy BOOL (default nil): whether to use a pre-configured
    proxy, see docstring for `cfg-package-vc--package-proxies'.

  - :depends PKGS (default nil): a list of packages on which the
    current package depends.  Each element of PKGS should satisfy
    `cfg-package-vc--package-p'.

  - :KEYWORD VALUE: unrecognized key-value pairs are passed to
    `package-vc-install' unmodified."
    (pcase (gethash pkg cpv-package-p--hash 0)
      ((and p (pred symbolp)) p)
      (_ (let ((res
                (cl-letf (((gethash pkg cpv-package-p--hash) t))
                  (cpv-package-p--1 pkg))))
           (puthash pkg res cpv-package-p--hash)
           res))))
  
  (defun cpv-package-p--1 (pkg)
    "See `cfg-package-vc-package-p' for PKG."
    (cond
     ((cpv-package-name-p pkg))
     ((consp pkg)
      (cl-destructuring-bind (name . plist) pkg
        (and
         (symbolp name)
         (booleanp (plist-get plist :proxy))
         (let ((depends (plist-get plist :depends)))
           (and (proper-list-p depends)
                (null
                 (seq-filter (lambda (pkg) (not (cpv-package-p pkg)))
                             depends))
                name))))))))

(defmacro cpv-install-queue (pkg)
  "Mark unquoted package PKG for installation.
PKG should satisfy `cfg-package-vc-package-p'."
  (cpv-install-queue--f pkg))

(defun cpv-install-queue--prop (name prop)
  (thread-first name (assq cpv-install-queue)
                (cdr) (plist-get prop)))

(defun cpv-install-queue--touch (name)
  "\"Touch\" the package name NAME.
See variable `cfg-package-vc-install-queue'."
  (cl-with-gensyms (sym)
    (when (eq sym (alist-get name cpv-install-queue sym))
      (push (list name :unspecified t) cpv-install-queue))))

(defun cpv-install-queue--f (pkg)
  "See function `cfg-package-vc-install-queue' for PKG."
  (let ((name (cpv-package-p pkg)))
    (unless name (error "Invalid package specification `%s'" pkg))
    ;; first remember this package
    (cpv-install-queue--touch name)
    (cond
     ;; Only a name, or doubly spec'd package: noop
     ((or (cpv-package-name-p pkg)
          (not (cpv-install-queue--prop name :unspecified)))
      `',name)
     ;; Unspec'd Package with specification: record then deps
     ((let* ((plist (cdr pkg))
             (deps (plist-get plist :depends))
             (dep-names (mapcar #'cpv-package-p deps)))
        (when (seq-filter #'null dep-names)
          (error "Dep list contain invalid entries: `%s'" deps))
        (setf
         (alist-get name cpv-install-queue)
         (cl-list*
          :unspecified nil :depends dep-names
          (append (cdr pkg) (alist-get name cpv-install-queue))))
        (mapc #'cpv-install-queue--f deps)
        `'(,name ,@dep-names))))))


;; `advice-add'
(advice-add #'package-vc-install
            :filter-args #'cpv-install--advice)


;; * `provide'
(provide 'cfg-package-vc)
;;; cfg-package-vc.el ends here.

;; Local Variables:
;; read-symbol-shorthands: (("cpv" . "cfg-package-vc"))
;; End:

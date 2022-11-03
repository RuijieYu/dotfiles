;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(org)))

;;;###autoload
(defmacro cfg-org-babel-load-languages (&rest pairs)
  "Add languages to `org-babel-load-languages'.  See also
`org-babel-do-load-languages'.  All elements in PAIRS are
evaluated."
  (cl-do ((pairs pairs (cddr pairs))
          (addl-langs
           nil
           (progn
             (when (length< pairs 2)
               (error "Missing second part"))
             (let ((lang (nth 0 pairs))
                   (enable-p (nth 1 pairs)))
               (cond (lang (cons (cons lang enable-p) addl-langs))
                     (t addl-langs))))))
      ((null pairs)
       `(progn (require 'org)
               (org-babel-do-load-languages
                'org-babel-load-languages
                (delete-dups (append ',addl-langs org-babel-load-languages)))
               org-babel-load-languages))))

;;;###autoload
(with-eval-after-load 'org
  (cfg-org-babel-load-languages shell t))

;; plantuml in org babel
(use-package plantuml-mode
  :disabled
  :init
  (with-eval-after-load 'org
    (dolist (lang '((plantuml . t)))
      (add-to-list 'org-babel-load-languages lang))))

;; diagrams
(use-package ob-diagrams
  :disabled
  :straight (ob-diagrams
             :type git
             :host github
             :repo "emacsbliss/ob-diagrams")
  :demand t
  :after org)

;;;###autoload
(use-package ob-dot
  :straight org
  :after org
  :demand t)

;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(org)))

;;;###autoload
(with-eval-after-load 'org
  (dolist (lang '((shell . t)))
    (add-to-list 'org-babel-load-languages lang))
  (org-babel-do-load-languages
   'org-babel-load-languages
   org-babel-load-languages))

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

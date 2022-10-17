;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(ein)))

;;;###autoload
(use-package ein)

;;;###autoload
(use-package ein-ipynb-mode
  :straight ein
  :after ein
  :defines ein:ipynb-mode-map
  :config
  (define-keymap :keymap ein:ipynb-mode-map
    "C-c C-c" ein:run))

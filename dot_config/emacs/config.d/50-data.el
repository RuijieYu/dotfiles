;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(csv-mode yaml-mode)))

;;;###autoload
(use-package csv-mode)

;;;###autoload
(use-package yaml-mode
  :mode
  ((rx "/.clangd" string-end) . yaml-mode))

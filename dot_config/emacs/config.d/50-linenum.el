;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;;;###autoload
(use-package prog-mode
  :straight nil
  :hook
  (prog-mode . display-line-numbers-mode))

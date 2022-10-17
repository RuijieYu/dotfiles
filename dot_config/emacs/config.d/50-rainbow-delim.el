;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(rainbow-delimiters)))

;;;###autoload
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

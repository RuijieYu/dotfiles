;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(eldoc)))

;;;###autoload
(use-package eldoc
  :custom
  (eldoc-idle-delay 0))

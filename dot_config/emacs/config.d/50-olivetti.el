;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(olivetti)))

;; Center the buffer
;;;###autoload
(use-package olivetti
  :commands olivetti-mode
  :hook
  (org-mode . olivetti-mode))

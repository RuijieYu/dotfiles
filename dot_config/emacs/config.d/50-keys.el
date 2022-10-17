;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(keycast)))

;;;###autoload
(use-package keycast
  :commands keycast-mode
  :config
  (define-keymap :keymap (current-global-map)
    "C-<tab> k" #'keycast-mode))

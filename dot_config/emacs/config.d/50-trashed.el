;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(trashed)))

;;;###autoload
(use-package trashed
  :commands trashed)

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-<tab> C-t" #'trashed)

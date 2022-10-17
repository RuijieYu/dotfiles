;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(shfmt)))

;;;###autoload
(use-package shfmt
  :if (executable-find "shfmt")
  :after sh-script
  :commands (shfmt-buffer
             shfmt-region)
  :config
  (define-keymap :keymap sh-mode-map
    "C-<tab> = =" #'shfmt-buffer
    "C-<tab> = b" #'shfmt-buffer
    "C-<tab> = r" #'shfmt-region))

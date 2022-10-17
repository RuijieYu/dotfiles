;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;;;###autoload
(use-package simple
  :straight nil
  :config
  (define-keymap :keymap visual-line-mode-map
    "C-c n" #'next-logical-line
    "C-c p" #'previous-logical-line))

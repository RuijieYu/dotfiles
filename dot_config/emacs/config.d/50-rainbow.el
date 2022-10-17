;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(rainbow-mode)))

;;;###autoload
(use-package rainbow-mode
  :commands rainbow-mode)

;;;###autoload
(define-keymap :keymap (current-global-map)
  "<f12>" #'rainbow-mode)

;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(imenu-list)))

;;;###autoload
(use-package imenu
  ;; M-g i -> #'imenu
  :straight nil
  :commands imenu)

;;;###autoload
(use-package imenu-list
  :after imenu
  :commands imenu-list)

;;;###autoload
(define-keymap :keymap (current-global-map)
  "M-g M-i" #'imenu-list)

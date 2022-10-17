;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;;;###autoload
(use-package recentf
  :straight nil
  :hook (after-init . recentf-mode)
  :commands recentf-open-files)

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-<tab> f" #'recentf-open-files)

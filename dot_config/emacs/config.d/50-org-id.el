;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(org)))

;;;###autoload
(use-package org-id
  :straight org
  :after org
  :commands org-id-get-create)

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-<tab> o i" #'org-id-get-create)

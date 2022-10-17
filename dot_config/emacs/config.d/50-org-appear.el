;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(org-appear diminish)))

;; - orgmode auto-show markup symbols
;;;###autoload
(use-package org-appear
  :diminish
  :after (org diminish)
  :hook
  (org-mode . org-appear-mode))

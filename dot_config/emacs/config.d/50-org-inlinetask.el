;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(org)))

;;;###autoload
(use-package org-inlinetask
  :straight org
  :after org
  :demand t)

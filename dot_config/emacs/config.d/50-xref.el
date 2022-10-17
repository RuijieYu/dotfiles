;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(xref)))

;;;###autoload
(use-package xref
  :custom
  (xref-search-program
   (if (executable-find "rg") 'ripgrep 'grep)))

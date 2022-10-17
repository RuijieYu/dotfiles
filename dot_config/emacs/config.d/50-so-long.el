;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

(use-package so-long
  :if (version<= "27.1" emacs-version)
  :straight nil
  :hook
  (after-init . global-so-long-mode))

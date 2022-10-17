;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;; inferior editing
;;;###autoload
(use-package server
  :straight nil
  :no-require t
  :config
  (when server-process
    (setenv "EDITOR" "emacsclient")
    (setenv "VISUAL" "emacsclient")))

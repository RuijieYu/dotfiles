;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;;;###autoload
(use-package tramp
  :straight nil
  :custom
  (tramp-default-method "sshx")
  :config
  (dolist (path '("~/.local/bin" "~/.cargo/bin"))
    (add-to-list 'tramp-remote-path path)))

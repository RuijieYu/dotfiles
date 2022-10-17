;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(systemd)))

;;;###autoload
(use-package systemd
  ;; there is also systemd-mode, but the packaging is faulty
  :hook
  (systemd-mode . company-mode))

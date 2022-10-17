;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;;;###autoload
(use-package autorevert
  :straight nil
  :hook
  (after-init . global-auto-revert-mode)
  :custom
  (global-auto-revert-non-file-buffers nil))

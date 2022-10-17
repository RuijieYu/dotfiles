;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(which-key diminish)))

;;;###autoload
(use-package which-key
  :after diminish
  :diminish " K"
  :custom
  (which-key-idle-delay 1)
  :hook
  (emacs-startup . which-key-mode))

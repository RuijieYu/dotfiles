;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(helpful)))

;;;###autoload
(use-package helpful
  :disabled
  :after counsel
  :commands (helpful-command
             helpful-key)
  :init
  (global-set-key [remap describe-command] #'helpful-command)
  (global-set-key [remap describe-key] #'helpful-key))

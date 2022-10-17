;; -*- no-byte-compile: t; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

(use-package counsel
  :disabled
  :commands (counsel-describe-function
             counsel-describe-variable)
  :bind
  (([remap describe-command] . #'helpful-command)
   ([remap describe-key] . #'helpful-key))
  :config
  (defalias 'counsel-load-theme #'load-theme)
  (global-set-key
   [C-tab ?t ?t] #'counsel-load-theme))

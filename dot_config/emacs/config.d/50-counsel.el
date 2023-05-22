;; -*- no-byte-compile: t; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(counsel)))

;;;###autoload
(use-package counsel
  :disabled
  :commands (counsel-describe-function
             counsel-describe-variable
             counsel-load-theme)
  :init
  (global-set-key [remap describe-function]
                  #'counsel-describe-function)
  (global-set-key [remap describe-variable]
                  #'counsel-describe-variable)
  :config
  (advice-add #'load-theme :override #'counsel-load-theme))

;;;###autoload
(global-set-key [C-tab ?t ?t] #'load-theme)

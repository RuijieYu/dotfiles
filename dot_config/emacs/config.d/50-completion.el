;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(vertico marginalia)))

;;;###autoload
(use-package vertico
  :hook
  (after-init . vertico-mode)
  :custom
  ;; <up> for last entry
  (vertico-cycle t))

;;;###autoload
(use-package marginalia
  :hook
  (after-init . marginalia-mode)
  :config
  (define-keymap :keymap minibuffer-local-map
    "M-a" #'marginalia-cycle))

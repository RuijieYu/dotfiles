;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload nil  ;; '(vertico marginalia)
           ))

;;;###autoload
(use-package vertico
  :disabled
  :hook
  (after-init . vertico-mode)
  :custom
  ;; <up> for last entry
  (vertico-cycle t))

;;;###autoload
(use-package marginalia
  :disabled
  :hook
  (after-init . marginalia-mode)
  :config
  (define-keymap :keymap minibuffer-local-map
    "M-a" #'marginalia-cycle))

;;;###autoload
(use-package icomplete
  :straight nil
  :hook
  (after-init . fido-mode)
  (after-init . fido-vertical-mode)
  :config
  (define-keymap :keymap icomplete-fido-mode-map
    "RET" "C-j"                  ; make sure RET completes as well
    ))

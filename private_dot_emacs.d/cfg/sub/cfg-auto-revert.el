(require 'cfg-package)

;; reverting dired and buffer menus has weird effects
(use-package autorevert
  :ensure nil
  :custom
  (global-auto-revert-non-file-buffers nil)
  :config
  (global-auto-revert-mode t)
  )

(provide 'cfg-auto-revert)

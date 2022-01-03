(require 'cfg-package)

(use-package flycheck
  :ensure t
  :diminish global-flycheck-mode
  :custom
  (flycheck-keymap-prefix (kbd "<C-tab>f"))
  :hook (after-init . global-flycheck-mode)
  )

(use-package flycheck-pycheckers
  :ensure t
  :after flycheck
  :hook
  (flycheck-mode . flycheck-pycheckers-setup)
  )

(provide 'cfg-check)

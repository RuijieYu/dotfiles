(require 'cfg-package)

(use-package which-key
  :ensure t
  :defer nil
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1)
  )

(provide 'cfg-which-key)

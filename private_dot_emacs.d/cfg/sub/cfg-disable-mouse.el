(require 'cfg-package)

(use-package disable-mouse
  :ensure t
  :config
  (declare-function global-disable-mouse-mode load-file-name)
  (global-disable-mouse-mode)
  )

(provide 'cfg-disable-mouse)

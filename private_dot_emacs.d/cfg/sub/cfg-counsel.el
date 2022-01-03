(require 'cfg-package)

(use-package counsel
  :ensure t
  :bind
  ;; counsel-M-x : I prefer vertico+marginalia's addition to M-x over this
  ("<C-x>b" . counsel-ibufer)
  ("<C-x><C-f>" . counsel-find-file)
  ("<C-M-j>" . counsel-switch-buffer)
  (:map minibuffer-local-map
	("<C-r>" . counsel-minibuffer-history))
  )

(provide 'cfg-counsel)

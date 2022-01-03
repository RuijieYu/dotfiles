(require 'cfg-package)

;; completion framework
(use-package vertico
  :ensure t
  :config
  (vertico-mode)
  (setq vertico-cycle t) ; <up> for last entry
  )

;; additional information
(use-package marginalia
  :ensure t
  :bind
  (:map minibuffer-local-map
	("M-a" . marginalia-cycle)
	)
  :init (marginalia-mode)
  )

(provide 'cfg-complete)

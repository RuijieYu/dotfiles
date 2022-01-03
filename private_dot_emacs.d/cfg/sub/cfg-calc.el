(require 'cfg-package)
(require 'cfg-org)

(use-package calc-frac
  :ensure nil
  :after calc
  :config
  (setq calc-frac-format '("/" nil))
  )

(use-package calc
  :ensure nil
  :after org
  :config
  (setq calc-prefer-frac t
	calc-display-working-message t)
  )

(provide 'cfg-calc)

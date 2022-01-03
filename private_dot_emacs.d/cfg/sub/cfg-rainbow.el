(require 'cfg-package)

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode)
  )

(provide 'cfg-rainbow)

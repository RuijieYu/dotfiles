(require 'cfg-package)

(use-package pdf-tools
  :ensure t
  :defer 10
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :commands pdf-view-mode
  :hook
  (pdf-view-mode . auto-revert-mode)
  (pdf-view-mode . (lambda ()
		     (require 'display-line-numbers)
		     (display-line-numbers-mode -1)))
  :config
  ;; I think `pdf-tools-install' will check whether installation is
  ;; necessary
  (pdf-tools-install :no-query)
  )

(provide 'cfg-pdf)

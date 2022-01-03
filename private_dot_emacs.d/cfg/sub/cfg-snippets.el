(require 'cfg-package)

(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :hook (prog-mode . yas-minor-mode)
  :config
  (declare-function yas-reload-all load-file-name)
  (yas-reload-all)
  )

(provide 'cfg-snippets)

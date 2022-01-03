(require 'cfg-package)

;; allow to select buffers based on a set of keys
(use-package ace-window
  :ensure t
  :bind
  ("<M-o>" . ace-window)
  :custom
  (aw-scope 'frame)
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-minibuffer-flag t)
  :config
  (ace-window-display-mode 1)
  )

(provide 'cfg-win-sel)

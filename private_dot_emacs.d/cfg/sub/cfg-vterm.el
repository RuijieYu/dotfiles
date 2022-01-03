(require 'cfg-package)

(use-package vterm
  :ensure t
  :commands vterm
  :custom
  (vterm-shell "zsh")
  (vterm-max-scrollback 10000)
)

(provide 'cfg-vterm)

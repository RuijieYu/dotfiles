(require 'cfg-package)

(use-package cus-edit
  :ensure nil
  :custom
  ;; not included in repo
  (custom-file (expand-file "~/.emacs.d/custom.el"))
  )

(provide 'cfg-custom)

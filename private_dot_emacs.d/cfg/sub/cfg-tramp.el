(require 'cfg-package)

(use-package tramp
  :ensure nil
  :custom
  ;; this uses ssh v2, where "ssh" uses v1
  ;; default "scp", maybe need investigation
  (tramp-default-method "sshx")
  )

(provide 'cfg-tramp)

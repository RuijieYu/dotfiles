;;; cfg-breadcrumb.el --- Configure breadcrumb

;;; Commentary:

;;; Code:
(eval-when-compile (require 'cfg-require))
(cfg-require
  :vc-local
  (breadcrumb "/opt/src/emacs/packages/breadcrumb/local" "local"))

;; (require 'breadcrumb)

(provide 'cfg-breadcrumb)
;;; cfg-breadcrumb.el ends here.

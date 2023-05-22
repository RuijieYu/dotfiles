;;; cfg-org-roam.el --- Configure org-roam

;;; Commentary:

;;; Code:
(eval-when-compile (require 'cfg-org))
(eval-when-compile (require 'cfg-require))
(cfg-require
  :package dash buttercup
  :vc-local
  (org-roam "/opt/src/emacs/packages/org-roam/local" "local"))


;; * `setopt'
(with-eval-after-load  'org-roam
  (setopt org-roam-directory "~/.local/share/org-roam/documents"

          ))

(provide 'cfg-org-roam)
;;; cfg-org-roam.el ends here.

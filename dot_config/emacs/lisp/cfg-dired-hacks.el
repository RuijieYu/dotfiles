;;; cfg-dired-hacks.el --- Configure dired-hacks, a collection of dired extensions

;;; Commentary:

;;; Code:
(eval-when-compile (require 'cfg-require))
(cfg-require
  :package dash f s
  :vc-local
  (dired-hacks "/opt/src/emacs/packages/dired-hacks/local"))
;; (require 'cfg-package-vc)
;; (cfg-package-vc-install
;;  '((dired-hacks :url "https://github.com/Fuco1/dired-hacks")))

(provide 'cfg-dired-hacks)
;;; cfg-dired-hacks.el ends here.

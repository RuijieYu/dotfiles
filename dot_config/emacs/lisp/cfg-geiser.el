;;; cfg-geiser.el --- Configure geiser for scheme editing

;;; Commentary:

;;; Code:
(eval-when-compile (require 'cfg-require))
(cfg-require :package geiser geiser-guile)
(require 'cfg-scheme)

;; * `add-hook'
(with-eval-after-load 'geiser
  (add-hook 'geiser-mode-hook #'cfg-scheme-common-setup)
  (add-hook 'geiser-repl-mode-hook #'cfg-scheme-repl-setup))

(provide 'cfg-geiser)
;;; cfg-geiser.el ends here.

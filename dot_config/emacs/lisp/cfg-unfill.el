;;; cfg-unfill.el --- Allow "un"filling a paragraph

;;; Commentary:

;;; Code:
;; (eval-when-compile (require 'cfg-require))
;; (cfg-require
;;   :vc (unfill :url "https://github.com/purcell/unfill"))

(require 'cfg-package-vc)
(cfg-package-vc-install
 '((unfill :url "https://github.com/purcell/unfill")))
(require 'unfill)


(define-keymap :keymap global-map
  "C-M-q" #'unfill-paragraph
  "C-c q" #'unfill-paragraph)


(provide 'cfg-unfill)
;;; cfg-unfill.el ends here.

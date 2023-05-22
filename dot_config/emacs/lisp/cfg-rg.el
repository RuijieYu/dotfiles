;;; cfg-rg.el --- Configure rg

;;; Commentary:

;;; Code:
(require 'cfg-package-vc)


(cfg-package-vc-install
 nil '((vc :url "https://github.com/dajva/rg.el")))
(require 'rg)


(provide 'cfg-rg)
;;; cfg-rg.el ends here.

;;; cfg-rainbow.el --- Display color strings with a face

;;; Commentary:

;;; Code:
(require 'cfg-package)
(cfg-package-install '(rainbow-mode))

(define-keymap :keymap global-map
  "<f12>" #'rainbow-mode)

(provide 'cfg-rainbow)
;;; cfg-rainbow.el ends here.

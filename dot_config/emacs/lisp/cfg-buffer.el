;;; cfg-buffer.el --- Buffer management configuration

;;; Commentary:

;;; Code:
(define-keymap :keymap global-map
  (key-description [remap suspend-frame]) #'bury-buffer)

(provide 'cfg-buffer)
;;; cfg-buffer.el ends here.

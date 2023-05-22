;;; cfg-chinese.el --- Configure Chinese input

;;; Commentary:

;;; Code:
(require 'cfg-pyim)


;; * `defun'
(defun cfg-chinese-insert-zws ()
  "Insert a zero-width space."
  (interactive)
  (insert 8203))


;; * `face-remapping-alist'
(setf (alist-get "Sarasa UI SC" face-font-rescale-alist
                 nil nil #'equal)
      (/ 16.0 13.0))
;; Interestingly, updating this variable only takes effect after I
;; walk away for a while.  Not sure what triggers a redisplay on a
;; window.


;; * `define-keymap'
(define-keymap :keymap global-map
  "C-c SPC" #'cfg-chinese-insert-zws)


;; * `provide'
(provide 'cfg-chinese)
;;; cfg-chinese.el ends here.

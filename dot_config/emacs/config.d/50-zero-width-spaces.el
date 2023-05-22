;;  -*- no-byte-compile: nil; -*-
;;;###autoload
(defun cfg-zws-insert ()
  "Insert ZERO WIDTH SPACE."
  (interactive)
  (insert ?\N{ZERO WIDTH SPACE}))

;; doesn't work?
;;;###autoload
(add-to-list 'prettify-symbols-alist
             `(,(string ?\N{ZERO WIDTH SPACE})
               ?\N{SPACING UNDERSCORE}))

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-<tab> SPC" #'cfg-zws-insert)

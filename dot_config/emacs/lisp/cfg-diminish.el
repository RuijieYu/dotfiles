;;; cfg-diminish.el --- Diminishing minor modes.

;;; Commentary:

;;; Code:
(eval-when-compile (require 'cfg-require))
(cfg-require :package diminish)

(defun cfg-diminish--1 (def)
  "Handle a single `diminish' definition, DEF."
  (cond ((consp def)
         (diminish (car def) (cdr def)))
        ((atom def)
         (diminish def nil))
        (t (user-error "Invalid `diminish' definition: %S" def))))

;;;###autoload
(defun cfg-diminish (defs)
  "Diminish minor modes according to DEFS.
DEFS is a list where each element is a `cons' cell \\=(MODE .
TO-WHAT), passed to `diminish', which see."
  (mapc #'cfg-diminish--1 defs))

(provide 'cfg-diminish)
;;; cfg-diminish.el ends here.

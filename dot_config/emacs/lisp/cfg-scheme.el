;;; cfg-scheme.el --- Configure scheme

;;; Commentary:

;;; Code:
(require 'cfg-lisp)

;;;###autoload
(defun cfg-scheme-common-setup ()
  (cfg-lisp-common-setup))

;;;###autoload
(defun cfg-scheme-repl-setup ()
  (lispy-mode 1))

;; * `provide'
(provide 'cfg-scheme)
;;; cfg-scheme.el ends here.

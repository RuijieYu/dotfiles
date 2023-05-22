;;; cfg-package-upgrade.el --- Allow upgrading all builtin packages

;;; Commentary:

;;; Code:
(require 'package)

(defun cfg-package-upgrade ()
  "Allow upgrading all `:core' packages, see bug#62720."
  (interactive)
  (package--archives-initialize)
  ;; Make sure `package--builtins' is initialized (according to
  ;; its docstring)
  (and
   (package-built-in-p 'emacs)
   (let ((core-pkgs
          (seq-filter
           (lambda (pkg) (assq (car pkg) package--builtins))
           package-archive-contents)))
     (mapc (lambda (pkg) (package-install (cadr pkg)))
           core-pkgs))))

(provide 'cfg-package-upgrade)
;;; cfg-package-upgrade.el ends here.

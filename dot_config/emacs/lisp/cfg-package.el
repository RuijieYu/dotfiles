;;; cfg-package.el --- Package management.

;;; Commentary:

;;; Code:
(require 'package)

(defun cfg-package-install (packages &optional select)
  "Install PACKAGES using `package-install'.
When SELECT is non-nil, also select the packages."
  (mapc (lambda (p) (package-install p (not select))) packages))

(provide 'cfg-package)
;;; cfg-package.el ends here.

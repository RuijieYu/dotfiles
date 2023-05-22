;;; cfg-anno.el --- Text Annotation package

;;; Commentary:

;;; Code:
;; * `require'
(eval-when-compile (require 'subr-x))
(eval-when-compile
  (thread-last (expand-file-name "site-lisp" user-emacs-directory)
               (add-to-list 'load-path)))
(require 'text-anno-mode)

(provide 'cfg-anno)
;;; cfg-anno.el ends here.

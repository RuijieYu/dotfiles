;;; cfg-kabb.el --- Kill all buffers below directory

;;; Commentary:

;;; Code:
;; * `require'
(eval-when-compile (require 'subr-x))
(eval-when-compile
  (thread-last (expand-file-name "site-lisp" user-emacs-directory)
               (add-to-list 'load-path)))
(require 'kill-all-buffers-below)


;; * `define-keymap'
(define-keymap :keymap global-map
  "C-<tab> k" #'kill-all-buffers-below)


;; * `provide'
(provide 'cfg-kabb)
;;; cfg-kabb.el ends here.

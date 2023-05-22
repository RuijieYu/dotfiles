;;; cfg-lisp.el --- Configuration for all Lisp languages.

;;; Commentary:

;;; Code:
(require 'cfg-lispy)

;;;###autoload
(defun cfg-lisp-common-setup ()
  "Common setup procedures for all Lisp family buffers."
  (interactive)
  (require 'prog-mode)
  (add-to-list 'prettify-symbols-alist '("lambda" . ?λ))
  (prettify-symbols-mode)
  (lispy-mode)
  (electric-pair-local-mode)
  (display-fill-column-indicator-mode)
  (setq-local fill-column 66))

;;;###autoload
(defun cfg-lisp-insert-lambda ()
  "Insert the \"lambda\" string."
  (interactive)
  (insert "lambda"))

;;;###autoload
(defun cfg-lisp-insert-smart-lambda ()
  "Insert lambda depending on context."
  (interactive)
  (let ((s (syntax-ppss)))
    (insert (if (or (nth 3 s) (nth 4 s)) "λ" "lambda"))))

;;;###autoload
(defun cfg-lisp-insert-raw-lambda ()
  "Insert greek letter \"λ\"."
  (interactive)
  (insert ?λ))

(defun cfg-lisp-lambda--greek ()
  "See `cfg-lisp-lambda', inserting Greek."
  (interactive)
  (insert "λ"))

(defun cfg-lisp-lambda--text ()
  "See `cfg-lisp-lambda', inserting Latin."
  (interactive)
  (insert "lambda"))

(defun cfg-lisp-lambda--smart ()
  "See `cfg-lisp-lambda', inserting with context."
  (interactive)
  (let ((s (syntax-ppss)))
    (funcall
     (if (or (nth 3 s) (nth 4 s)) #'cfg-lisp-lambda--greek
       #'cfg-lisp-lambda--text))))

;;;###autoload
(defun cfg-lisp-lambda (format)
  "Return a closure to insert lambda according to FORMAT.
If FORMAT is `\'greek', then insert \"λ\" unconditionally.

If FORMAT is `\'text', then insert \"lambda\" unconditionally.

Otherwise insert based on context, i.e., Greek when inside
comment or string, Latin otherwise."
  (pcase format
    ('greek #'cfg-lisp-lambda--greek)
    ('text #'cfg-lisp-lambda--text)
    (_ #'cfg-lisp-lambda--smart)))

;;;###autoload
(defun cfg-lisp-common-binds (keymap)
  "Add common Lisp keybinds to KEYMAP."
  ;; (require 'comment-or-uncomment-region)
  (define-keymap :keymap keymap
    "C-M-y" (cfg-lisp-lambda 'smart)
    "λ" (cfg-lisp-lambda 'smart)))

(provide 'cfg-lisp)
;;; cfg-lisp.el ends here.

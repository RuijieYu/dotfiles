;;; cfg-elisp.el --- Configure elisp modes

;;; Commentary:

;;; Code:
(require 'cfg-lisp)

;;;###autoload
(defun cfg-elisp-eval-setup ()
  "Setup for `eval-expression’’s minibuffer."
  (when (eq (syntax-table) emacs-lisp-mode-syntax-table)
    (lispy-mode)))

(defun cfg-elisp-common-setup ()
  "Common setup procedures for Emacs Lisp buffers."
  (cfg-lisp-common-setup))

;;;###autoload
(defun cfg-elisp-setup ()
  "Setup procedures for regular Emacs Lisp buffers."
  (cfg-elisp-common-setup)
  (require 'flymake)
  ;; It makes little sense to enable flymake in *.elc files
  (unless (derived-mode-p #'elisp-byte-code-mode)
    (flymake-mode)))

;;;###autoload
(defun cfg-elisp-interactive-setup ()
  "Setup procedures for Interactive Emacs Lisp buffers."
  (interactive)
  (cfg-elisp-common-setup))

;;;###autoload
(progn
  (add-hook 'minibuffer-setup-hook #'cfg-elisp-eval-setup)
  (add-hook 'emacs-lisp-mode-hook #'cfg-elisp-setup)
  (add-hook 'lisp-interaction-mode-hook #'cfg-elisp-interactive-setup)
  (add-hook 'inferior-emacs-lisp-mode-hook #'cfg-elisp-interactive-setup))

(cfg-lisp-common-binds emacs-lisp-mode-map)

(provide 'cfg-elisp)
;;; cfg-elisp.el ends here.

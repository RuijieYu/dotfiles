;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

(defun cfg-elisp-common-setup ()
  "Common setups for emacs lisp buffers."
  (cfg-lisp-common-setup)
  (lispy-mode)
  (electric-pair-local-mode))

;;;###autoload
(defun cfg-elisp-interactive-setup ()
  "Setup for interactive emacs lisp buffers."
  (cfg-elisp-common-setup))

;;;###autoload
(defun cfg-elisp-setup ()
  "Setup for emacs lisp buffers."
  (interactive)
  (cfg-elisp-common-setup)
  (setq-local fill-column 66))

;;;###autoload
(defun cfg-elisp-eval-setup ()
  "Setup for `eval-expression’’s minibuffer."
  (when (eq (syntax-table) emacs-lisp-mode-syntax-table)
    (lispy-mode)))

;;;###autoload
(add-hook 'minibuffer-setup-hook #'cfg-elisp-eval-setup)

;;;###autoload
(use-package elisp-mode
  :straight nil
  :commands (eval-last-sexp
             eval-defun
             elisp-mode)
  :hook
  (emacs-lisp-mode . cfg-elisp-setup)
  :config
  (cfg-lisp-bind-lambda emacs-lisp-mode-map)
  (define-keymap :keymap emacs-lisp-mode-map
    "C-c C-c" #'eval-buffer))

;;;###autoload
(with-eval-after-load 'elisp-mode
  (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-minted-langs
                 '(emacs-lisp "emacs-lisp"))))

;; "Inferior Emacs Lisp Mode"
;;;###autoload
(use-package ielm
  :straight nil
  :hook
  (ielm-mode . cfg-elisp-interactive-setup)
  :config
  (cfg-lisp-bind-lambda inferior-emacs-lisp-mode-map))

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-<tab> r" #'ielm)

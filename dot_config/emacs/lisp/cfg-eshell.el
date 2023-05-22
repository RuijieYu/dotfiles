;;; cfg-eshell.el --- Configure eshell

;;; Commentary:

;;; Code:
(eval-when-compile (require 'cl-macs))


;; * `defvar'
(defvar eshell-output-filter-functions)

;; * `declare-function'
(declare-function eshell-truncate-buffer "ext:esh-mode")
(declare-function eshell-save-some-history "ext:em-hist")
(declare-function eshell "ext:eshell")


;; * `defun'
(defun cfg-eshell-init-setup ()
  "Initial setup upon loading `eshell'."
  (interactive)
  (require 'esh-mode)
  (cl-pushnew #'eshell-truncate-buffer
              eshell-output-filter-functions))

(defun cfg-eshell-setup ()
  "Setup an eshell buffer."
  (interactive)
  (display-line-numbers-mode -1)
  (display-fill-column-indicator-mode -1))


;; * `setopt'
(with-eval-after-load 'em-term
  (setopt eshell-destroy-buffer-when-process-dies t
          eshell-visual-commands
          '("htop" "btop"
            "bash" "zsh" "fish" "pwsh"
            "vim" "less" "more" "man")))

(with-eval-after-load 'em-hist
  (setopt eshell-history-size 10000
          eshell-hist-ignoredups t))

(with-eval-after-load 'esh-mode
  (setopt eshell-buffer-maximum-lines 10000
          eshell-scroll-to-bottom-on-input t))


;; * `define-keymap'
;;;###autoload
(with-eval-after-load 'esh-mode
  (defvar eshell-mode-map)
  (define-keymap :keymap eshell-mode-map
    "C-z" #'bury-buffer))

;;;###autoload
(define-keymap :keymap global-map
  "C-<tab> C-<return>" #'eshell
  ;; "<remap> <suspend-frame>" #'eshell
  )


;; * `add-hook'
;;;###autoload
(add-hook 'eshell-mode-hook #'cfg-eshell-setup)
;;;###autoload
(add-hook 'eshell-first-time-mode-hook #'cfg-eshell-init-setup)
;;;###autoload
(with-eval-after-load 'em-hist
  (add-hook 'eshell-pre-command-hook #'eshell-save-some-history))


;; * `provide'
(provide 'cfg-eshell)
;;; cfg-eshell.el ends here.

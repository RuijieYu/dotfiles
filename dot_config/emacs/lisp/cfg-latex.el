;;; cfg-latex.el --- Configure LaTeX

;;; Commentary:

;;; Code:
(eval-when-compile (require 'cfg-require))
(cfg-require :package auctex)
(autoload 'latex-electric-env-pair-mode "tex-mode")


;; * `defun'
(defun cfg-latex-setup ()
  "Setup LaTeX mode."
  (interactive)
  ;; also enable latex-eletric if electric is enabled
  (latex-electric-env-pair-mode electric-pair-mode))


;; * `setopt'
(setopt
 TeX-view-program-selection
 '(((output-dvi has-no-display-manager) "dvi2tty")
   ((output-dvi style-pstricks) "dvips and gv")
   (output-dvi "xdvi")
   (output-pdf "Zathura")      ; I use zathura, default was evince
   (output-html "xdg-open")))


;; * `add-hook'
(with-eval-after-load 'latex-mode
  (add-hook 'latex-mode-hook #'cfg-latex-setup))


;; * `auto-mode-alist'
(with-eval-after-load 'latex-mode
  ;; This is already the default?
  ;; (push (cons (rx ".tex" string-end) #'latex-mode)
  ;;       auto-mode-alist)
  )


(provide 'cfg-latex)
;;; cfg-latex.el ends here.

;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(auctex)))

;;;###autoload
(defun cfg-latex-setup ()
  "Setup latex mode."
  (interactive)
  ;; also enable latex-electric if electric is enabled
  (when electric-pair-mode
    (latex-electric-env-pair-mode))
  (olivetti-mode))

(use-package olivetti
  :no-require t
  :commands olivetti-mode)

;;;###autoload
(use-package latex-mode
  :straight nil
  :mode (rx ".tex" string-end)
  :hook
  (latex-mode . cfg-latex-setup))

;;;###autoload
(use-package auctex
  :custom
  (TeX-view-program-selection
   '(((output-dvi has-no-display-manager)
      "dvi2tty")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "Zathura")    ; I use zathura, default was evince
     (output-html "xdg-open"))))

(use-package auctex-latexmk
  ;; auctex has updated such that tex-buf no longer exists
  :disabled
  :demand t
  :config
  (auctex-latexmk-setup))

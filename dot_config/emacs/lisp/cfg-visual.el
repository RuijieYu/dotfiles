;;; cfg-visual.el --- Configure theming.

;;; Commentary:

;;; Code:
(eval-when-compile (require 'cfg-require))
(cfg-require :package modus-themes)

;;;###autoload
(defun cfg-visual-should-enable-p ()
  "Detect whether we should enable theming."
  (declare (pure t)
           (side-effect-free t))
  (and (display-graphic-p)
       (version<= "28.1" emacs-version)))

(with-eval-after-load 'modus-themes
  (setopt
   modus-themes-italic-constructs t
   modus-themes-bold-constructs nil
   modus-themes-subtle-line-numbers t
   modus-themes-intense-mouseovers nil
   modus-themes-deuteranopia nil      ; t for red-green colorblindness
   modus-themes-tabs-accented nil
   modus-themes-variable-pitch-ui nil
   modus-themes-inhibit-reload t
   modus-themes-fringes 'subtle       ; [nil, subtle, intense]
   modus-themes-lang-checkers '(faint)
   modus-themes-mode-line '(accented borderless)
   ;; (modus-themes-markup '(background italic))
   modus-themes-syntax '(faint)
   modus-themes-hl-line '(accented)
   modus-themes-paren-match '(bold intense)
   modus-themes-links '(neutral-underline background bold)
   modus-themes-box-buttons '(faint accented)
   modus-themes-promptss '(intense bold)
   modus-themes-completions
    '((matches background extrabold)
      (selection accented)              ; for vertico, the current selection
      (popup accented))
   modus-themes-mail-citations 'faint
   modus-themes-region '(bg-only accented)
   modus-themes-diffs 'desaturated
   ;; org-specific ones
   modus-themes-org-blocks 'tinted-background ; need org-restart
   ;; (modus-themes-org-agenda TODO)
   ;; (modus-themes-headings TODO)
   modus-themes-mixed-fonts t))

;;;###autoload
(defvar cfg-visual-loaded nil "Whether a theme has been loaded.")

;;;###autoload
(defun cfg-visual-modus-load-setup ()
  "Setup for loading a theme."
  (interactive)
  ;; (modus-themes-with-colors
  ;;   (custom-set-faces
  ;;    ;; `(fill-column-indicator
  ;;    ;;   ((,class :background ,(modus-themes-color 'fg-alt)))
  ;;    ))
  )

;;;###autoload
(add-hook 'modus-themes-after-load-theme-hook
          #'cfg-visual-modus-load-setup)

;;;###autoload
(defun cfg-visual-modus-init-setup ()
  "Initial setup for themes."
  (interactive)
  (when (cfg-visual-should-enable-p)
    (unless cfg-visual-loaded
      (set-face-attribute 'default nil
                          :family "JetBrains Mono"
                          :height 136)
      (load-theme (setq cfg-visual-loaded 'modus-vivendi) t))))

;;;###autoload
(add-hook 'emacs-startup-hook #'cfg-visual-modus-init-setup)

;;;###autoload
(defun cfg-visual-modus-themes-toggle ()
  "Toggle between light and dark themes."
  (interactive)
  (when (cfg-visual-should-enable-p)
    (unless cfg-visual-loaded (cfg-visual-modus-init-setup))
    (modus-themes-toggle)))

;;;###autoload
(define-keymap :keymap (current-global-map)
  "<f8>" #'cfg-visual-modus-themes-toggle)

;;;###autoload
(defun cfg-visual-after-make-frame (_)
  "Function to run after `make-frame’ to ensure theme is set."
  (unless cfg-visual-loaded
    (cfg-visual-modus-init-setup))
  (remove-hook 'after-make-frame-functions
               #'cfg-visual-after-make-frame))

;;;###autoload
(add-hook 'after-make-frame-functions
          #'cfg-visual-after-make-frame)

;;;###autoload
(defun cfg-visual-server-switch-hook ()
  "Function to run after `server-switch' to ensure theme is set.
Ref: https://stackoverflow.com/a/10284034."
  (cfg-visual-after-make-frame (window-frame)))

;;;###autoload
(add-hook 'server-switch-hook
          #'cfg-visual-server-switch-hook)

(provide 'cfg-visual)
;;; cfg-visual.el ends here.

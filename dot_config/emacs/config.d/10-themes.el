;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(modus-themes)))

;;;###autoload
(defvar cfg-themes-loaded nil "Whether a theme has been loaded.")

;;;###autoload
(defun cfg-themes-modus-load-setup ()
  (interactive)
  (modus-themes-with-colors
    (custom-set-faces
     `(fill-column-indicator
       ((,class :background ,(modus-themes-color 'fg-alt)))))))

;;;###autoload
(add-hook 'modus-themes-after-load-theme-hook
          #'cfg-themes-modus-load-setup)

;;;###autoload
(defun cfg-themes-modus-init-setup ()
  (interactive)
  (when (cfg-themes--should-enable-p)
    (unless cfg-themes-loaded
      (set-face-attribute 'default nil
                          :family "JetBrains Mono"
                          :height 136)
      (load-theme 'modus-vivendi t)
      (setq cfg-themes-loaded t))))

;;;###autoload
(defun cfg-themes--should-enable-p ()
  (declare (pure t)
           (side-effect-free t))
  (and (display-graphic-p)
       (version<= "28.1" emacs-version)))

;;;###autoload
(add-hook 'emacs-startup-hook #'cfg-themes-modus-init-setup)

;; ref: info `(modus-themes)Customization Options'
;;;###autoload
(use-package modus-themes
  :if (cfg-themes--should-enable-p)
  :commands (modus-themes-toggle
             modus-themes-with-colors)
  :custom
  (modus-themes-italic-constructs t)
  (modus-themes-bold-constructs nil)
  (modus-themes-subtle-line-numbers t)
  (modus-themes-intense-mouseovers nil)
  (modus-themes-deuteranopia nil) ; t for red-green colorblindness
  (modus-themes-tabs-accented nil)
  (modus-themes-variable-pitch-ui nil)
  (modus-themes-inhibit-reload t)
  (modus-themes-fringes 'subtle)        ; [nil, subtle, intense]
  (modus-themes-lang-checkers '(faint))
  (modus-themes-mode-line '(accented borderless))
  ;; (modus-themes-markup '(background italic))
  (modus-themes-syntax '(faint))
  (modus-themes-hl-line '(accented))
  (modus-themes-paren-match '(bold intense))
  (modus-themes-links '(neutral-underline background bold))
  (modus-themes-box-buttons '(faint accented))
  (modus-themes-promptss '(intense bold))
  (modus-themes-completions
   '((matches background extrabold)
     (selection accented)     ; for vertico, the current selection
     (popup accented)))
  (modus-themes-mail-citations 'faint)
  (modus-themes-region '(bg-only accented))
  (modus-themes-diffs 'desaturated)
  ;; org-specific ones
  (modus-themes-org-blocks 'tinted-background) ; need org-restart
  ;; (modus-themes-org-agenda TODO)
  ;; (modus-themes-headings TODO)
  (modus-themes-mixed-fonts t)

  ;; overrides
  (modus-themes-vivendi-color-overrides '((bg-main . "#111111")))
  (modus-themes-operandi-color-overrides '((bg-main . "#eeeeee"))))

;;;###autoload
(defun cfg-themes-modus-themes-toggle ()
  (interactive)
  (when (cfg-themes--should-enable-p)
    (unless cfg-themes-loaded (cfg-themes-modus-init-setup))
    (modus-themes-toggle)))

;;;###autoload
(define-keymap :keymap (current-global-map)
  "<f8>" #'cfg-themes-modus-themes-toggle)

;;;###autoload
(cfg-themes-modus-init-setup)

;;;###autoload
(defun cfg-themes-after-make-frame (frame)
  "Function to run after `make-frame’ to ensure theme is set."
  (unless cfg-themes-loaded
    (cfg-themes-modus-init-setup))
  (remove-hook 'after-make-frame-functions
               #'cfg-themes-after-make-frame))

;;;###autoload
(add-hook 'after-make-frame-functions
          #'cfg-themes-after-make-frame)

;;;###autoload
(defun cfg-themes-server-switch-hook ()
  ;; ref: https://stackoverflow.com/a/10284034
  (cfg-themes-after-make-frame (window-frame)))

;;;###autoload
(add-hook 'server-switch-hook
          #'cfg-themes-server-switch-hook)

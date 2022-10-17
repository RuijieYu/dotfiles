;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(simple-modeline powerline)))

(defun cfg-visual-modeline--gui ()
  (require 'simple-modeline)
  (require 'powerline)
  (simple-modeline-mode -1)
  (powerline-center-theme)
  (setq cfg-visual-modeline--current 'gui))

;;;###autoload
(defun cfg-visual-modeline--powerline-reset ()
  (interactive)
  (when (eq 'gui cfg-visual-modeline--current)
    (require 'powerline)
    (powerline-reset)))

;; use different modelines for different display types
;;;###autoload
(use-package simple-modeline
  :commands simple-modeline-mode)

;;;###autoload
(use-package powerline
  :commands (powerline-reset powerline-center-theme)
  :hook
  (modus-themes-after-load-theme
   . cfg-visual-modeline--powerline-reset))

;;;###autoload
(defvar cfg-visual-modeline--current nil)

;;;###autoload
(defun cfg-visual-modeline-setup ()
  "Set up modeline according to current states."
  (interactive)
  (cl-case cfg-visual-modeline--current
    ((gui))
    ((tui) (when (display-graphic-p) (cfg-visual-modeline--gui)))
    (t (if (display-graphic-p) (cfg-visual-modeline--gui)
         (simple-modeline-mode)
         (setq cfg-visual-modeline--current 'tui)))))

;;;###autoload
(add-hook 'after-change-major-mode-hook
          #'cfg-visual-modeline-setup)

;; - doom-modeline
(use-package doom-modeline
  :disabled
  :hook (after-init . doom-modeline-mode)
  :custom
  ;; sizes
  (doom-modeline-height 12)
  (doom-modeline-bar-width 6)
  ;; icons
  (doom-modeline-icon t)                ; not sure if smart
  ;; major modes
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  ;; minor modes
  (doom-modeline-minor-modes t)
  ;; misc
  (doom-modeline-enable-word-count t)
  (doom-modeline-mu4e t)
  :config
  (doom-modeline-mode))

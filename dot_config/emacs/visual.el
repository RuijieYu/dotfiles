;;; visual.el  -*- lexical-binding: t; no-byte-compile: t; -*-

;;; visual overhaul
(compile-load "pkg.el")
(compile-load "general.el")

;; - icons
(use-package all-the-icons
  ;; this will only check installed fonts when at least one GUI
  ;; window is opened
  :config
  (when (and (display-graphic-p)
	     (not (find-font (font-spec :name "all-the-icons"))))
    (all-the-icons-install-fonts t)
    ))

;; - doom-modeline
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :custom
  ;; sizes
  (doom-modeline-height 12)
  (doom-modeline-bar-width 6)
  ;; icons
  (doom-modeline-icon t)		; not sure if smart
  ;; major modes
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  ;; minor modes
  (doom-modeline-minor-modes t)
  ;; misc
  (doom-modeline-enable-word-count t)
  (doom-modeline-mu4e nil)
  :config
  (doom-modeline-mode)
  )

;; - doom-themes
(use-package doom-themes
  :demand t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-gruvbox t)
  ;; ?
  (doom-themes-neotree-config)
  (doom-themes-org-config)
  )

(defalias 'counsel-load-theme #'load-theme)
(global-set-key
 [C-tab ?t ?t] #'counsel-load-theme)
;; (with-eval-after-load 'general
  
;;   ;; (cfg-keybind--leader
;;   ;;   "t" '(:ignore t :which-key "theme")
;;   ;;   "tt" '(counsel-load-theme
;;   ;;          :which-key "select theme"))
;;   )

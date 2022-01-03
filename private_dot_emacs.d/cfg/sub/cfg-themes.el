(require 'cfg-package)
(require 'cfg-general)

;; allow myself to select different themes at my leasure
(cfg-keybind--leader
  "t" '(:ignore t :which-key "theme")
  "tt" '(counsel-load-theme
	 :which-key "select theme")
  )

;; by default, select a doom theme
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t
	)

  ;; TODO I usually use terminal, need to find a solution / compromise
  ;; for having too colorful colors, weird colors and weird keybinds
  ;; on terminal. For now, I would need to manually `require'
  ;; 'cfg-enable-gui when I want gui features
  (with-eval-after-load 'cfg-enable-gui
    (load-theme 'doom-gruvbox t)

    ;; TODO need more document reading here
    ;; (doom-themes-visual-bell-config) ; visual bell is not for me
    (doom-themes-neotree-config) ; testing
    (doom-themes-org-config) ; testing
    )
  )

(provide 'cfg-themes)

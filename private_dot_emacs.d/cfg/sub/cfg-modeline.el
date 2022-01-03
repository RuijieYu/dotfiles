(require 'cfg-package)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  ;; :custom-face
  ;; (mode-line ((t (:height .85))))
  ;; (mode-line-inactive ((t (:height .85))))
  :hook (after-init . doom-modeline-mode)
  :custom
  ;; ref: https://github.com/seagle0128/doom-modeline under readme
  ;; sizes
  (doom-modeline-height 12)
  (doom-modeline-bar-width 6)
  ;; icons
  (doom-modeline-icon (display-graphic-p)) ; only gui
  ;; major modes
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  ;; minor modes
  (doom-modeline-minor-modes t)		; whether to show
  ;; misc
  (doom-modeline-enable-word-count nil)
  (doom-modeline-mu4e nil)
  )

(provide 'cfg-modeline)

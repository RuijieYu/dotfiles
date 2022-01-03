(require 'cfg-package)

;; well, fcitx never worked and now I am on wayland
(use-package pyim
  :ensure t
  :bind
  ("<M-j>" . pyim-convert-string-at-point)
  :custom
  (pyim-english-input-switch-functions
   '(pyim-probe-dynamic-english
     pyim-probeprogram-mode))
  ;; half-width punctuations
  (pyim-punctuation-half-width-functions
   '(pyim-probe-punctuation-line-beginning
     pyim-probe-punctuation-after-punctuation))
  ;; popup?
  (pyim-page-tooltip 'popup)
  ;; probably don't need other input methods (other than latex and
  ;; greek?)
  (default-input-method "pyim")
  )

(provide 'cfg-pyim)

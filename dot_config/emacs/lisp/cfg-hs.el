;;; cfg-hs.el --- Configure code folding in hideshow

;;; Commentary:

;;; Code:
(defvar hs-minor-mode-map)
(autoload 'hs-hide-all "hideshow")
(autoload 'hs-hide-block "hideshow")
(autoload 'hs-hide-level "hideshow")
(autoload 'hs-show-all "hideshow")
(autoload 'hs-show-block "hideshow")
(autoload 'hs-toggle-hiding "hideshow")


(defvar-keymap cfg-hs-map
  :doc "Custom keymap for `hideshow' under \"C-<tab> h\"."
  "a" #'hs-show-all
  "c" #'hs-toggle-hiding
  "d" #'hs-hide-block
  "e" #'hs-toggle-hiding
  "h" #'hs-hide-block
  "l" #'hs-hide-level
  "s" #'hs-show-block
  "t" #'hs-hide-all
  "M-h" #'hs-hide-all
  "M-s" #'hs-show-all)


(with-eval-after-load 'hideshow
  (define-keymap :keymap hs-minor-mode-map
    "C-<tab> C-h" (keymap-lookup hs-minor-mode-map "C-c @")
    "C-<tab> h" cfg-hs-map))


(add-hook 'prog-mode-hook #'hs-minor-mode)


(provide 'cfg-hs)
;;; cfg-hs.el ends here.

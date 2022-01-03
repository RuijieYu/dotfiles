;; provide prefix-style keybindings
(require 'cfg-package)
(require 'bind-key)

(use-package general
  :ensure t
  :config
  ;; create prefix keydef functions
  (general-create-definer
   cfg-keybind--leader
   :prefix "<C-tab>"
   )
  (general-create-definer
   cfg-keybind--C-c
   :prefix "<C-c>"
   )
  )

(provide 'cfg-general)

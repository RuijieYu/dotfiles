(require 'cfg-package)
(require 'cfg-general)

(use-package hydra
  :ensure t
  :config
  (declare-function hydra-default-pre load-file-name)
  (declare-function hydra-keyboard-quit load-file-name)
  (declare-function hydra--call-interactively-remap-maybe load-file-name)
  (declare-function hydra-show-hint load-file-name)
  (declare-function hydra-set-transient-map load-file-name)
  (declare-function hydra-timeout load-file-name)
  
  (defhydra cfg--text-scale (:timeout 5)
    "text scaling"
    ("j" text-scale-increase "zoom in")
    ("k" text-scale-decrease "zoom out")
    ("<RET>" nil "finish" :exit t)
    ("f" nil "" :exit t)
    ("q" nil "" :exit t)
    )
  (cfg-keybind--leader
    "s" '(cfg--text-scale/body
	  :which-key "text scaling")
    )
  )

;; set default scaling
(use-package default-text-scale
  :ensure t
  :config
  (default-text-scale-mode)
  )

(provide 'cfg-text-scale)

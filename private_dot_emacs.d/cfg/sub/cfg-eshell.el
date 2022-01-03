(require 'cfg-package)
(require 'cfg-general)

(use-package eshell-git-prompt
  :ensure t
  :after eshell
  :config
  (eshell-git-prompt-use-theme 'powerline)
  )

(use-package esh-opt
  :ensure nil
  :custom
  (eshell-destroy-buffer-when-process-dies t)
  (eshell-visual-commands
   '("htop" "btop"
     "bash" "zsh" "fish"
     "vim" "less" "more" "man"))
  )

(use-package esh-mode
  :ensure nil
  :config
  (declare-function eshell-truncate-buffer ())
  )

(use-package eshell
  :ensure nil
  :requires (esh-mode
	     esh-opt)
  :commands eshell
  :hook
  (eshell-pre-command . eshell-save-some-history)
  (eshell-first-time-mode
   . (lambda ()
       (push #'eshell-truncate-buffer
	     eshell-output-filter-functions)))
  (eshell-mode
   . (lambda () (display-line-numbers-mode -1)))
  :custom
  (eshell-history-size 10000)
  (eshell-buffer-maximum-lines 10000)
  (eshell-hist-ignoredups t)
  (eshell-scroll-to-bottom-on-input t)
  :config
  (cfg-keybind--leader
    "<RET>" #'eshell
    "<C-return>" #'eshell
    )
  )

(use-package eshell-syntax-highlighting
  :ensure t
  :after esh-mode
  :config
  (eshell-syntax-highlighting-global-mode)
  )

(provide 'cfg-eshell)

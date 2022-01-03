(require 'cfg-package)

(use-package llvm-mode
  ;; installed in AUR as emacs-llvm-mode
  :ensure nil
  :load-path "/usr/share/emacs/site-lisp/emacs-llvm-mode"
  :mode
  ("\\.ll\\'" . llvm-mode)
  )

(provide 'cfg-llvm)

(require 'cfg-package)

(use-package ediff
  :ensure nil
  :commands (ediff
	     ediff-files)
  :custom
  (ediff-diff-options "-w")
  (ediff-swplit-window-function
   #'split-window-horizontally)
  (ediff-window-setup-function
   #'ediff-setup-windows-plain)
  )

(provide 'cfg-ediff)

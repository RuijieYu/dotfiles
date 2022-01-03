(require 'cfg-package)

(use-package expand-region
  :ensure t
  :bind
  ("<M-[>" . er/expand-region)
  ("<M-]>" . er/contract-region)
  ;; the following does not work in tty
  ("<C-(>" . er/mark-outside-pairs)
  ("<C-)>" . er/mark-inside-pairs)
  )

(provide 'cfg-selection)

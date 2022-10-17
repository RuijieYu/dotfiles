;; -*- no-byte-compile: t; -*-
(use-package pdf-tools
  :disabled
  :mode ((rx ".pdf" string-end) . pdf-view-mode)
  :commands pdf-view-mode
  :hook
  (pdf-view-mode . auto-revert-mode)
  :config
  ;; disable dependencies
  (pdf-tools-install :no-query nil))

()

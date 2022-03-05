;; lsp.el -*- no-byte-compile: t; lexical-binding: t; -*-
(load (expand-file-name "pkg.el" user-emacs-directory))

;; lsp
(use-package lsp-mode
  :commands lsp
  ;; sometimes lsp does not start, enable lsp manually
  :bind ([?\s-l ?\s-l] . lsp)
  )

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  )

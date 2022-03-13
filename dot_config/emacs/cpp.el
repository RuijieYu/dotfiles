;; -*- no-byte-compile: t; lexical-binding: t; -*-
(cfg-load "lsp.el")

(use-package lsp-mode
  :hook
  (c++-mode . lsp)
  (c++-mode . flyspell-prog-mode)
  )

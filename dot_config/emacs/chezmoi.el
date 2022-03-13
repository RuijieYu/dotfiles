;; chezmoi.el  -*- no-byte-compile: t; -*-
(cfg-load "pkg.el")

(use-package chezmoi
  :demand t
  :after (magit
          dired)
  )

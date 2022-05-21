;; racket.el  -*- no-byte-compile: t; lexical-binding: t; -*-
(cfg-load "pkg.el")

(use-package racket-mode
  :hook
  (racket-mode . racket-smart-open-bracket-mode)
  (racket-mode . racket-xp-mode)
  (racket-mode . electric-pair-local-mode)
  (racket-repl-mode . electric-pair-local-mode)
  :diminish
  (racket-smart-open-bracket-mode . "rkt\\(")
  )

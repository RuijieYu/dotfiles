;; racket.el  -*- no-byte-compile: t; lexical-binding: t; -*-
(load (expand-file-name "pkg.el" user-emacs-directory))

(use-package racket-mode
  :hook
  ((racket-mode . racket-smart-open-bracket-mode)
   (racket-mode . racket-xp-mode)
   (racket-repl-mode
    . (lambda () (local-set-key [?\C-i] [?\C-\M-i])))
   )
  :diminish
  ((racket-smart-open-bracket-mode . "rkt\\(")
   )
  )

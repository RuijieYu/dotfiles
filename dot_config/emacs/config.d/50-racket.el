;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(racket-mode diminish)))

(defun cfg-racket-common-setup ()
  (interactive)
  (electric-pair-local-mode))

;;;###autoload
(defun cfg-racket-setup ()
  (interactive)
  (cfg-racket-common-setup)
  (racket-smart-open-bracket-mode)
  (racket-xp-mode))

;;;###autoload
(defun cfg-racket-repl-setup ()
  (interactive)
  (cfg--racket-common-setup))

;;;###autoload
(use-package racket-mode
  :hook
  (racket-mode . cfg-racket-setup)
  (racket-repl-mode . cfg-racket-repl-setup)
  :diminish
  (racket-smart-open-bracket-mode . "rkt\\(")
  :commands (racket-xp-mode
             racket-smart-open-bracket-mode)
  :config
  (dolist (f '(term-let derivation->pict))
    (put f 'scheme-indent-function 1))
  (dolist (f '(redex-let redex-let* fun))
    (put f 'scheme-indent-function 2)))

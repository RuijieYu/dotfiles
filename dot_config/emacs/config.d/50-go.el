;; -*- no-byte-compile: t; -*-
;; do not compile this file -- apparently "go" package is
;; problematic

(eval-when-compile
  (load (expand-file-name "utils/cfg-load" user-emacs-directory))
  (cfg-load "pkg" "utils")
  (preload '()))

;;;###autoload
(add-to-path "~/go/bin")

;;;###autoload
(defun cfg-go-setup ()
  (interactive)
  (lsp-deferred)
  (setq-local fill-column 80))

;;;###autoload
(use-package go
  :hook
  (go-mode . cfg-go-setup))

;; pkg.el -*- lexical-binding: t; fill-column: 66; no-byte-compile: t; -*-

;; bootstrap straight.el
(setq package-enable-at-startup nil)
(defvar bootstrap-version)
(let* ((straight-el
	(expand-file-name
	 "straight/repos/straight.el"
	 user-emacs-directory))
       (bootstrap-file
	(concat straight-el "/bootstrap.el"))
       (bootstrap-version 5))
  ;; make sure the repository exists
  (unless (file-exists-p bootstrap-file)
    ;; make sure git exists
    (unless (executable-find "git")
      (error "Require \"git\"."))
    (shell-command
     (format "git clone %s %s"
	     "https://github.com/raxod502/straight.el"
	     straight-el)))
  (load bootstrap-file nil 'nomessage))
(setq straight-use-package-by-default t
      )

;; ensure installation of use-package
(straight-use-package 'use-package)

;; configure use-package's default behavior
(setq use-package-always-defer t
      )

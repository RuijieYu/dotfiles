;; early-init.el  -*- lexical-binding: t; no-byte-compile: t; -*-

;; disable package auto-enable
(setq package-enable-at-startup nil)

;; always prefer newer file for loading
(setq load-prefer-newer t)

;; add autoloads directory
(let ((autoloads (expand-file-name "autoloads" user-emacs-directory)))
  (add-to-list 'load-path autoloads))

;; for debugging purposes
(setq force-load-messages init-file-debug)

;; constants
(defconst cfg--early-dir
  (expand-file-name "early-config.d" user-emacs-directory)
  "Directory of *.el files (compiled and) loaded at the end of
early-init stage.")
(defconst cfg--init-dir
  (expand-file-name "config.d" user-emacs-directory)
  "Directory of *.el files (compiled and) loaded at the end of init
stage.  Files are byte-compiled (if enabled) and loaded
alphanumerically.")

;; during compilation, generate autoloads for utils
(eval-when-compile
  (load (expand-file-name
         "utils/control-dir" user-emacs-directory)
        nil 'nomessage)
  (cfg-control-dir "utils" "autoloads/utils.el"))
(load "utils" nil 'nomessage)

;; Load a list of files during early-init stage.  This should be
;; kept minimal.
;; (cfg-load-recurse cfg--early-dir)
(cfg-control-dir cfg--early-dir "autoloads/early.el")

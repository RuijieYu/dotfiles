;;; cfg --- my personal configuration package

;; ref: https://config.daviwil.com/emacs

;; first, increase GC limit to *a lot*
(setq gc-cons-percentage
      ;; 512MiB
      (* 512 1024 1024))
(add-hook
 'emacs-startup-hook
 (lambda ()
   (message "** Emacs loaded in %s with %d GCs."
	    (format "%.2fs"
		    (float-time
		     (time-subtract
		      after-init-time
		      before-init-time)))
	    gcs-done)))

;; then, include all the other files (under sub/)
(eval-and-compile
  (push (expand-file-name "~/.emacs.d/cfg/sub")
	load-path))

;; (require 'cfg-package)
(require 'cfg-general)
(require 'cfg-encoding)
(require 'cfg-scroll)
(require 'cfg-invert-color)
(require 'cfg-icons)
(require 'cfg-modeline)
(require 'cfg-startup)
(require 'cfg-text-scale)
(require 'cfg-themes)
(require 'cfg-which-key)
(require 'cfg-elisp-ref)
(require 'cfg-auto-revert)
(require 'cfg-tramp)
(require 'cfg-subedit)
(require 'cfg-swiper)
(require 'cfg-complete)
(require 'cfg-hist)
(require 'cfg-buf-manage)
(require 'cfg-win-sel)
(require 'cfg-selection)
(require 'cfg-auth)
(require 'cfg-dired)
(require 'cfg-openwith)
(require 'cfg-pdf)
(require 'cfg-org)
(require 'cfg-calc)
(require 'cfg-git)
(require 'cfg-check)
(require 'cfg-llvm)
;; TODO go, haskell
(require 'cfg-python)
(require 'cfg-snippets)
(require 'cfg-cpp)
(require 'cfg-rainbow)
(require 'cfg-terms)
(require 'cfg-ediff)
(require 'cfg-disable-mouse)
(require 'cfg-pyim)
;; (require 'cfg-enable-gui) ; only when I need gui

;; finally, decrease GC limit to a sane number
(setq gc-cons-percentage
      ;; 2MiB
      (* 2 1024 1024))

(provide 'cfg)

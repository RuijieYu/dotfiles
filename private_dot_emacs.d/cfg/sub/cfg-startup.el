(require 'cfg-package)

;; various minor modes to minimize UI
(use-package scroll-bar
  :ensure nil
  :config
  (declare-function scroll-bar-mode load-file-name)
  (scroll-bar-mode -1))
(with-eval-after-load 'tool-bar
  (tool-bar-mode -1))
(with-eval-after-load 'tooltip
  (tooltip-mode -1))			; show tooltip in minibuffer
					; instead of pop-up window
(with-eval-after-load 'menu-bar
  (menu-bar-mode -1))
(with-eval-after-load 'simple
  (column-number-mode t))		; show column numbers
(with-eval-after-load 'display-line-numbers
  (global-display-line-numbers-mode 1)
  (dolist (mode '(term-mode-hook
		  shell-mode-hook
		  eshell-mode-hook
		  doc-view-minor-mode-hook
		  pdf-view-mode-hook
		  ))
    (add-hook mode (lambda () (display-line-numbers-mode -1)))))

;; various startup configurations
(require 'mwheel)
(require 'files)
(require 'vc-hooks)
(setq
 inhibit-startup-message t  ; thanks for the help, but see you no more
 mouse-wheel-scroll-amount '(1 ((shift) . 1)) ; scroll one line each time
 mouse-wheel-progressive-speed nil	      ; don't accelerate scroll
 mouse-wheel-follow-mouse t		      ; scroll window under mouse
 scroll-step 1				      ; keyboard scroll
 use-dialog-box nil			      ; disable dialog boxes
 large-file-warning-threshold nil	      ; don't warn about large files
 vc-follow-symlinks t			      ; don't ask, yes always
 )

(setq-default
 full-column 80				; short lines
 indent-tabs-mode nil			; whether to use tab
 )

;; for modes such as makefile, tabs must be used
(with-eval-after-load 'make-mode
  (add-hook 'makefile-mode-hook
	    (lambda () (setq-local indent-tabs-mode 'only))))

(provide 'cfg-startup)

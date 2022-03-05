;; early-init.el  -*- lexical-binding: t; fill-column: 66; no-byte-compile: t; -*-

;; disable package auto-enable
(setq package-enable-at-startup nil
      )

;; set default encoding
(set-default-coding-systems 'utf-8)

;; set scrolling
(global-set-key [?\M-n] [?\M-1 ?\C-v])
(global-set-key [?\M-p] [?\M-1 ?\M-v])

;; UI minimization
(setq
 inhibit-startup-message t		; thanks but see you no more
 mouse-wheel-scroll-amount '(1 ((shift) . 1)) ; scroll one line each time
 mouse-wheel-progressive-speed nil	; don't accelerate scrolling
 mouse-wheel-follow-mouse t
 scroll-step 1				; keyboard scrolling
 use-dialog-box nil
 large-file-warning-threshold nil	; I know what I'm doing
 vc-follow-symlinks t			; don't ask
 )

(setq-default
 full-column 66				; much shorter lines
 indent-tabs-mode nil			; no tabs
 )

(with-eval-after-load 'make-mode
  ;; makefile requires tabs
  (add-hook 'makefile-mode-hook
	    (lambda () (setq-local indent-tabs-mode 'only))))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1) ; show tooltip in minibuffer instead of pop-up window
(menu-bar-mode -1)
(column-number-mode 1)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; set a shortcut to compile-and-load a file
(defsubst compile-load (el-file &optional noerror)
  "Compile and load the file EL-FILE, if it exists, assuming that
it is of the form *.el.  Otherwise fail.  Use
`user-emacs-directory' as the base directory.  When NOERROR is
non-nil, no error is thrown if the file is absent."
  (let ((default-directory user-emacs-directory)
	(file-exists (file-exists-p el-file)))
    (cond
     ;; error when file does not exist without NOERROR
     ((not (or file-exists noerror))
      (error (format "The file cannot be found: %s" el-file)))
     ;; when file does not exist with NOERROR
     ((not file-exists) nil)
     ;; otherwise, compile when newer source
     (t (let ((elc-file (concat el-file "c"))
	      (bare-name (file-name-sans-extension el-file)))
	  ;; compile unless elc time >= el time
	  (unless (and (file-exists-p elc-file)
		       (not (file-newer-than-file-p el-file elc-file)))
	    (byte-compile-file el-file))
	  ;; then load the file
	  (load bare-name :noerror :nomessage)))
     )))

;; set prefer newer file between *.el and *.elc, and point to
;; customized custom-file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory)
      load-prefer-newer t
      )
(when (file-exists-p custom-file)
  (compile-load custom-file))

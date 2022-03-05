;;   -*- lexical-binding: t; no-byte-compile: t; -*-

;; change gc temporarily before starting
(setq gc-cons-threshold
      ;; 4 GiB
      (* 4 1024 1024 1024)
      )
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (message "** Emacs loaded in %s with %d GCs."
		     (format "%.2fs"
			     (float-time
			      (time-subtract
			       after-init-time
			       before-init-time)))
		     gc-elapsed)
	    (setq gc-cons-threshold
		  ;; 256 MiB
		  (* 256 1024 1024)
		  )))

;; compile and load each file sequentially, only if they exist
(let* ((config-file (expand-file-name
		     "config.el" user-emacs-directory))
       (all-files `(,config-file
		    ))
       )
  (dolist (file all-files)
    (compile-load file :noerror)
    ))

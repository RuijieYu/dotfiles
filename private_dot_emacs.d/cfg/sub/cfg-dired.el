(require 'cfg-package)

(with-eval-after-load 'cfg-enable-gui
  (use-package all-the-icons-dired
    :ensure t
    :if (display-graphic-p)
    :requires all-the-icons
    :hook
    (dired-mode . (lambda () (when (display-graphic-p)
			       (all-the-icons-dired-mode))))
    )
  )

;; dired-omit-mode is bound to <C-x><M-o> in dired
(use-package dired-x
  :ensure nil
  :after (dired rx)
  :preface (require 'rx)
  :hook
  (dired-mode . dired-omit-mode)
  ;; hide-details-mode is bound to "(" in dired-mode
  :custom
  ;; dired-omit-extensions alredy contains "~" and "elc"
  (dired-omit-files
   (rx (or (seq string-start ".." string-end)
	   ;; (seq ?~ string-end)
	   (seq string-start ".#")
	   )))
  (dired-omit-verbose nil)	  
  )

(use-package dired
  :ensure nil
  :custom
  (dired-listing-switches
   (concat "--all "
	   "--human-readable "
	   "-go " ; like -l, -g omits group, -o omits user
	   "--group-directories-first "))
  (delete-by-moving-to-trash t)
  (dired-ls-F-marks-symlinks t)
  )

;; TODO: check the following configs and see if they fit my workflow
;; dired-rainbow, dired-single, dired-ranger, dired-collapse

(provide 'cfg-dired)

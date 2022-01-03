(require 'cfg-package)

;; not sure how this works with daemons, need further testing
(use-package all-the-icons
  :ensure t
  :config
  ;; only load when 
  (when (and (display-graphic-p)
	     (not (find-font (font-spec
			      :name "all-the-icons"))))
    (all-the-icons-install-fonts t)
    )
  )

(provide 'cfg-icons)

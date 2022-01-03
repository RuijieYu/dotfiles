(require 'cfg-package)

(use-package jupyter
  :ensure t
  :after (org
	  python)
  :custom
  (org-babel-default-header-args:jupyter-python
   '((:async . "yes")
     (:kernel . "python3")
     (:eval . "never-export")
     (:exports . "both")
     ))
  :defines org-babel-load-languages
  :config
  (dolist (lang '((python . t)
		  (jupyter . t)))
    (push lang org-babel-load-languages))
  (org-babel-do-load-languages
   'org-babel-load-languages
   org-babel-load-languages)
  )

(use-package python
  :ensure nil
  )

(use-package yapfify
  :ensure t
  :diminish yapf-mode
  :hook (python-mode . yapf-mode)
  )

(provide 'cfg-python)

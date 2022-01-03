(require 'cfg-package)
(require 'cfg-diminish)

(use-package org
  :ensure t
  :diminish
  (ispell-minor-mode
   auto-fill-mode
   org-indent-mode
   org-num-mode)
  :hook
  (org-mode . org-num-mode)
  (org-mode . auto-fill-mode)
  ;; (org-mode . visual-line-mode)
  (org-mode . ispell-minor-mode)
  (org-mode . org-indent-mode)
  :preface
  (declare-function org-insert-structure-template load-file-name)
  :bind
  (:map org-mode-map
	("<C-->" . #'org-insert-structure-template)
	)
  :custom
  (org-src-preserve-indentation t)
  (org-ellipsis " ▾")
  (org-hide-emphasis-markers t)
  (org-src-fontify-natively t)
  (org-fontify-quote-and-verse-blocks t)
  (org-src-tab-acts-natively t)
  ;; (org-edit-src-content-indentation 2)
  (org-hide-block-startup nil)
  (org-startup-folded 'content)
  (org-cycle-separator-lines 2)

  :config
  ;; show bullet points as unicode
  (font-lock-add-keywords
   'org-mode
   '(("^ +\\([-*]\\) "
      (0
       (prog1 ()
	 (compose-region
	  (match-beginning 1)
	  (match-end 1)
	  "•"))))))
  )

;; allow markdown export
(use-package ox-md
  :ensure nil
  :requires org
  )

;; auto-show latex snippet
(use-package org-fragtog
  :ensure t
  :diminish
  :hook
  (org-mode . org-fragtog-mode)
  )

;; auto-show markup symbols
(use-package org-appear
  :ensure t
  :diminish
  :hook
  (org-mode . org-appear-mode)
  )

;; src block templates
(use-package org-tempo
  :ensure nil
  :after org
  :config
  (dolist (pair '(("sh" . "sh")
		  ("el" . "emacs-lisp")
		  ("py" . "python")
		  ("jp" . "jupyter-python")
		  ))
    (push (cons (car pair)
		(concat "src " (cdr pair)))
	  org-structure-template-alist)
    )
  )



;; TODO: org-pomodoro ; org-present | org-tree-slide ;

(require 'cfg-org-roam)
(provide 'cfg-org)

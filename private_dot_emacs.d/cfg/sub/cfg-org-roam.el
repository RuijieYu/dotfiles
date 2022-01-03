(require 'cfg-package)
(require 'cfg-general)
;; required by cfg-org

(use-package org-roam
  :ensure t
  :init
  (defvar org-roam-v2-ack)
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (expand-file-name "~/.local/share/org-roam"))
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
      '(
        ("a" "agenda" plain
         "* TODO %?"
         :if-new
	 (file+head
	  "%<%Y%m%d%H%M%S>-${slug}-agenda.org"
	  "#+title: ${title}\n#+filetags: agenda")
         :unnarrowed t)
        ("d" "default" plain
         "%?"
         :if-new
	 (file+head
	  "%<%Y%m%d%H%M%S>-${slug}.org"
	  "#+title: ${title}")
         :unnarrowed t)
        ))
  :bind
  (:map org-mode-map
	("<C-M-i>" . completion-at-point)
	)
  :functions (org-roam-buffer-toggle
	      org-roam-node-find
	      org-roam-node-insert)
  :config
  (declare-function org-roam-buffer-toggle load-file-name)
  (declare-function org-roam-node-find load-file-name)
  (declare-function org-roam-node-insert load-file-name)
  
  (when (file-exists-p org-roam-directory)
    (org-roam-db-autosync-mode))

  ;; TODO integrate with agendas
  
  ;; additional keybinds
  (cfg-keybind--C-c
    "n" '(:ignore t :which-key "org-roam")
    "nl" #'org-roam-buffer-toggle
    "nf" #'org-roam-node-find
    "ni" #'org-roam-node-insert
    )
  )

(provide 'cfg-org-roam)

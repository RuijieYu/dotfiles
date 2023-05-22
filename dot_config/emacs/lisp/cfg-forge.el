;;; cfg-forge.el --- Install and configure forge  -*- no-byte-compile: t; -*-

;;; Commentary:

;;; Code:
(eval-when-compile (require 'cfg-require))
(require 'package)
(cfg-require
  :package compat markdown-mode dash f s
  :vc-local
  ;; :url "https://github.com/magit/closql"
  (closql "/opt/src/emacs/packages/closql/local" "local")
  ;; :url "https://github.com/magit/ghub"
  ;; :lisp-dir "lisp"
  (ghub "/opt/src/emacs/packages/ghub/local" "local")
  ;; :url "https://github.com/nlamirault/emacs-gitlab"
  (glab "/opt/src/emacs/packages/glab/local" "local")
  ;; :url "https://github.com/magit/emacsql"
  (emacsql "/opt/src/emacs/packages/emacsql/local" "local")
  ;; :url "https://github.com/zkry/yaml.el"
  (yaml "/opt/src/emacs/packages/yaml/local" "local")
  ;; :url "https://github.com/volrath/treepy.el"
  (treepy "/opt/src/emacs/packages/treepy/local" "local")
  ;; :url "https://github.com/magit/forge" :lisp-dir "lisp"
  (forge "/opt/src/emacs/packages/forge/local" "local"))

(require 'cfg-magit)
(require 'cfg-package)
(require 'cfg-package-vc)
(cfg-package-install '(compat markdown-mode))
(cfg-package-vc-install
 nil '((forge :url "https://github.com/magit/forge"
              :lisp-dir "lisp")
       (closql :url "https://github.com/magit/closql")
       (ghub :url "https://github.com/magit/ghub"
             :lisp-dir "lisp")
       (glab :url "https://github.com/nlamirault/emacs-gitlab")
       (emacsql :url "https://github.com/magit/emacsql")
       (yaml :url "https://github.com/zkry/yaml.el")
       (treepy :url "https://github.com/volrath/treepy.el")))

(require 'forge-list)
(require 'forge)


(defvar-keymap cfg-forge-list-map
  "i" #'forge-list-issues
  "p" #'forge-list-pullreqs
  "t" #'forge-list-topics
  "r" #'forge-list-repositories)

(defvar-keymap cfg-forge-view-map
  "i" #'forge-visit-issue
  "p" #'forge-visit-pullreq
  "t" #'forge-visit-topic
  "r" #'forge-visit-repository)

(defvar-keymap cfg-forge-browse-map
  "b" #'forge-browse-dwim
  "i" #'forge-browse-issue
  "t" #'forge-browse-topic
  "p" #'forge-browse-pullreq
  "r" #'forge-browse-repository
  "w" #'forge-browse-remote
  "c" #'forge-browse-commit
  ;; "local branch" from magit
  "l" #'forge-browse-branch)

(defvar-keymap cfg-forge-create-map
  "i" #'forge-create-issue
  "c" #'forge-create-post
  "p" #'forge-create-pullreq)

(defvar-keymap cfg-forge-map
  :doc "Keymap for forge."
  "l" (cons "forge->list" cfg-forge-list-map)
  "v" (cons "forge->view" cfg-forge-view-map)
  "b" (cons "forge->browse" cfg-forge-browse-map)
  "B" #'forge-browse
  "W" #'forge-browse-remote
  "w" #'forge-browse-dwim
  "g" #'forge-pull
  "G" #'forge-pull-topic
  "c" (cons "forge->create" cfg-forge-create-map))

(with-eval-after-load 'forge
  (with-eval-after-load 'magit
    (define-keymap :keymap magit-mode-map
      ";" (cons "forge" cfg-forge-map))))

(provide 'cfg-forge)
;;; cfg-forge.el ends here.

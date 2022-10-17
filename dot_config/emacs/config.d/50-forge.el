;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(forge)))

;;;###autoload
(defvar-keymap cfg-forge--list-map
  "i" #'forge-list-issues
  "p" #'forge-list-pullreqs
  "t" #'forge-list-topics
  "r" #'forge-list-repositories)

;;;###autoload
(defvar-keymap cfg-forge--view-map
  "i" #'forge-visit-issue
  "p" #'forge-visit-pullreq
  "t" #'forge-visit-topic
  "r" #'forge-visit-repository)

;;;###autoload
(defvar-keymap cfg-forge--browse-map
  "b" #'forge-browse-dwim
  "i" #'forge-browse-issue
  "t" #'forge-browse-topic
  "p" #'forge-browse-pullreq
  "r" #'forge-browse-repository
  "w" #'forge-browse-remote
  "c" #'forge-browse-commit
  ;; "local branch" from magit
  "l" #'forge-browse-branch)

;;;###autoload
(defvar-keymap cfg-forge--create-map
  "i" #'forge-create-issue
  "c" #'forge-create-post
  "p" #'forge-create-pullreq)

;;;###autoload
(defvar-keymap cfg-forge-map
  :doc "Keymap for forge."
  "l" (cons "forge->list" cfg-forge--list-map)
  "v" (cons "forge->view" cfg-forge--view-map)
  "b" (cons "forge->browse" cfg-forge--browse-map)
  "B" #'forge-browse
  "W" #'forge-browse-remote
  "w" #'forge-browse-dwim
  "g" #'forge-pull
  "G" #'forge-pull-topic
  "c" (cons "forge->create" cfg-forge--create-map))

;;;###autoload
(use-package forge
  :after magit
  :config
  (define-keymap :keymap magit-mode-map
    ";" (cons "forge" cfg-forge-map)))

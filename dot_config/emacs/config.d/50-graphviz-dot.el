;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(graphviz-dot-mode)))

;;;###autoload
(use-package graphviz-dot-mode
  :mode ((rx ".dot" string-end) . graphviz-dot-mode)
  :custom
  (graphviz-dot-indent-width tab-width)
  ;; I use imv for viewing images
  (graphviz-dot-view-command "imv %s"))

;;;###autoload
(with-eval-after-load 'org
  (cfg-org-babel-load-languages dot t))

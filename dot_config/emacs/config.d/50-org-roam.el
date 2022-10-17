;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(org-roam org-roam-ui)))

;;;###autoload
(use-package org-roam
  :after org)

;;;###autoload
(use-package org-roam-ui
  :after org-roam)

;;;  -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;; always display the vertical bar at fill column
;;;###autoload
(use-package display-fill-column-indicator
  :straight nil
  :hook
  (after-init . global-display-fill-column-indicator-mode))

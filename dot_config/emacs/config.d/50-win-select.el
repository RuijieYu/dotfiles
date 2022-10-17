;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(ace-window)))

;;;###autoload
(use-package ace-window
  :hook
  (after-init . ace-window-display-mode)
  :custom
  (aw-scope 'frame)
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-minibuffer-flag t)
  :config
  (define-keymap :keymap (current-global-map)
    "M-o" #'ace-window)
  (define-remap (current-global-map)
    [remap other-window] #'ace-window))

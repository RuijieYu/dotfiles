;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(yasnippet diminish)))

;;;###autoload
(use-package yasnippet
  :diminish yas-minor-mode
  :hook
  (prog-mode . yas-minor-mode)
  (after-init . yas-reload-all))

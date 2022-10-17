;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(editorconfig)))

;; only when in lsp-mode (a project) do I need to follow someone
;; else's formatting guidelines
;;;###autoload
(use-package editorconfig
  :after lsp-mode
  :diminish " EC"
  :hook
  (lsp-mode . editorconfig-mode))

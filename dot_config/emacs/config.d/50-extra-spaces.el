;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(delete-nl-spaces diminish)))

;;;###autoload
(use-package delete-nl-spaces
  :commands delete-nl-spaces-mode
  :diminish
  :hook
  (prog-mode . delete-nl-spaces-mode)
  (text-mode . delete-nl-spaces-mode))

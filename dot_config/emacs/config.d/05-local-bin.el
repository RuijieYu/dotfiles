;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (load (expand-file-name "utils/cfg-load" user-emacs-directory))
  (cfg-load "pkg" "utils")
  (preload '()))

;;;###autoload
(add-to-path "~/.local/bin")

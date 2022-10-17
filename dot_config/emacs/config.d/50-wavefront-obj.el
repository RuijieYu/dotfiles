;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(wavefront-obj-mode)))

;;;###autoload
(use-package wavefront-obj-mode
  :mode (rx ".obj" string-end))

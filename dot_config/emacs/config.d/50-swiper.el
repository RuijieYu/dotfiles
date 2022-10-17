;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(swiper)))

;;;###autoload
(use-package swiper
  :commands swiper)

;;;###autoload
(define-remap (current-global-map)
  [remap isearch-forward] #'swiper)

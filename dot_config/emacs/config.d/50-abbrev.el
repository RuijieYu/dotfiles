;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(diminish)))

;;;###autoload
(use-package abbrev                     ; I don't use abbrev
  :straight nil
  ;; even if it was enabled, hide it
  :after diminish
  :diminish
  ;; disable it
  :hook
  (fundamental-mode . (lambda () (abbrev-mode 0))))

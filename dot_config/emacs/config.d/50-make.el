;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(modus-themes)))

;;;###autoload
(defun cfg-make-setup ()
  (setq-local fill-column 80
              ;; makefile requires tabs
              indent-tabs-mode 'only))

;;;###autoload
(use-package make-mode
  :straight nil
  :hook
  (makefile-mode . cfg-make-setup))

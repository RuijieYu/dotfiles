;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;;;###autoload
(defun cfg-pretty-prog-setup ()
  (interactive)
  (unless (version< "24.4" emacs-version)
    (global-prettify-symbols-mode)))

;;;###autoload
(use-package prog-mode
  :straight nil
  :hook
  (prog-mode . cfg-pretty-prog-setup))

;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(all-the-icons)))

;;;###autoload
(defvar cfg-themes-icons--setup-completed nil)

;;;###autoload
(defun cfg-themes-icons--setup ()
  (interactive)
  (when (and (not cfg-themes-icons--setup-completed)
             (display-graphic-p)
             (not (find-font (font-spec :name "all-the-icons"))))
    (all-the-icons-install-fonts t)
    (setq cfg-themes-icons--setup-completed t)))

;;;###autoload
(use-package all-the-icons
  :commands all-the-icons-install-fonts
  :hook
  (after-change-major-mode . cfg-themes-icons--setup))

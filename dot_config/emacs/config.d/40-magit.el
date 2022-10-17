;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(magit magit-lfs)))

;;;###autoload
(use-package magit
  :defines magit-section-mode-map
  :commands (magit-status vc-refresh-state))

(use-package magit-lfs
  :if (executable-find "git-lfs")
  :after magit
  :commands magit-lfs)

;;;###autoload
(progn
  (dolist (hook '(magit-post-commit-hook
                  git-commit-post-finish-hook
                  magit-refresh-buffer-hook))
    (add-hook hook #'vc-refresh-state))

  (with-eval-after-load 'magit
    ;; I use this thing, don't override it
    (define-keymap :keymap magit-section-mode-map
      "C-<tab>" nil)))

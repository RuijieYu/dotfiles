;;; cfg-magit.el --- Install and configure magit

;;; Commentary:

;;; Code:
(eval-when-compile (require 'cfg-require))
(cfg-require :package magit)


;; * `setopt'
(with-eval-after-load 'magit-diff
  (setopt magit-diff-refine-hunk t
          magit-diff-paint-whitespace t
          magit-diff-refine-hunk t
          magit-diff-refine-ignore-whitespace t))


;; * `add-hook'
(with-eval-after-load 'magit
  (add-hook 'magit-post-commit-hook #'vc-refresh-state)
  (add-hook 'magit-refresh-buffer-hook #'vc-refresh-state))

(with-eval-after-load 'git-commit
  (add-hook 'git-commit-mode-hook
            (lambda () (setq-local fill-column 66)))
  (add-hook 'git-commit-post-finish-hook #'vc-refresh-state))


;; * `define-keymap'
(with-eval-after-load 'magit
  (mapc
   (lambda (cell)
     (with-eval-after-load (car cell)
       (mapc (lambda (sym-map)
               (define-keymap :keymap (symbol-value sym-map)
                 "C-<tab>" nil))
             (cdr cell))))
   '((magit-section magit-section-mode-map)
     (magit-diff magit-revision-mode-map)
     (magit-status magit-status-mode-map)
     (magit-process magit-process-mode-map))))


(provide 'cfg-magit)
;;; cfg-magit.el ends here.

;;;###autoload
(progn
  ;; change displayed warning level during initialization
  (setq warning-minimum-level :emergency)

  ;; Upon emacs startup, display init time and revert warning level
  (add-hook 'emacs-startup-hook
            (lambda () (setq warning-minimum-level :error))))

(autoload 'cfg-load (expand-file-name "utils/cfg-load" user-emacs-directory))
;;;###autoload
(progn
  ;; disable custom file
  (setq custom-file null-device)
  ;; load customizations
  (cfg-load custom-file))

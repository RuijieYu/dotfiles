;; change gc temporarily before starting
;;;###autoload
(setq gc-cons-threshold (* 4 1024 1024 1024)) ; 4 GiB

;;;###autoload
(defun cfg-set-gc (&optional sz)
  "Set GC size, and perform GC.  Default SZ is 256 MiB."
  (let ((sz (or sz (* 256 1024 1024))))
    (lambda ()
      (setq gc-cons-threshold sz)
      (garbage-collect))))

;;;###autoload
(add-hook 'emacs-startup-hook (cfg-set-gc))

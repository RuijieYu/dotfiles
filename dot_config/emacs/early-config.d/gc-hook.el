;; change gc temporarily before starting
;;;###autoload
(setq gc-cons-threshold (* 4 1024 1024 1024)) ; 4 GiB

;;;###autoload
(defun cfg-set-gc (&optional gc-sz)
  "Set GC size, and perform GC, where default GC-SZ is 256 MiB."
  (let* ((gc-sz (or gc-sz (* 256 1024 1024)))
         (proc-sz (/ gc-sz 1024)))
    (lambda ()
      (setq gc-cons-threshold gc-sz
            read-process-output-max proc-sz)
      (garbage-collect))))

;;;###autoload
(add-hook 'emacs-startup-hook (cfg-set-gc))

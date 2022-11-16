;;;###autoload
(defun cfg-show-load-time ()
  (message "** Emacs loaded in %s with %d GCs."
           (format "%.2fs"
                   (float-time
                    (time-subtract
                     after-init-time
                     before-init-time)))
           gc-elapsed))

;;;###autoload
(add-hook 'emacs-startup-hook #'cfg-show-load-time)

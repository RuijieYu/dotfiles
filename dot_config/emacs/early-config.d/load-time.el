;;;###autoload
(defun cfg-show-load-time ()
  (message "** Emacs loaded in %.2fs with %d GCs."
           (float-time
            (time-subtract
             after-init-time
             before-init-time))
           gc-elapsed))

;;;###autoload
(add-hook 'emacs-startup-hook #'cfg-show-load-time)

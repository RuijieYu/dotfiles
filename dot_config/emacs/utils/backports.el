;;;###autoload
(defun cfg-backport-path (version)
  (expand-file-name version
                    (expand-file-name "backports"
                                      user-emacs-directory)))

;;;###autoload
(defun cfg-backport-version (version &optional prepend)
  "Backport functionalities from VERSION for \"backports/VERSION\".

Each .el file should have been introduced at VERSION.  When
PREPEND is non-nil, the backport is preferred over other load
paths."
  (when (let ((backport-p (version< emacs-version version)))
          (message "Current: %s; Future: %s" emacs-version version)
          (message "Do backport? %s" backport-p)
          backport-p)
    (add-to-list 'load-path (let ((bpp (cfg-backport-path version)))
                              (message "Backport path: %s" bpp)
                              bpp)
                 (not prepend))))

(provide 'cfg-util-backports)

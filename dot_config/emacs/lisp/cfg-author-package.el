;;; cfg-author-package.el --- Commands for authoring a package

;;; Commentary:

;;; Code:

;;;###autoload
(defun cfg-author-package-create (new-fname &optional desc)
  "Create a new package called NEW-FNAME.
Note that NEW-FNAME must not already exist.  DESC is the
description for the package."
  (interactive "FCreate file: \nMDescription: ")
  (if (and (file-exists-p new-fname)
           (not (and (file-regular-p new-fname)
                     (yes-or-no-p "Overwrite existing file?"))))
      (user-error
       "Trying to \"create\" an existing package: `%s'"
       new-fname)
    (with-current-buffer (find-file-noselect new-fname)
      (erase-buffer)
      (let* ((base (file-name-nondirectory new-fname))
             (pkg (file-name-sans-extension base))
             (desc (or desc "")))
        (insert (format ";;; %s --- %s\n\n" base desc))
        (insert (format ";;; Commentary:\n\n"))
        (insert (format ";;; Code:\n\n"))
        (insert (format "(provide '%s)\n" pkg))
        (insert (format ";;; %s ends here.\n" base)))
      (switch-to-buffer (current-buffer)))))

(provide 'cfg-author-package)
;;; cfg-author-package.el ends here.

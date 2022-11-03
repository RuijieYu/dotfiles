;;;###autoload
(defun add-to-path (&rest paths)
  "Add each element in PATHS to the path environment variable, as
 well as the `exec-path' list.  The last element of PATHS will
 have the highest priority in path searching."
  (dolist (path paths)
    (let ((path (expand-file-name path)))
      (when (and (stringp path)
                 (file-accessible-directory-p path))
        (setenv "PATH" (concat path ":" (getenv "PATH")))
        (add-to-list 'exec-path path)))))

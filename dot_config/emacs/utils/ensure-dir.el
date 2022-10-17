;;;###autoload
(defun cfg-ensure-dir (path &optional is-dir)
  "When IS-DIR is non-nil, ensure the directory PATH exists.
Otherwise, assuming PATH is a file name, ensure its parent
exists."
  (make-directory (if is-dir path (file-name-directory path))
                  'parents))

;;;###autoload
(define-obsolete-function-alias 'cfg--ensure-dir
  #'cfg-ensure-dir "0.0")

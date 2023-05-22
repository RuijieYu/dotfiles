;;;###autoload
(require 'cl-macs)

;;;###autoload
(cl-defmacro cfg-with-message ((format-string &rest args)
                               (&key (begin-prepend "")
                                     (begin-append "")
                                     (end-prepend "")
                                     (end-append "done"))
                               &rest body)
  "Execute BODY wrapped around two `message' calls.

For FORMAT-STRING and ARGS, see `message' and `format'.  All ARGS
are evaluated exactly once.

BEGIN-PREPEND, BEGIN-APPEND, END-PREPEND, and END-APPEND are the
extra string prepended or appended to the first or second
`message' call.

\(fn FORMAT-ARGS KEYWORDS &rest BODY)"
  (declare (indent 2))
  (let ((fmt (gensym)))
    `(let ((,fmt (apply #'format ,format-string (list . ,args))))
       (prog2 (message "%s%s%s" ,begin-prepend ,fmt ,begin-append)
           (progn . ,body)
         (message "%s%s%s" ,end-prepend ,fmt ,end-append)))))

;;;###autoload
(defmacro cfg-control-dir (dir autoload)
  "DIR is a directory, and AUTOLOAD is a potentially-absent file
name, both of which are relative to `user-emacs-directory' if not
absolute.

Indicate that the contained el file \"controls\" DIR.  The
generated autoloads file is at AUTOLOAD (relative to
`user-emacs-directory').  During compile time, all files
recursively under DIR are compiled with
`byte-recompile-directory', and all files (except in nested
directories) under DIR are parsed for autoloads."
  (let ((dir (expand-file-name (eval dir) user-emacs-directory))
        (autoload (expand-file-name (eval autoload)
                                    user-emacs-directory)))
    ;; compile-time execution
    (when (file-exists-p dir)
      (cfg-with-message ("Compiling: \"%s\"..." dir) nil
        (byte-recompile-directory dir 0))
      (cfg-with-message
          ("Generating autoloads: \"%s\" → \"%s\"..."
           dir autoload)
          nil
        (let ((autoload-dir (file-name-directory autoload)))
          (make-directory autoload-dir 'parents))
        (make-directory-autoloads dir autoload))
      `(load ,(file-name-sans-extension autoload)))))

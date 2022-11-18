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
      (message "Compiling: \"%s\"..." dir)
      (byte-recompile-directory dir 0)
      (message "Compiling: \"%s\"...done" dir)
      (require 'autoload)
      (message "Generating autoloads: \"%s\" → \"%s\"..."
               dir autoload)
      (let ((autoload-dir (file-name-directory autoload)))
        (make-directory autoload-dir 'parents))
      (make-directory-autoloads dir autoload)
      (message "Generating autoloads: \"%s\" → \"%s\"...done"
               dir autoload)
      `(progn
         (load ,(file-name-sans-extension autoload)
               nil 'nomessage)))))

;;;###autoload
(defun cfg-file (el-file &optional relative)
  "Locate a config file.  That is, assuming that the named file is
relative under RELATIVE (default `user-emacs-directory'), return
its expanded file name.

See also `expand-file-name' and `locate-user-emacs-file'."
  (expand-file-name
   el-file (expand-file-name (or relative ".")
                             user-emacs-directory)))

;;;###autoload
(defun cfg--maybe-byte-compile (el-file)
  "Optionally byte-compile the EL-FILE if necessary.  Assume
EL-FILE is a file ending with .el, which does not have to exist.
Return nil if no compilation occurs, otherwise return the result
of `byte-compile-file'."
  (let ((\.elc (concat el-file "c")))
    ;; only compile when .el is newer, edge cases already
    ;; correctly handled by `file-newer-than-file-p'.
    (when (file-newer-than-file-p el-file \.elc)
      (byte-compile-file el-file))))

;;;###autoload
(defun cfg-compile (el-file &optional relative no-compile)
  "Compile a file EL-FILE from RELATIVE or `user-emacs-directory'
if it exists.  See also `cfg-load' When NO-COMPILE is non-nil, do
not perform the actual compilation steps.

It seems that when `no-byte-compile' is set to non-nil for the
source file, `native-compile' returns nil -- to remedy this, the
function `native-compile' is not run when `byte-compile-file'
returns the symbol `no-byte-compile'.

Return the file name sans extension, if compilations succeed.
Otherwise return nil."
  (let* ((file (cfg-file el-file relative))
         (bare-file (file-name-sans-extension file))
         (el-file (concat bare-file ".el")))
    (and (file-exists-p el-file)
         (require 'cl-lib)
         (or no-compile
             (cl-case (cfg--maybe-byte-compile el-file)
               ((no-byte-compile) t)
               (t (native-compile el-file))))
         bare-file)))

;;;###autoload
(defun cfg-load (el-file &optional relative no-compile)
  "Compile and load a file EL-FILE from RELATIVE or
`user-emacs-directory' if it exists.  The filename EL-FILE can be
a bare name \"BASENAME\", or a file name with \"BASENAME.el\"
pattern (implementation detail: or any other extension, just make
sure \"BASENAME.el\" exists).  When NO-COMPILE is non-nil,
disable compilation.

Return the file name sans extension, if everything succeeds.
Otherwise return nil."
  (unless (string= el-file null-device)
    (let ((bare-file (cfg-compile
                      el-file relative no-compile)))
      (when bare-file
        (load bare-file :noerror :nomessage)))))

;;;###autoload
(defun cfg-load-recurse (dir &optional no-compile)
  "Compile and load all *.el files under DIR recursively.  Order
should be alphanumeric.  When NO-COMPILE is non-nil, disable
compilation."
  (let ((el-files
         (directory-files-recursively
          (cfg-file dir)
          ;; for easy regex'ing, just match word[-word].el
          (rx-let ((fchar (any alphanumeric ?-)))
            (rx string-start (+ fchar) ".el" string-end)))))
    (dolist (el-file el-files)
      (cfg-load el-file nil no-compile))))

;;;###autoload
(defun preload (pkgs)
  "Useful in `eval-when-compile' contexts."
  (dolist (pkg pkgs)
    (straight-use-package pkg)))

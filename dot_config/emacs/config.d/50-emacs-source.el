;; -*- no-byte-compile: nil; -*-
(let* ((src-prefix "/opt/src")
       (emacs-src (expand-file-name (concat src-prefix "/emacs")))
       (emacs-git "https://git.savannah.gnu.org/git/emacs.git")
       (failed nil))
  (and
   nil                                  ; disable for now
   (cond
    ((file-exists-p (concat emacs-src "/.git"))
     ;; when path exists and is git, restore it to clean slate
     (and (= 0 (call-process
                "git" nil nil nil
                "-C" emacs-src "clean" "-xdf"))
          (= 0 (call-process
                "git" nil nil nil
                "-C" emacs-src "fetch"))
          (= 0 (call-process
                "git" nil nil nil
                "-C" emacs-src "remote" "set-url"))
          (message "TODO - git exists: %s"
                   `((emacs-git ,emacs-git)
                     (failed ,failed)))))
    ;; when path does not exist, clone it from git
    'todo)))

;;;###autoload
(defcustom cfg--source-dir "/opt/src/emacs"
  "The source directory to feed into `source-directory` after emacs
initialization.  Useful when one needs to look into C source.
Note that the user needs to make sure the source exists,
otherwise it has no effect."
  :type 'directory
  :set (lambda (symbol val)
         (eval `(setq source-directory ,val
                      ,symbol ,val)))
  :group 'custom
  :link '(variable-link source-directory))

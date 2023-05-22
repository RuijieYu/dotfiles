;;;###autoload
(defun eshell/rmdir-deep (&rest args)
  "Remove all empty directories in ARGS.

For example, if empty directories path/to/{a,b} exist, then
`rmdir-deep path' will delete path because all its descendents
are empty.

This function requires that the local `rmdir' command supports
the \"--ignore-fail-on-non-empty\" flag."
  (eshell-eval-using-options
   "rmdir-deep" args
   '((?P nil nil -P "Never follow symbolic links")
     (?L nil nil -L "Follow symbolic links")
     (?H nil nil -H
         "Do not follow symbolic links except while processing command line
arguments")
     (?n "dry-run" nil dry-run
         "Do not actually remove anything")
     (?h "help" nil nil "Show this help text")
     ;; :preserve-args
     )
   (if args
       (apply #'eshell/find
              (append
               (and -P '("-P"))
               (and -L '("-L"))
               (and -H '("-H"))
               args
               '("-type" "d" "-empty")
               (and (not dry-run)
                    '("-exec" "rmdir" "--ignore-fail-on-non-empty"
                      "-p" "{}" "+"))))
     "No bases supplied.")))

;;;###autoload
(defun eshell/find (&rest args)
  (require 'cl-lib)
  (cl-flet ((option-p (arg)
              (and (stringp arg)
                   (length> arg 0)
                   (eql (aref arg 0) ?-))))
    (eshell-eval-using-options
     "find" args
     '((?H)
       (?L)
       (?P)
       (?h "help" nil nil "...")
       :external "find"
       :parse-leading-options-only)
     (let (paths)))
    'todo))

;;;###autoload
(defun eshell/find (&rest args)
  ;; (message "(find . %S)" args)
  (with-temp-buffer
    (let ((proc
           (apply #'start-file-process
                  "find" (current-buffer)
                  "find" args)))
      (set-process-sentinel proc #'ignore)
      (while (process-live-p proc)
        (sit-for eshell-process-wait-seconds
                 eshell-process-wait-milliseconds)))
    (buffer-string)))

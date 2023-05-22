;;; cfg-dired.el --- Configure dired

;;; Commentary:

;;; Code:
(with-eval-after-load 'dired (require 'dired-x))


(with-eval-after-load 'dired
  (setopt dired-listing-switches
          (string-join '("--all" "--human-readable" "-o" "-g"
                         "--group-directories-first")
                       " ")
          delete-by-moving-to-trash t
          dired-ls-F-marks-symlinks t))

(with-eval-after-load 'dired-x
  (setopt
   dired-guess-shell-alist-user
   `((,(rx ".pdf" string-end) "zathura --fork")
     (,(rx ?. (or "png" "jpg" "jpeg" "gif") string-end) "imv")
     (,(rx ?. (or "ppt" "pptx" "doc" "docx") string-end)))
   dired-omit-files
   (rx (or (seq string-start ".." string-end)
           (seq string-start ".#")))
   dired-omit-verbose nil))

(provide 'cfg-dired)
;;; cfg-dired.el ends here.

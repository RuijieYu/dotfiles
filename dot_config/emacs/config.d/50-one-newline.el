;; -*- no-byte-compile: nil; -*-
(defun cfg-one-newline ()
  "Reduce multiple consequtive newlines into a single empty
newline.  See URL`https://stackoverflow.com/a/4420067'."
  (interactive)
  (goto-char (point-min))
  (while (re-search-forward "\\(^\\s-*$\\)\n" nil t)
    (replace-match "\n")
    (forward-line 1)))

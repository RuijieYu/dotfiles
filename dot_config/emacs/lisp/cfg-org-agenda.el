;;; cfg-org-agenda.el --- Configure org agenda

;;; Commentary:

;;; Code:
(require 'cfg-org)


;;;###autoload
(defun cfg-org-agenda-setup ()
  "Setup a `org-agenda-mode' buffer."
  (interactive)
  (with-eval-after-load 'display-fill-column-indicator
    (display-fill-column-indicator-mode -1)))

(defun cfg-org-agenda-collect ()
  "Collect all org agenda files."
  (append (cfg-org-agenda-find 3 "~/academia")
          (cfg-org-agenda-find 0 "~/org/agenda")))

(defun cfg-org-agenda-find (level dir)
  "Look for orgmode files under directory DIR recursively.
This is done for LEVEL levels.  When LEVEL is 0, simply look
under the directory DIR for the set of orgmode files.  See also
the variable `org-agenda-files' and `org-agenda-file-regexp'.
Return a deduplicated list of orgmode file paths."
  (delete-dups
   (flatten-tree
    (cfg-org-agenda-find--internal
     level (expand-file-name dir)))))

(defun cfg-org-agenda-find--internal (level dir)
  "Internal function for `cfg-org-agenda-find'.
Return a tree of orgmode file paths.  See `cfg-org-agenda-find'
for specifications of LEVEL and DIR."
  (let ((files
         ;; remove . and ..
         (cddr (and (file-directory-p dir)
                    (directory-files dir)))))
    (mapcar
     (lambda (file)
       (let ((full (file-truename (concat dir "/" file))))
         (cond
           ((string-match-p org-agenda-file-regexp file) full)
           ((and (> level 0) (file-directory-p full))
            (cfg-org-agenda-find--internal (1- level) full)))))
     files)))


;; * `setopt'
(with-eval-after-load 'org-agenda
  (setopt
   org-agenda-breadcrumbs-separator "→"
   org-agenda-span 'fortnight
   org-agenda-skip-deadline-prewarning-if-scheduled t
   org-agenda-files
   (cl-remove-if-not
    #'file-exists-p
    (mapcar #'expand-file-name
            (cfg-org-agenda-collect)))))


;; * `add-hook'
(add-hook 'org-agenda-finalize-hook #'cfg-org-agenda-setup)


(provide 'cfg-org-agenda)
;;; cfg-org-agenda.el ends here.

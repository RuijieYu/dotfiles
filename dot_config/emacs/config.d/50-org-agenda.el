;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(org)))

(defun cfg-org-agenda-find--internal (level dir)
  "Internal function for `cfg-find-org-file'.  Return a tree of
orgmode file paths."
  (require 'org)
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

;;;###autoload
(defun cfg-org-agenda-find (level dir)
  "Look for orgmode files under directory DIR recursively, for
LEVEL levels.  When LEVEL is 0, simply look under the directory
DIR for the set of orgmode files.  See also `org-agenda-files'
and `org-agenda-file-regexp'.  Return a deduplicated list of
orgmode file paths."
  (delete-dups
   (flatten-tree
    (cfg-org-agenda-find--internal
     level (expand-file-name dir)))))

;;;###autoload
(defun cfg-org-agenda-collect ()
  "Collect all org agenda files."
  (append (cfg-org-agenda-find 3 "~/academia")
          (cfg-org-agenda-find 0 "~/org/agenda")))

;; This way I can add all my course-specific org-agenda files as
;; ~/academia/SCHOOL/TERM/COURSE/*.org, while still having orgmode
;; files (like notes) elsewehere further inside COURSE
;; directories.
;;;###autoload
(use-package org-agenda
  :no-require t
  :straight org
  :after org
  :custom
  (org-agenda-breadcrumbs-separator "→")
  (org-agenda-span 'day)
  (org-agenda-skip-deadline-prewarning-if-scheduled t)
  (org-agenda-files
   (cl-remove-if-not
    #'file-exists-p
    (mapcar #'expand-file-name
            (cfg-org-agenda-collect)))))

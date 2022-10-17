;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;;;###autoload
(use-package files
  :straight nil
  :custom
  ;; backup behavior
  (backup-by-copying t)
  ;; backup versions
  (kept-new-versions 6)
  (delete-old-versions t)
  (version-control t)
  ;; TEMPORARY SOLUTION, look into no-littering
  (backup-directory-alist '(("." . "~/.local/state/backup"))))

;; local backup
(let ((backup-dir (expand-file-name "~/.local/state/backup")))
  (make-directory backup-dir :parents)
  (customize-set-variable
   'backup-directory-alist `(("." . ,backup-dir))))

;; auto save file names
(let ((auto-save-dir
       (expand-file-name "~/.local/state/autosave"))
      (auto-save-list-dir
       (expand-file-name "~/.local/state/autosave-list")))
  (make-directory auto-save-dir :parents)
  (make-directory auto-save-list-dir :parents)
  (customize-set-variable
   'auto-save-list-file-prefix auto-save-list-dir)
  (customize-set-variable
   'auto-save-file-name-transforms
   `((".*" ,auto-save-dir :uniquify))))

;; remote backup
(customize-set-variable
 'tramp-backup-directory-alist backup-directory-alist)

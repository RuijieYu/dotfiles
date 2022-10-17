;; -*- no-byte-compile: nil; -*-
;;;###autoload
(defun kill-all--get-buffer-file-name (&optional buffer)
  "Get the path for a buffer.  See also
`Buffer-menu--pretty-file-name'."
  (let ((buffer (or buffer (current-buffer))))
    (with-current-buffer buffer
      (let* ((name (buffer-file-name))
             (full-name (Buffer-menu--pretty-file-name name)))
        (expand-file-name full-name)))))

;;;###autoload
(defun kill-all--get-dired-directory (&optional buffer)
  "Get the expanded dired directory path of the buffer BUFFER.  If
BUFFER is nil, use the current buffer.  Return nil if any error.
See `dired-directory', `expand-file-name', and `current-buffer'."
  (let ((buffer (or buffer (current-buffer))))
    (when (bufferp buffer)
      (with-current-buffer buffer
        (when (eq major-mode 'dired-mode)
          ;; `dired-directory' is absolute but may not be fully
          ;; expanded
          (expand-file-name
           (cond
            ;; could be a list, where car is directory path
            ((listp dired-directory) (car dired-directory))
            ;; otherwise just variable
            (t dired-directory))))))))

;;;###autoload
(defun kill-all--get-eshell-directory (&optional buffer)
  "Get the expanded eshell directory path of the buffer BUFFER.  If
BUFFER is nil, use the current buffer.  Return nil if any error.
See `default-directory'."
  (when (bufferp buffer)
    (with-current-buffer buffer
      (when (eq major-mode 'eshell-mode)
        default-directory))))

;;;###autoload
(defun kill-all--do-kill-buffer (buffer)
  "Kill BUFFER.  If a `dired' or a `eshell' buffer, just
kill. Otherwise kill using `kill-buffer-if-not-modified'."
  (when (bufferp buffer)
    (with-current-buffer buffer
      (require 'cl-lib)
      (princ `(do-kill ,buffer))
      (cond
       ((derived-mode-p 'special-mode 'dired-mode 'eshell-mode)
        (kill-buffer buffer))
       (t (kill-buffer-if-not-modified buffer))))))

;;;###autoload
(defun kill-all--first-path (list-functions &optional buffer)
  "LIST-FUNCTIONS is a list of functions taking a buffer as the
argument.  By applying LIST-FUNCTIONS sequentially, the first
non-nil result is returned."
  (when list-functions
    (or (funcall (car list-functions) buffer)
        (kill-all--first-path (cdr list-functions) buffer))))

;;;###autoload
(defun kill-all--is-buffer-below
    (buffer-or-name dir &optional exclude)
  "Check whether the buffer BUFFER-OR-NAME is below DIR.  Return a
pair whose `car' is BUFFER-OR-NAME when it is a buffer, nil
otherwise; and whose `cdr' is the underlying file name.  Return
nil otherwise.  Note that it is always case sensitive.  Currently
`tramp' file names are not supported."
  (let ((dir (expand-file-name dir)))
    (cond
     ((stringp buffer-or-name)                  ; string
      (and (string-prefix-p dir buffer-or-name) ; is prefix
           ;; if both exclude and =, then no
           (not (and exclude (string= dir buffer-or-name)))
           ;; if yes, return
           `(nil . ,buffer-or-name)))
     ((bufferp buffer-or-name)          ; buffer
      (let* ((name
              (kill-all--get-buffer-file-name buffer-or-name)))
        ;; only when we can get the buffer name
        (when name
          (let ((res (kill-all--is-buffer-below
                      name dir exclude)))
            (when res `(,buffer-or-name . ,(cdr res))))))))))

;;;###autoload
(defun kill-all--list-buffers-below (dir &optional exclude)
  "List all buffers below DIR.  Note that current buffer is always
omitted."
  (require 'cl-lib)
  (cl-remove-if
   (lambda (pair)
     (or (not pair)
         (eq (current-buffer) (car pair))))
   (mapcar (lambda (buffer)
             (kill-all--is-buffer-below buffer dir exclude))
           (buffer-list))))

;;;###autoload
(defun kill-all--buffer-list-refresh ()
  "Refresh the buffer list buffer if available."
  (let ((buffer (get-buffer "*Buffer List*")))
    (when buffer (with-current-buffer buffer
                   (call-interactively #'revert-buffer)))))

;;;###autoload
(defun kill-all-buffers-below (dir &optional exclude)
  "Kill all modified buffers below DIR.  If interactive, prompt for
this directory in minibuffer.  Exclude buffers at DIR if EXCLUDE
is non-nil."
  (interactive "D\nP")
  (dolist (pair (kill-all--list-buffers-below dir exclude))
    (let ((buffer (car pair))
          (file-name (cdr pair)))
      (message "Killing buffer %s @ %s" buffer file-name)
      (kill-all--do-kill-buffer buffer))
    (kill-all--buffer-list-refresh)))

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-<tab> k" #'kill-all-buffers-below)

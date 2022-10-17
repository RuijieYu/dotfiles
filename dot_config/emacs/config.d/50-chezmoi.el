;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(chezmoi)))

;;;###autoload
(use-package chezmoi
  :after magit dired
  :commands chezmoi-diff)

;;;###autoload
(defcustom cfg-chezmoi-dest (expand-file-name "~")
  "If non-nil, specify the absolute path to the destination
directory."
  :group 'custom
  :type 'directory)

;;;###autoload
(defun cfg-chezmoi--dest-root ()
  "Get the destination root for chezmoi.  Should generally be
$HOME.  See also `cfg-chezmoi-dest'."
  (file-name-as-directory
   (if cfg-chezmoi-dest (expand-file-name cfg-chezmoi-dest "/")
     (expand-file-name "~"))))

;;;###autoload
(defun cfg-chezmoi-diff-single-file (path &optional arg)
  "View output of =chezmoi diff= in a diff-buffer.  If ARG is
non-nil, switch to the diff-buffer.  The customizable
variable `cfg-chezmoi-dest' specifies the destination directory
for chezmoi."
  (interactive "f\nP")
  (let* ((path (expand-file-name path))
         (b (get-buffer-create
             (format "*chezmoi-diff <%s>*"
                     (string-remove-prefix
                      (cfg-chezmoi--dest-root) path))))
         (chezmoi-command
          (format "chezmoi -D '%s' diff '%s'"
                  (cfg-chezmoi--dest-root) path)))
    (with-current-buffer b
      (erase-buffer)
      (shell-command chezmoi-command b)
      (read-only-mode)
      (diff-mode)
      (whitespace-mode 0))
    (when arg (switch-to-buffer b))
    b))

;;;###autoload
(defun cfg-chezmoi-dired-diff-single-file ()
  "Call `cfg-chezmoi-diff-single-file' on the current file at dired
point, and always open the diff buffer."
  (interactive nil)
  (with-eval-after-load 'dired-x
    (let ((filename (thing-at-point 'filename)))
      (and filename (cfg-chezmoi-diff-single-file filename t)))))

;;;###autoload
(with-eval-after-load 'dired
  (define-keymap :keymap dired-mode-map
    "\\ d" #'cfg-chezmoi-dired-diff-single-file))

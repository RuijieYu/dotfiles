;;; cfg-frame.el --- Frame management configuration

;;; Commentary:

;;; Code:
(defvar server-buffer-clients)
(autoload 'server-edit "server")

;;;###autoload
(defun cfg-frame-exit (kill-last)
  "Consistenly exit the current Emacs frame.
If this is the last frame of a non-client Emacs, refuse to kill
current frame unless the prefix argument KILL-LAST is non-nil."
  (interactive "P")
  ;; ref:
  ;; https://github.com/weirdNox/org-noter/commit/e1273c8ecb172012caaf14f50b41305e16e893e3
  ;; https://gnu.org/software/emacs/manual/html_node/elisp/Finding-All-Frames.html
  (cond
   (server-buffer-clients (server-edit))
   ;; When have more than one frames (anywhere), this should be
   ;; able to just kill the current frame.
   ((cdr (visible-frame-list)) (delete-frame))
   ;; when forced and this is the only GUI frame, offer to save
   ;; and exit emacs
   (kill-last (save-buffers-kill-emacs))
   ;; otherwise, tell user to prefix C-u.
   (t (user-error
       "About to exit Emacs, prefix %s to force"
       (substitute-command-keys "`\\[universal-argument]'")))))

;;;###autoload
(define-keymap :keymap global-map
  "C-<tab> C-q" #'cfg-frame-exit)

(provide 'cfg-frame)
;;; cfg-frame.el ends here.

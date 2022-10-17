;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (load (expand-file-name "utils/cfg-load" user-emacs-directory))
  (cfg-load "pkg" "utils"))

;; when server is loaded, then do the following
;;;###autoload
(use-package server
  :straight nil
  :commands server-edit
  :defines server-buffer-clients)

;;;###autoload
(defun cfg-exit (kill-last)
  "Consistently exit Emacs.  If not in Emacs client, only exit Emacs
with a non-nil prefix argument KILL-LAST using
`\\[cfg-exit-kill-frame]'.  Otherwise when in server mode,
perform `\\[server-edit]'."
  (interactive "P")
  (require 'server)
  (if server-buffer-clients (server-edit)
    (cfg-exit-kill-frame kill-last)))

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-<tab> C-q" #'cfg-exit
  "C-c C-q" #'cfg-exit)

(defun cfg-exit-kill-frame (kill-last)
  "Kill the current frame.  When KILL-LAST is non-nil, run
`save-buffers-kill-emacs'.  Otherwise run `\\[delete-frame]',
which only succeeds when the current frame is not the only
remaining frame.

See also `cfg-exit'."
  (interactive "P")
  ;; ref:
  ;; https://github.com/weirdNox/org-noter/commit/e1273c8ecb172012caaf14f50b41305e16e893e3
  ;; https://gnu.org/software/emacs/manual/html_node/elisp/Finding-All-Frames.html
  (cond
   ;; when have more than one frames (anywhere), this should be
   ;; able to just kill the current frame.
   ((cdr (visible-frame-list)) (delete-frame))
   ;; otherwise (when this is the only (GUI?? TODO) frame), offer
   ;; to save and exit emacs
   (kill-last (save-buffers-kill-emacs))
   (t (message
       "About to exit emacs, prefix %s to force."
       (substitute-command-keys "`\\[universal-argument]'")))))

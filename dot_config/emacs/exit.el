;;; -*- fill-column: 66; no-byte-compile: t; -*-

(defun ~exit-emacs-client/basic (kill-last)
  "Dummy exit command when no server is present.  When KILL-LAST
is non-nil, then force-close to the underlying `delete-frame'
function call."
  (interactive "P")
  ;; ref:
  ;; https://github.com/weirdNox/org-noter/commit/e1273c8ecb172012caaf14f50b41305e16e893e3
  ;; ref:
  ;; https://gnu.org/software/emacs/manual/html_node/elisp/Finding-All-Frames.html
  (cond
   ;; when have more than one frames (anywhere), this should be
   ;; able to just kill the current frame.
   ((cdr (visible-frame-list)) (delete-frame))
   ;; otherwise (when this is the only (GUI?? TODO) frame), offer
   ;; to save and exit emacs
   (kill-last (save-buffers-kill-emacs))
   (t (message
       ;; found it from `server.el'
       (substitute-command-keys
        (concat "About to exit emacs, prefix "
                "`\\[universal-argument]' to force."
                ))))
   ))
(defalias #'~exit-emacs-client #'~exit-emacs-client/basic)

;; when server is loaded, then do the following

;; ref:
;; https://github.com/ymherklotz/dotfiles/blob/master/emacs/loader.org
(with-eval-after-load 'server
  (defun ~exit-emacs-client/dispatch (kill-last)
    "Consistent exit emacsclient.  If not in emacs client, echo a
message in minibuffer, don't exit emacs.  If in server mode and
editing file, do [C-x #] `server-edit' else do [C-x 5 0]
`delete-frame'."
    (interactive "P")
    (if server-buffer-clients (server-edit)
      (~exit-emacs-client/basic kill-last)
      ))

  (defalias '~exit-emacs-client #'~exit-emacs-client/dispatch
    "Dispatch exit command.")
  )

(global-set-key [C-tab ?\C-q] #'~exit-emacs-client)
(global-set-key [?\C-c ?\C-q] #'~exit-emacs-client)

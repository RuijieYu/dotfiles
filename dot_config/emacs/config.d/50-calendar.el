;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(calfw calfw-org)))

;;;###autoload
(defun cfg-calendar-open-buffer (&optional view)
  "Open calendar buffer using data from `org-mode' agenda.
Optionally specify VIEW from [day week two-weeks month] for the
scope of the calendar -- with default VIEW being week."
  (interactive)
  (require 'calfw)
  (let ((view (seq-find (lambda (e) (eq e view))
                        [day week two-weeks month] 'week)))
    ;; define additional keymaps -- it seems that
    ;; `cfw:org-overwrite-default-keybinding' might have no
    ;; effects in emacs >= 29
    ;; go to this buffer
    (cfw:open-calendar-buffer
     :view view
     :custom-map (define-keymap
                   "g" #'cfw:refresh-calendar-buffer
                   "s" #'org-save-all-org-buffers)
     :contents-sources `(,(cfw:org-create-source)))))

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-<tab> c" #'cfg-calendar-open-buffer)

;;;###autoload
(use-package calfw
  :commands (cfw:open-calendar-buffer
             cfw:refresh-calendar-buffer)
  :after calfw-org
  :custom
  (cfw:display-calendar-holidays nil))

;;;###autoload
(use-package calfw-org
  :commands cfw:org-create-source
  :custom
  (cfw:org-overwrite-default-keybinding t))

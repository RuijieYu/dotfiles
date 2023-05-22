;;; cfg-org.el --- Configure org

;;; Commentary:

;;; Code:
(eval-when-compile (require 'rx))
(require 'cfg-package)
(require 'cfg-diminish)
(cfg-package-install '(org))

(require 'org)
(require 'org-indent)
(require 'org-num)


;; * `defun'
;;;###autoload
(defun cfg-org-setup ()
  "Setup `org-mode' buffers."
  (interactive)
  (require 'org)
  (visual-line-mode)
  (setq-local fill-column 100)
  (when (fboundp 'display-fill-column-indicator-mode)
    (display-fill-column-indicator-mode -1))
  (when (fboundp 'flyspell-mode)
    (flyspell-mode -1))
  (when (and (boundp 'olivetti-mode) olivetti-mode)
    (setq-local olivetti-body-width fill-column))
  (org-indent-mode)
  (org-num-mode))


;; other funcalls
(with-eval-after-load 'org
  (cfg-diminish '((org-indent-mode . "Oi")
                  (org-num-mode . "O#")))

  (font-lock-add-keywords
   'org-mode
   `((,(rx line-start
           (or (group (or ?+ ?-))
               (seq (+ blank) (group (or ?+ ?- ?*))))
           blank)
      (0 (compose-region (match-beginning 1)
                         (match-end 1) "•"))))))


;; * `define-keymap'
(with-eval-after-load 'org
  (define-keymap :keymap org-mode-map
    "C-<tab> l" #'org-agenda-list))


;; * `setopt'
(with-eval-after-load 'org
  (setopt
   ;; tasks and agenda
   org-enforce-todo-dependencies t
   org-enforce-todo-checkbox-dependencies t
   org-log-into-drawer t
   ;; ( org-tags-column -63) ; for 66-width orgmode buffers
   org-todo-keywords
   '((sequence "AVAILABLE(a)"
      "IN-PROGRESS(i!)"
      "POSTPONED(p@/!)"
      "|"
      "SUBMITTED(s!)"
      "GRADED(g@)"))
   org-hide-block-startup nil
   org-confirm-babel-evaluate nil
   ;; startup
   org-startup-indented t               ; org-indent-mode
   org-startup-numerated t              ; org-num-mode
   org-startup-folded t ; there are more options, I just want to fold everything

   ;; visuals
   org-ellipsis " ▾"
   org-hide-leading-stars t
   org-hide-emphasis-markers t
   org-hide-macro-markers t
   org-fontify-quote-and-verse-blocks t
   org-pretty-entities t

   ;; inline images
   org-image-actual-width 500

   ;; structured template definition
   org-structure-template-alist
   (let ((pairs '(("sh" . "sh")
                  ("el" . "emacs-lisp")
                  ("py" . "python")
                  ("md" . "markdown")))
         (alist (append org-structure-template-alist nil)))
     (mapc (lambda (c)
             (setf (alist-get (car c) alist)
                   (concat "src " (cdr c))))
           pairs)
     alist)

   ;; miscellaneous configurations
   org-cycle-separator-lines 2
   ;; org-bullets-bullet-list '("•")

   ;; do not add weird indentations to org source
   org-edit-src-content-indentation 0
   org-src-preserve-indentation t))

(with-eval-after-load 'ol
  (setopt org-link-file-path-type 'relative))


;; * `add-hook'
;;;###autoload
(add-hook 'org-mode-hook #'cfg-org-setup)


(provide 'cfg-org)
;;; cfg-org.el ends here.

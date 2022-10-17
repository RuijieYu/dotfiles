;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

(defun cfg-org--unwrap-lang (lang)
  "Unwrap LANG in case of variable-references.  Output a string
from the resultant symbol using `symbol-name'.  When LANG is a
symbol and SYMBOL-DEREF is non-nil, dereference LANG for its
symbol value."
  (cond
   ((symbolp lang) lang)
   ((and (listp lang) (eq (car lang) '\,))
    (symbol-value (cfg-org--unwrap-lang (cadr lang))))
   (t (error "Bad LANG, requires either symbol or unquoted variable reference."))))

(defun cfg--org-babel-lang-var-name (lang)
  "Get the org-babel variable name for default header arguments.
Allow variable dereference using `\,' recursively."
  (let ((lang (cfg-org--unwrap-lang lang))
        (prefix "org-babel-default-header-args"))
    (if lang (concat prefix ":" (symbol-name lang))
      prefix)))

(defmacro cfg--org-babel-set-default-args (lang alist)
  "Set org-babel default header arguments for a specific langauge
LANG.  Arguments are specified in ALIST.  If LANG is of the form
`,SYMBOL', then use this SYMBOL as the argument for LANG.  If
LANG is `nil', then set language-agonistic default header
arguments.  See also `org-babel-default-header-args'."
  `(setq ,(cfg--org-babel-lang-var-name lang) ,alist))

(defmacro cfg--org-babel-get-default-args (lang)
  "Get org-babel default header arguments for a specific langauge
LANG.  If LANG is of the form `,SYMBOL', then use this SYMBOL as
the argument for LANG.  If LANG is `nil', then set
language-agonistic default header arguments.  If the variable
currenlty See also `org-babel-default-header-args'."
  (let ((lang (intern (cfg--org-babel-lang-var-name lang))))
    (if (symbol-plist lang) lang nil)))

;; hide metadata
(define-minor-mode org-hide-meta-mode
  "Hide meta lines within an `org-mode' buffer, helpful for
presentations."
  :init-value nil
  :global nil
  :lighter " O[meta]"
  (unless :disabled
    (let ((frame (selected-frame))
          (color (and org-hide-meta-mode
                      (face-attribute 'default :background))))
      (dolist (face '(org-meta-line org-drawer
                                    org-tag org-ellipsis))
        (set-face-attribute
         face frame
         :foreground color
         :background color)))))

(defsubst org-hide-meta-mode--reload ()
  (interactive)
  (org-hide-meta-mode org-hide-meta-mode))

;; bold header mode
(define-minor-mode org-bold-header-mode
  "Bold-face all headers within an `org-mode' buffer, helpful for
presentations."
  :init-value nil
  :global nil
  :lighter " O[bold]"
  (unless nil                           ; :disabled
    (let ((frame (selected-frame))
          (get-face (lambda (n) (intern (format "org-level-%s" n))))
          (n 0)
          face)
      (while (facep (setq face (funcall get-face (setq n (1+ n)))))
        (set-face-attribute
         face frame :bold org-bold-header-mode)))))

;; hide comments mode
(defvar hide-comments-mode--saved nil
  "Saved comment face value.  Its value stores the original face
value, failing if not found.")

(define-minor-mode hide-comments-mode
  "Hide comments."
  :init-value nil
  :global nil
  :lighter " HC"
  (unless :disabled
    (let ((frame (selected-frame)))
      (cond
       (hide-comments-mode
        (setq hide-comments-mode--saved
              (face-attribute
               'font-lock-comment-face :foreground frame t))
        (set-face-attribute
         'font-lock-comment-face frame :foreground
         (face-attribute 'default :background frame t)))
       (t
        (set-face-attribute 'font-lock-comment-face frame
                            :foreground hide-comments-mode--saved)
        (setq hide-comments-mode--saved nil))))))

;;; --------------------------------------------------------------
;;; ORG ADD-ONS
;;; --------------------------------------------------------------

;; - orgmode auto-show latex snippet
(use-package org-fragtog
  :disabled                          ; looks weird on sway/wayland
  :diminish
  :after (org diminish)
  :hook
  (org-mode . org-fragtog-mode))

;; - dispatch src block templates
;; (eval-and-compile
;;   (defmacro cfg-org--tempo-add (typed name)
;;     "Add shortcut for TYPED -> NAME in org-babel.  See also
;; `org-structure-template-alist'."
;;     `(eval-after-load 'org-tempo
;;        (add-to-list
;;         'org-structure-template-alist
;;         (cons ,typed (concat "src " ,name)))))
;;   (dolist (pair '(("sh" . "sh")
;;                   ("el" . "emacs-lisp")
;;                   ("py" . "python")
;;                   ("md" . "markdown")))
;;     (cfg-org--tempo-add (car pair) (cdr pair))))

;;;###autoload
(use-package org-tempo
  :straight org
  :after org
  :defines org-structure-template-alist)

;;;###autoload
(with-eval-after-load 'org
  (require 'org-tempo)
  (dolist (pair '(("sh" . "sh")
                  ("el" . "emacs-lisp")
                  ("py" . "python")
                  ("md" . "markdown")))
    (add-to-list 'org-structure-template-alist
                 (cons (car pair)
                       (concat "src " (cdr pair))))))

;; org bullet reduce noise
(use-package org-bullets
  :disabled
  :after org
  :commands org-bullets-mode
  :custom (org-bullets-bullet-list '("\u200b")))

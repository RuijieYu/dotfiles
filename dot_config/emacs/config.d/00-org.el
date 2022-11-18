;; -*- no-byte-compile: nil; -*-
;;;###autoload (load (expand-file-name "autoloads/utils" user-emacs-directory))
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(org diminish)))

;;;###autoload (straight-use-package 'org)

;;;###autoload
(defun cfg-org-setup ()
  (interactive)
  (visual-line-mode)
  (setq-local fill-column 100)
  (display-fill-column-indicator-mode -1)
  (with-eval-after-load 'flyspell (flyspell-mode 0))
  (with-eval-after-load 'olivetti
    (setq-local olivetti-body-width fill-column))
  (require 'org-indent) (unless org-indent-mode (org-indent-mode))
  (require 'org-num) (unless org-num-mode (org-num-mode)))

;;;###autoload
(defun cfg-org-src-tangle ()
  "Save the currently editing orc-src buffer, and tangle the
source (.org) buffer when editing org src block.  If under
narrowing effect, only currently available code blocks are
tangled."
  (interactive)
  (when org-src-mode
    (org-edit-src-save)
    (with-current-buffer (org-src-source-buffer)
      (org-babel-tangle))))

;;;###autoload
(add-hook 'org-mode-hook #'cfg-org-setup)

;;;###autoload
;; orgmode TODO: take inspiration from
;; https://github.com/ymherklotz/dotfiles/blob/master/emacs/loader.org
(use-package org
  :commands (org-mode org-agenda-list)
  :defines org-mode-map
  :diminish
  (ispell-minor-mode . "isp")
  (auto-fill-mode . "AF")
  (org-indent-mode . "O[i]")
  (org-num-mode . "O[n]")

  :custom
  ;; tasks and agenda
  (org-enforce-todo-dependencies t)
  (org-enforce-todo-checkbox-dependencies t)
  (org-log-into-drawer t)
  ;; ( org-tags-column -63) ; for 66-width orgmode buffers
  (org-todo-keywords
   '((sequence "AVAILABLE(a)"
               "IN-PROGRESS(i!)"
               "POSTPONED(p@/!)"
               "|"
               "SUBMITTED(s!)"
               "GRADED(g@)")))

  (org-hide-block-startup nil)
  (org-confirm-babel-evaluate nil)

  ;; startup
  (org-startup-indented nil)            ; org-indent-mode
  (org-startup-numerated nil)           ; org-num-mode
  (org-startup-folded t) ; there are more options, I just want to fold everything

  ;; visuals
  (org-ellipsis " ▾")
  (org-hide-leading-stars t)
  (org-hide-emphasis-markers t)
  (org-hide-macro-markers t)
  (org-fontify-quote-and-verse-blocks t)
  (org-pretty-entities t)

  ;; inline images
  (org-image-actual-width 500)

  ;; miscellaneous configurations
  (org-cycle-separator-lines 2))

;;;###autoload
(with-eval-after-load 'org
  (let ((bullet #'(compose-region
                   (match-beginning 1) (match-end 1) "•")))
    (font-lock-add-keywords
     'org-mode `(;; MINUS at beginning, followed by WS
                 (,(rx line-start
                       (group (or ?+ ?-)) blank)
                  (0 ,bullet))
                 ;; some WS, then bullet, then WS
                 (,(rx line-start (+ blank)
                       (group (or ?+ ?- ?*)) blank)
                  (0 ,bullet)))))

  (define-keymap :keymap org-mode-map
    "C-<tab> l" #'org-agenda-list))

;;* org-src
;;;###autoload
(use-package org-src
  :straight org
  :defines org-src-mode
  :commands (org-edit-src-save
             org-src-source-buffer)
  :custom
  (org-src-preserve-indentation t)
  (org-src-tab-acts-natively t)
  (org-src-fontify-natively t))

;;;###autoload
(with-eval-after-load 'org-src
  (define-keymap :keymap org-src-mode-map
    "C-c C-v t" #'cfg--org-src-tangle))

;;* org-babel
;;;###autoload
(use-package ob-tangle
  :straight org
  :commands org-babel-tangle)

;;* keymaps
;;;###autoload
(defvar-keymap cfg-org-map
  :doc "Custom keymap for org mode."
  "l" #'org-agenda-list)

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-<tab> o" (cons "ORG" cfg-org-map)
  "C-c M-l" #'org-agenda-list)

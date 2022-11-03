;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(eshell-info-banner
             eshell-syntax-highlighting
             eshell-git-prompt)))

;;;###autoload
(use-package esh-mode
  :straight nil)

;; add additional exports
;;;###autoload
(defun cfg-eshell-export (name val &optional no-export)
  "Export NAME=VAL to all eshell environments, unless NO-EXPORT is
non-nil.  Here VAL is a simple string value to be passed
verbatim."
  (require 'esh-var)
  (setq-default eshell-variable-aliases-list
                (delete-dups
                 (cons (list name (lambda () val) t t)
                       eshell-variable-aliases-list))))

;;;###autoload
(use-package esh-opt
  :straight nil
  :custom
  (eshell-destroy-buffer-when-process-dies t)
  (eshell-visual-commands
   '("htop" "btop"
     "bash" "zsh" "fish"
     "vim" "less" "more" "man")))

;;;###autoload
(defun cfg-eshell-init-setup ()
  (interactive)
  (push #'eshell-truncate-buffer
        eshell-output-filter-functions)
  (unless (and (boundp 'eshell-git-prompt-current-theme)
               eshell-git-prompt-current-theme)
    (eshell-git-prompt-use-theme 'powerline)))

;;;###autoload
(defun cfg-eshell-setup ()
  (interactive)
  (display-line-numbers-mode -1)
  (eshell-syntax-highlighting-mode))

;;;###autoload
(use-package eshell
  :straight nil
  :after (esh-mode esh-opt)
  :commands eshell
  :hook
  (eshell-pre-command . eshell-save-some-history)
  (eshell-first-time-mode . cfg-eshell-init-setup)
  (eshell-mode . cfg-eshell-setup)
  :custom
  (eshell-history-size 10000)
  (eshell-buffer-maximum-lines 10000)
  (eshell-hist-ignoredups t)
  (eshell-scroll-to-bottom-on-input t)
  :config
  ;; ref: https://stackoverflow.com/a/3645477
  ;; idea: C-z goes to a shell in tty; also let C-z go back to
  ;; previous buffer when already in eshell
  (define-keymap :keymap eshell-mode-map
    "C-z" #'bury-buffer))

;;;###autoload
(progn (define-keymap :keymap (current-global-map)
         "C-<tab> C-<return>" #'eshell)
       (define-remap (current-global-map)
         [remap suspend-frame] #'eshell))

;;;###autoload
(use-package eshell-git-prompt
  :after eshell
  :commands eshell-git-prompt-use-theme)

;;;###autoload
(use-package eshell-syntax-highlighting
  :after esh-mode
  :commands eshell-syntax-highlighting-mode)

(use-package eshell-info-banner
  :disabled
  :hook
  (eshell-banner-load . eshell-info-banner-update-banner))

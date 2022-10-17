;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(lsp-mode lsp-ui)))

;;;###autoload
(defvar-keymap cfg-lsp-map
  :doc "The keymap under \"C-c l\" in `lsp-mode'.  For some reason the
original keymap under \"s-l\" no longer works in sway.")

;;;###autoload
(defun cfg-lsp-setup ()
  (interactive)
  (lsp-ui-mode))

;;;###autoload
(progn (add-hook 'lsp-mode-hook #'cfg-lsp-setup)
       (add-hook 'dired-mode-hook #'lsp-dired-mode)
       (add-hook 'which-key-mode-hook
                 #'lsp-enable-which-key-integration))

;;;###autoload
(use-package lsp-mode
  :after xref
  :commands (lsp
             lsp-deferred
             lsp-mode
             lsp-dired-mode
             lsp-format-region
             lsp-enable-which-key-integration)
  :defines lsp-mode-map
  :custom
  ;; allowing auto-importing
  (lsp-completion-enable-additional-text-edit t)
  (lsp-completion-provider :capf)
  (lsp-enable-on-type-formatting nil)   ; too aggressive

  ;; numbering could be helpful
  (lsp-headerline-breadcrumb-enable-symbol-numbers t))

;;;###autoload
(with-eval-after-load 'lsp-mode
  (define-keymap :keymap lsp-mode-map
    "C-c l" (cons "LSP" cfg-lsp-map))
  (set-keymap-parent
   cfg-lsp-map (keymap-lookup lsp-mode-map "s-l")))

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode)

;;;###autoload
(define-keymap :keymap cfg-lsp-map
  "l" #'lsp
  "= -" #'lsp-format-region)

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-c l l" #'lsp
  "s-l s-l" #'lsp)

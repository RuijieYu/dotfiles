;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(rustic toml-mode el-patch)))

;; add rust paths
;;;###autoload
(add-to-path "~/.cargo/bin")

;;;###autoload
(defun cfg-rust-setup ()
  "Setup rust mode"
  (interactive)
  ;; (unless (eq major-mode #'rustic-mode)
  ;;   (rustic-mode))
  ;; (lsp-deferred)
  ;; (lsp-semantic-tokens-mode)
  (hl-line-mode)
  (electric-pair-local-mode)
  (setq-local fill-column 80))

;;;###autoload
(use-package rustic
  :if (executable-find "rust-analyzer")
  :after (lsp-mode rust-mode)
  :commands (rustic-cargo-bin
             rustic-mode)
  :hook
  (rust-mode . cfg-rust-setup)
  :config
  (define-remap rustic-mode-map
    [remap rustic-racer-describe] #'cfg-noop))

;; the other package "toml" is for reading data from .toml files
;;;###autoload
(use-package toml-mode)

;;;###autoload
(use-package lsp-rust
  :no-require t
  :straight lsp-mode
  :after lsp-mode
  :custom
  ;; where is rust-analyzer
  (lsp-rust-analyzer-server-command
   "rustup run stable rust-analyzer")
  ;; rust-analyzer configurations
  (lsp-rust-analyzer-import-prefix "by_self")
  (lsp-rust-analyzer-cargo-watch-enable t)
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-proc-macro-enable t)
  (lsp-rust-analyzer-cargo-load-out-dirs-from-check t)
  (lsp-rust-analyzer-import-enforce-granularity t)
  (lsp-rust-analyzer-closing-brace-hints-min-lines 20)
  (lsp-rust-analyzer-completion-add-call-parenthesis t)
  ;; inlay hints
  (lsp-rust-analyzer-inlay-hints-mode t)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-max-inlay-hint-length 40)
  (lsp-rust-analyzer-display-reborrow-hints "mutable")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-parameter-hints t)
  (lsp-rust-analyzer-binding-mode-hints t)
  (lsp-rust-analyzer-closing-brace-hints t)
  (lsp-rust-analyzer-display-closure-return-type-hints nil)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "always")
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names t))

;;;###autoload
(with-eval-after-load 'esh-var
  ;; eshell is able to display colors
  (cfg-eshell-export "CARGO_TERM_COLOR" "always"))

;;;###autoload
(defvar-keymap cfg-lsp-rust-ctrl-c-map
  :doc "Custom keymap under \"C-c l C-c\"."
  ;; move item up or down
  "p" #'lsp-rust-analyzer-move-item-up
  "n" #'lsp-rust-analyzer-move-item-down
  ;; run code
  "C-c" #'lsp-rust-analyzer-run
  "C-d" #'lsp-rust-analyzer-debug
  ;; misc
  "d" #'lsp-rust-analyzer-open-external-docs
  "?" #'lsp-rust-analyzer-status
  "r" #'lsp-rust-analyzer-reload-workspace
  "t" #'lsp-make-rust-analyzer-view-item-tree)

;;;###autoload
(with-eval-after-load 'lsp-rust
  (define-keymap :keymap lsp-mode-map
    "C-c l C-c" cfg-lsp-rust-ctrl-c-map))

;; TODO: allow overrides for formatting (toolchain)

;;;###autoload
(use-package el-patch
  :no-require t
  :config
  ;; patch `rustic-cargo-doc' to optionally document private items.
  (el-patch-feature rustic)
  (with-eval-after-load 'rustic
    (el-patch-defun rustic-cargo-doc ((el-patch-add &optional arg))
      (el-patch-let
          ((use-doc (y-or-n-p "Open docs for dependencies as well?"))
           (docstr "Open the documentation for the current project in a browser.
The documentation is built if necessary.")
           (bin (rustic-cargo-bin)))
        (el-patch-swap docstr (el-patch-concat docstr "\n\nPATCHED via `el-patch-defun'."))
        (interactive (el-patch-add "P"))

        (el-patch-swap
          (if use-doc (shell-command (format "%s doc --open" bin))
            (shell-command (format "%s doc --open --no-deps" bin)))
          (let* ((arg (pcase arg
                        ('() arg)
                        ((pred numberp) arg)
                        ;; when single C-u, priv=true, dep=false
                        ('(4) 2)
                        ;; when double C-u, priv=true, dep=true
                        ('(16) 3)))
                 (dep (if arg (< 0 (logand arg 1))
                        use-doc))
                 (priv (if arg (< 0 (logand arg 2))
                         (y-or-n-p "Generate docs for private items?"))))
            (shell-command
             (format "%s doc %s %s --open" bin
                     (if priv "--document-private-items" "")
                     (if dep "--no-deps" "")))))))))

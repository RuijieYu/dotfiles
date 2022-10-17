;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(typescript-mode js2-mode json-mode)))

(defun cfg-js-common-setup ()
  (interactive)
  (lsp-deferred)
  (setq-local fill-column 80))

;;;###autoload
(defun cfg-js-js-setup ()
  (interactive)
  (cfg-js-common-setup)
  (lsp-javascript-inlay-hints-mode))

;;;###autoload
(defun cfg-js-ts-setup ()
  (interactive)
  (cfg-js-common-setup))

(use-package js
  :disabled
  :straight nil
  :after lsp-mode
  :hook
  (js-mode . cfg-js-js-setup))

;;;###autoload
(use-package typescript-mode
  :after lsp-mode
  :hook
  (typescript-mode . cfg-js-ts-setup))

;;;###autoload
(use-package lsp-javascript
  :no-require t
  :straight lsp-mode
  :after (lsp-mode js2-mode)
  :commands lsp-javascript-inlay-hints-mode)

;;;###autoload
(use-package js2-mode
  :mode (rx ".js" string-end)
  :hook
  (js2-mode . cfg-js-js-setup)
  ;; ref: https://github.com/sublimelsp/LSP-typescript
  :custom
  (lsp-javascript-display-inlay-hints t)
  (lsp-javascript-display-return-type-hints t)
  (lsp-javascript-display-parameter-name-hints t)
  (lsp-javascript-display-parameter-type-hints t)
  (lsp-javascript-display-property-declaration-type-hints t)
  (lsp-javascript-display-return-type-hints t)
  (lsp-javascript-display-variable-type-hints t))

;;;###autoload
(use-package json-mode
  :mode (rx ".json" string-end))

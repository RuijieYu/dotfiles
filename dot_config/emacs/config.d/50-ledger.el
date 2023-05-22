;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(ledger-mode)))

;;;###autoload
(defun cfg-ledger-setup ()
  (interactive)
  (company-mode)
  (setq-local fill-column 88
              completion-ignore-case t))

;;;###autoload
(use-package ledger-mode
  :if (executable-find "ledger")
  :after company
  :hook
  (ledger-mode . cfg-ledger-setup)
  :custom
  (ledger-report-use-header-line t)
  (ledger-report-use-strict t)
  (ledger-master-file "~/finance/finance.ledger")
  (ledger-accounts-file "~/finance/accounts.ledger"))

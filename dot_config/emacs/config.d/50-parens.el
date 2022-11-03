;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;;;###autoload
(use-package elec-pair
  :straight nil
  :commands electric-pair-local-mode
  :hook (after-init . electric-pair-mode))

;;;###autoload
(use-package electric
  :disabled
  :straight nil
  :commands electric-quote-local-mode
  :hook (after-init . electric-quote-mode))

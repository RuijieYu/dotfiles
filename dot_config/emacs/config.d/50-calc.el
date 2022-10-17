;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;;;###autoload
(use-package calc
  :straight nil
  :commands calc
  :custom
  (calc-prefer-frac t)
  (calc-display-working-message t))

;;;###autoload
(use-package calc-frac
  :straight nil
  :after calc
  :custom
  (calc-frac-format '("/" nil)))

;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(company company-quickhelp company-box diminish)))

;;;###autoload
(use-package diminish
  :commands diminish)

;;;###autoload
(use-package use-package-diminish
  :straight use-package
  :after diminish
  :commands (use-package-handler/:diminish
             use-package-normalize/:diminish))

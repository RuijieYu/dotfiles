;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;;;###autoload
(defun cfg-llvm-exists-p ()
  "Check whether \"llvm-mode\" is available."
  (file-exists-p
   (expand-file-name "llvm-mode/llvm-mode.el"
                     user-emacs-directory)))

;;;###autoload
(use-package llvm-mode
  :straight nil
  :load-path "llvm-mode"
  :if (cfg-llvm-exists-p)
  :mode ((rx ".ll" string-end) . llvm-mode))

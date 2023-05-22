;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;;;###autoload
(defun cfg-cpp-setup ()
  (interactive)
  (lsp-deferred))

;;;###autoload
(use-package cc-mode
  :straight nil
  :hook (c++-mode . cfg-cpp-setup))

;;* clang-format
;;;###autoload
(defun cfg-cpp--check-clang-format ()
  (file-exists-p
   (expand-file-name "clang-format/clang-format.el"
                     user-emacs-directory)))

;;;###autoload
(use-package clang-format
  :straight nil                         ; provided by arch "clang"
  :if (cfg-cpp--check-clang-format)
  :load-path "clang-format"
  :commands (clang-format
             clang-format-buffer
             clang-format-region))

;;;###autoload
(defvar-keymap cfg-cpp--clang-format-map
  :doc "My clang-format keymap under prefix"
  "b" #'clang-format-buffer
  "f" #'clang-format
  "r" #'clang-format-region)

;;;###autoload
(when (cfg-cpp--check-clang-format)
  (define-keymap :keymap (current-global-map)
    "C-c f f" #'clang-format
    "C-c f b" #'clang-format-buffer
    "C-c f r" #'clang-format-region))

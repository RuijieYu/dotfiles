;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(unfill)))

;;;###autoload
(use-package text-mode
  :straight nil
  :hook
  (text-mode . visual-line-mode))

;;;###autoload
(use-package unfill
  :commands unfill-paragraph)

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-c q" #'unfill-paragraph)

;;;###autoload
(with-eval-after-load 'simple
  (define-keymap :keymap visual-line-mode-map
    "C-M-q" #'unfill-paragraph))

;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(expand-region)))

;;;###autoload
(use-package expand-region
  :commands (er/expand-region
             er/contract-region
             er/mark-outside-pairs
             er/mark-inside-pairs)
  :custom
  ;; interferes with elec-pair
  (expand-region-fast-key-enabled nil))

;;;###autoload
(define-keymap :keymap (current-global-map)
  "M-[" #'er/expand-region
  "M-]" #'er/contract-region
  "C-(" #'er/mark-outside-pairs
  "C-)" #'er/mark-inside-pairs)

;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;; code folding, with additional custom keybinds
;;;###autoload
(use-package hideshow
  :straight nil
  :commands (hs-minor-mode
             hs-hide-all hs-show-all
             hs-hide-block hs-show-block
             hs-hide-level hs-toggle-hiding))

;;;###autoload
(add-hook 'prog-mode-hook #'hs-minor-mode)

;;;###autoload
(defvar-keymap cfg-hs-map
  :doc "Custom keymap for \"hideshow\" under \"C-<tab> h\".")

;;;###autoload
(with-eval-after-load 'hideshow
  (define-keymap :keymap hs-minor-mode-map
    "C-<tab> C-h" (keymap-lookup hs-minor-mode-map "C-c @")
    "C-<tab> h" cfg-hs-map))

;;;###autoload
(define-keymap :keymap cfg-hs-map
  "a" #'hs-show-all
  "c" #'hs-toggle-hiding
  "d" #'hs-hide-block
  "e" #'hs-toggle-hiding
  "h" #'hs-hide-block
  "l" #'hs-hide-level
  "s" #'hs-show-block
  "t" #'hs-hide-all
  "M-h" #'hs-hide-all
  "M-s" #'hs-show-all)

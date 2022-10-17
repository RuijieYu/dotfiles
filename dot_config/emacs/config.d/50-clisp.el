;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(slime)))

;; Inferior lisp environment
;;;###autoload
(use-package slime
  :if (executable-find "sbcl")
  :after inf-lisp
  :hook
  (lisp-mode . slime-mode)
  :defines slime-mode-map
  :custom
  (slime-lisp-implementations
   '((sbcl ("sbcl" "--noinform"))))
  ;; originally defined in "inf-lisp", but "slime" redefines it
  (inferior-lisp-program "sbcl --noinform")
  :config
  (cfg-lisp-bind-lambda slime-mode-map))

;;;###autoload
(use-package slime-repl
  :straight slime
  :after slime
  :commands slime
  :defines slime-repl-mode-map
  :config
  (cfg-lisp-bind-lambda slime-repl-mode-map)
  (define-keymap :keymap slime-repl-mode-map
    "C-c C-d h" #'slime-documentation-lookup))

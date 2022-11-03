;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(slime diminish)))

;; Inferior lisp environment
;;;###autoload
(use-package slime
  :if (executable-find "sbcl")
  :hook
  (lisp-mode . slime-mode)
  :defines slime-mode-map
  :custom
  (slime-lisp-implementations
   '((sbcl ("sbcl" "--noinform"))))
  :config
  (cfg-lisp-bind-lambda slime-mode-map))

;;;###autoload
(use-package slime-repl
  :straight slime
  :after slime
  :commands slime
  :hook
  (slime-mode . lispy-mode)
  (slime-repl-mode . lispy-mode)
  :defines slime-repl-mode-map
  :config
  (cfg-lisp-bind-lambda slime-repl-mode-map)
  (define-keymap :keymap slime-repl-mode-map
    "C-c C-d h" #'slime-documentation-lookup)
  ;; originally defined in "inf-lisp", but "slime" redefines it
  (setq inferior-lisp-program "sbcl --noinform"))

;;;###autoload
(use-package slime-autodoc
  :straight slime
  :after slime
  :commands slime-autodoc-mode
  :diminish slime-autodoc-mode)

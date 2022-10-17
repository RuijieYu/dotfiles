;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(jupyter yapfify pyenv-mode diminish)))

;; for pyenv
;;;###autoload
(add-to-path "~/.local/share/pyenv/shims")

;;;###autoload
(defun cfg-python-setup ()
  (interactive)
  (lsp-deferred)
  (setq-local fill-column 80))

;;;###autoload
(use-package python
  :straight nil
  :commands python-mode
  :hook
  (python-mode . cfg-python-setup)
  :custom
  (python-shell-interpreter
   (or (executable-find "~/.local/share/pyenv/shims/python")
       python-shell-interpreter)))

;;;###autoload
(defvar cfg-python--lsp-pyls-libs
  (list (expand-file-name "~/.local/share/pyenv/versions")
        "/usr/"))

;;;###autoload
(use-package lsp-pyls
  :no-require t
  :straight lsp-mode
  :after python
  :custom
  (lsp-clients-python-library-directories
   cfg-python--lsp-pyls-libs)
  (lsp-clients-pylsp-library-directories
   cfg-python--lsp-pyls-libs))

;;;###autoload
(use-package jupyter
  :if (executable-find "jupyter")
  :after (org python)
  :custom
  (org-babel-default-header-args:jupyter-python
   '((:async . "yes")
     (:kernel . "python3")
     (:eval . "never-export")
     (:exports . "both")))
  :config
  (dolist (lang '((python . t)
                  (jupyter . t)))
    (add-to-list 'org-babel-load-languages lang))
  (org-babel-do-load-languages
   'org-babel-load-languages
   org-babel-load-languages))

;;;###autoload
(use-package yapfify
  :diminish yapf-mode
  :after python
  :hook
  (python-mode . yapf-mode))

;;;###autoload
(use-package pyenv-mode)

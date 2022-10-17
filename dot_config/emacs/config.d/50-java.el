;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(lsp-java ant)))

;;;###autoload
(defun cfg-java-setup ()
  (interactive)
  ;; so that formatting doesn't constantly make text go beyond my
  ;; fill column indicator
  (setq-local
   fill-column 80
   ;; java has long paths, showing them on the modeline is noisy
   ;; enough
   lsp-headerline-breadcrumb-segments '(project file symbols))
  (lsp-deferred))

;;;###autoload
(use-package lsp-java
  :after lsp-mode
  :hook
  (java-mode . cfg-java-setup)
  :custom
  ;; formatting
  (lsp-java-format-on-type-enabled nil) ;; too aggressive
  (lsp-java-format-settings-url
   ;; rely on chezmoi to fetch the file for me
   (expand-file-name "eclipse-java-google-style.xml"
                     user-emacs-directory))
  (lsp-java-references-code-lens-enabled t))

;;;###autoload
(use-package ant
  :commands ant)

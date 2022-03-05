;; java.el -*- no-byte-compile: t; lexical-binding: t; -*-

;; java
(use-package lsp-java
  :hook
  ((java-mode . lsp)
   ;; so that formatting doesn't constantly make text go beyond my
   ;; fill column indicator
   (java-mode . (lambda nil (setq-local fill-column 80)))
   )
  
  :custom
  (
   ;; formatting
   (lsp-java-format-settings-url
    (expand-file-name "eclipse-java-google-style.xml"
                      user-emacs-directory))
   ;; java has long paths, showing them on the modeline is noisy
   ;; enough
   (lsp-headerline-breadcrumb-segments
    '(project file symbols))
   ;; numbering could be helpful
   (lsp-headerline-breadcrumb-enable-symbol-numbers t)
   )
  )

(use-package ant
  :commands ant
  )

;;; cfg-yaml.el --- Yaml configuration

;;; Commentary:

;;; Code:
(eval-when-compile (require 'rx))
(eval-when-compile (require 'treesit))
(require 'cl-lib)


;; * `treesit-install-language-grammar'
(eval-when-compile
  (unless (treesit-ready-p 'yaml 'quiet)
    (setf (cdr (alist-get 'yaml treesit-language-source-alist))
          "https://github.com/ikatyang/tree-sitter-yaml")
    (treesit-install-language-grammar 'yaml)))


;; * `setopt'
;;;###autoload
(setopt auto-mode-alist
        (delete-dups
         (cl-list*
          (cons (rx (or ".yml" ".yaml") eos) #'yaml-ts-mode)
          (cons (rx "/.clangd" eos) #'yaml-ts-mode)
          auto-mode-alist))
        major-mode-remap-alist
        (delete-dups
         (cons '(yaml-mode . yaml-ts-mode)
               major-mode-remap-alist)))

(provide 'cfg-yaml)
;;; cfg-yaml.el ends here.

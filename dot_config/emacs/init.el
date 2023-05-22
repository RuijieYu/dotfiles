;;; init.el --- Init -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(eval-and-compile (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory)))
(eval-and-compile (add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory)))
(eval-when-compile (byte-recompile-directory (expand-file-name "lisp" user-emacs-directory) 0))

(package-initialize)
(require 'cfg)

(provide 'init)
;;; init.el ends here.

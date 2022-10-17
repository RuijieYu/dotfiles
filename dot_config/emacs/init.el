;; init.el -*- lexical-binding: t; -*-
;; load utils autoloads
(load "utils")

;; compile and load each file sequentially, only if they exist
(eval-when-compile
  (byte-recompile-file
   (expand-file-name "config.el" user-emacs-directory) nil 0))
(load (expand-file-name "config.el" user-emacs-directory))

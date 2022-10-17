;;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;; ref:
;; https://github.com/ymherklotz/dotfiles/blob/master/emacs/loader.org
(use-package flyspell
  :if (executable-find "hunspell")
  :ensure nil
  :hook
  (text-mode . flyspell-mode)
  :custom
  (ispell-dictionary "en_US")
  (ispell-dictionary-alist
   '(("en_US" "[[:alpha:]]" "[^[:alpha:]]"
      "[']" nil ("-d" "en_US") nil utf-8)))
  (ispell-program-name (executable-find "hunspell"))
  (ispell-really-hunspell t)
  :config
  (define-keymap :keymap flyspell-mode-map
    ;; disable the following ?
    "C-." nil
    "C-," nil))

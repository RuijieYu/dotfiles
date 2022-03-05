(load (expand-file-name "pkg.el" user-emacs-directory))

;; ref: https://github.com/ymherklotz/dotfiles/blob/master/emacs/loader.org
(use-package flyspell
  :ensure nil
  :hook
  (text-mode . flyspell-mode)
  :custom
  ((ispell-dictionary "en_US")
   (ispell-dictionary-alist
    '(("en_US" "[[:alpha:]]" "[^[:alpha:]]"
       "[']" nil ("-d" "en_US") nil utf-8)))
   (ispell-program-name (executable-find "hunspell"))
   (ispell-really-hunspell t)
   )
  :bind
  (:map flyspell-mode-map
        ;; disable the following ?
        ([?\C-.] . nil)
        ([?\C-,] . nil)
        )
  )


;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '((rx-insensitive
              :type git
              :host github
              :repo "RuijieYu/emacs-rx-insensitive"))))

;;;###autoload
(use-package rx-insensitive
  :commands rx-insensitive
  :straight
  (rx-insensitive :type git
                  :host github
                  :repo "RuijieYu/emacs-rx-insensitive"))

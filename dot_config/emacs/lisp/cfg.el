;;; cfg.el --- personal configuration

;;; Commentary:

;;; Code:
(defgroup cfg nil
  "Local customizations."
  :group 'convenience)


;; `eval-and-compile' because org needs to deal with versioning
(eval-and-compile (require 'cfg-org))

(require 'cfg-min-ui)

(require 'cfg-lispy)
(require 'cfg-browse)
(require 'cfg-buffer)
(require 'cfg-chinese)
(require 'cfg-crypt)
(require 'cfg-diminish)
(require 'cfg-dired-ranger)
(require 'cfg-elisp)
(require 'cfg-frame)
(require 'cfg-hs)
(require 'cfg-mail)
(require 'cfg-mu4e)
(require 'cfg-visual)
(require 'cfg-require)
(require 'cfg-geiser)

(require 'cfg-anno)
(require 'cfg-kabb)


(autoload 'cfg-author-package-create
  "cfg-author-package" nil t)


(with-eval-after-load 'ispell
  (cfg-diminish '(ispell-minor-mode)))

(with-eval-after-load 'simple
  (cfg-diminish '(auto-fill-mode)))


(setopt
 ;; always load newer elisp
 load-prefer-newer t
 ;; indentation
 tab-width 4
 indent-tabs-mode nil
 ;; fill column
 fill-column 80
 ;; minibuffer
 enable-recursive-minibuffers t
 column-number-mode t)


(provide 'cfg)
;;; cfg.el ends here.

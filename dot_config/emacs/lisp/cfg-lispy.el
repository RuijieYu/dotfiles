;;; cfg-lispy.el --- Install and configure lispy

;;; Commentary:

;;; Code:
(require 'cfg-package-vc)
(cfg-package-install '(avy hydra))

;;;###autoload
(add-to-list 'load-path "/opt/src/emacs/packages/lispy/local")

(cfg-package-vc-install
 nil '((lispy :url "https://github.com/abo-abo/lispy")
       (zoutline :url "https://github.com/abo-abo/zoutline")))


(require 'lispy-autoloads)
(autoload 'lispy-define-key "lispy")
(autoload 'lispy-splice "lispy")
(defvar lispy-mode-map)


;; * `defun'
(eval-and-compile
  (unless (fboundp 'lispy)
    (defalias 'lispy #'lispy-mode)))


;; * `setopt'
(with-eval-after-load 'lispy
  (setopt lispy-completion-method 'ido))


;; * `add-hook'
(add-hook 'emacs-lisp-mode-hook #'lispy-mode)


;; * `define-keymap'
;; elsewhere ?/ is remapped
(with-eval-after-load 'lispy
  (lispy-define-key lispy-mode-map "\\" #'lispy-splice))


;; * `provide'
(provide 'cfg-lispy)
;;; cfg-lispy.el ends here.

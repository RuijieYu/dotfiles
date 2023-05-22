;;; cfg-pinentry.el --- Configure pinentry

;;; Commentary:

;; I don't know if this is the most preferable way to do it, but
;; after hunting online for a long time, I cannot seem to find the
;; way that does not require `pinentry' package.

;;; Code:
(require 'cfg-package)
(cfg-package-install '(pinentry))

(require 'pinentry-autoloads)
(autoload 'pinentry-stop "pinentry")


;;;###autoload
(defun cfg-pinentry-start ()
  "Start pinentry when it has not yet been started."
  (unless (bound-and-true-p pinentry--server-process)
    (pinentry-start)))

;;;###autoload
(defun cfg-pinentry-stop ()
  "Stop pinentry when it has been started."
  (when (bound-and-true-p pinentry--server-process)
    (pinentry-stop)))


(setopt epg-pinentry-mode 'loopback)
;; This requires gpg to run with both `--allow-emacs-loopback' and
;; `allow-loopback-pinentry'.


(add-hook 'after-init-hook #'cfg-pinentry-start)
(add-hook 'kill-emacs-hook #'cfg-pinentry-stop)

(provide 'cfg-pinentry)
;;; cfg-pinentry.el ends here.

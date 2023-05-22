;;; cfg-mail.el --- Configure all mail related things.

;;; Commentary:

;;; Code:
(require 'cfg-package)
(require 'sendmail)
(when (executable-find "mbsync") (require 'cfg-mu4e))


;; * `setopt'
(with-eval-after-load 'smtpmail
  (setopt
   smtpmail-queue-dir (expand-file-name "~/.local/mail/queued")
   smtpmail-queue-mail t
   smtpmail-smtp-service 587            ; submission port
   smtpmail-store-queue-variables t
   smtpmail-warn-about-unknown-extensions t
   smtpmail-smtp-server "mail.netyu.xyz"
   smtpmail-default-smtp-server "mail.netyu.xyz"))

(with-eval-after-load 'sendmail
  (setopt send-mail-function #'smtpmail-send-it))

(with-eval-after-load 'mu4e
  (setopt mail-user-agent 'mu4e-user-agent))

(with-eval-after-load 'message
  (setopt message-user-fqdn "netyu.xyz"))

(setopt user-full-name "Ruijie Yu")

;; `startup'
(setopt mail-host-address "netyu.xyz")
(setopt user-mail-address "ruijie@netyu.xyz")


(provide 'cfg-mail)
;;; cfg-mail.el ends here.

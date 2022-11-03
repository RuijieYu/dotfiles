;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(mu4e-alert)))

;;;###autoload
(use-package smtpmail
  :straight nil
  :custom
  (smtpmail-queue-dir
   (expand-file-name "~/.local/mail/queued"))
  (smtpmail-queue-mail t)
  (smtpmail-smtp-service 587)
  (smtpmail-store-queue-variables t)
  (smtpmail-warn-about-unknown-extensions t))

;;;###autoload
(use-package mu4e-server
  :after mu4e
  :straight nil
  :custom
  ;; (mu4e-mu-home (expand-file-name "~/.local/mail/maildirs"))
  (mu4e-change-filename-when-moving t))

;;;###autoload
(defconst cfg-mail-mu4e-accounts
  (list
   ;; personal address
   (let ((name "ruijie")
         (domain "netyu.xyz"))
     `("netyu"
       (mu4e-sent-folder ,(format "/%s/Sent" domain))
       (user-mail-address ,(format "%s@%s" name domain))
       (smtpmail-smtp-user ,name)
       (smtpmail-local-domain ,domain)
       (smtpmail-default-smtp-server ,(format "mail.%s" domain))
       (smtpmail-smtp-service 587)))
   ;; gmail
   ))

;;;###autoload
(defun cfg-mail-mu4e-set-account ()
  "Set the account for composing a message.

References: URL
`http://cachestocaches.com/2017/3/complete-guide-email-emacs-using-mu-and-/';
URL
`https://www.djcbsoftware.nl/code/mu/mu4e/Multiple-accounts.html'."
  (save-match-data
    (let* ((account
            (if mu4e-compose-parent-message
                (let ((mdir (mu4e-message-field
                             mu4e-compose-parent-message
                             :maildir)))
                  (string-match "/\\(.*?\\)/" mdir)
                  (match-string 1 mdir))
              (completing-read
               (format "Compose with account: (%s) "
                       (mapconcat #'car cfg-mail-mu4e-accounts))
               nil t nil nil (caar cfg-mail-mu4e-accounts))))
           (account-vars
            (cdr (assoc account cfg-mail-mu4e-accounts))))
      (if account-vars
          (mapc (lambda (var) (set (car var) (cadr var)))
                account-vars)
        (error "No email account found.")))))

;;;###autoload
(add-hook 'mu4e-compose-pre-hook #'cfg-mail-mu4e-set-account)

;;;###autoload
(defun cfg-mail-mu4e-contexts ()
  (list
   ;; personal address
   (let ((dom "netyu.xyz"))
     (make-mu4e-context
      :name dom
      :match-func
      (lambda (msg)
        (and msg (string-prefix-p
                  "/" (mu4e-message-field msg :maildir))))
      :vars `((mu4e-trash-folder . ,(format "/%s/Trash" dom))
              (mu4e-drafts-folder . ,(format "/%s/Drafts" dom))
              (mu4e-refile-folder . ,(format "/%s/Archive" dom))
              (mu4e-sent-folder . ,(format "/%s/Sent" dom)))))
   ;; gmail account
   ))

;;;###autoload
(use-package mu4e
  :if (and (executable-find "mu")
           (executable-find "mbsync"))
  :straight nil
  :commands (mu4e mu4e-quit mu4e-headers-mark-for-move)
  :defines (mu4e-main-mode-map
            mu4e-headers-mode-map)
  :custom
  (mu4e-get-mail-command "mbsync -a")
  ;; align with server settings
  (mu4e-sent-folder "/Sent")
  (mu4e-drafts-folder "/Drafts")
  (mu4e-trash-folder "/Trash")
  (mu4e-refile-folder "/Archive")
  :config
  (define-keymap :keymap mu4e-main-mode-map
    "q" #'bury-buffer
    "Q" #'mu4e-quit)
  (define-keymap :keymap mu4e-headers-mode-map
    "M" #'mu4e-headers-mark-for-move)
  (setq mu4e-contexts (cfg-mail-mu4e-contexts)))

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-<tab> e" #'mu4e)

;;;###autoload
(use-package mu4e-alert
  :after mu4e
  :if (pcase system-type                ; see doc for full list
        ('gnu/linux (executable-find "notify-send")) ; GNU/Linux
        ;; I don't use those, but here they are
        ('(gnu gnu/kfreebsd) nil)       ; GNU Hurd | GNU FreeBSD
        ('(ms-dos windows-nt) nil)      ; Windows MS-DOS | W32
        ('cygwin nil)                   ; Cygwin
        ('haiku nil)                    ; haiku
        ('darwin nil)                   ; Mac OS
        (_ nil))                        ; some Unix

  :hook
  (after-init . mu4e-alert-enable-notifications)
  :demand t
  :commands (mu4e-alert-enable-mode-line-display
             mu4e-alert-set-default-style)
  :config
  (mu4e-alert-set-default-style 'libnotify) ; use notify-send
  (mu4e-alert-enable-mode-line-display))

;;;###autoload
(use-package message
  :straight nil
  :custom
  (message-kill-buffer-on-exit t))

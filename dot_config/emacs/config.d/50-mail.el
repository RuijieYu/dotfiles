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
(use-package mu4e
  :if (and (executable-find "mu")
           (executable-find "mbsync"))
  :straight nil
  :commands (mu4e mu4e-quit mu4e-headers-mark-for-move)
  :defines (mu4e-main-mode-map
            mu4e-headers-mode-map)
  :custom
  (mu4e-get-mail-command "mbsync -a")
  :config
  (define-keymap :keymap (current-global-map)
    "C-<tab> e" #'mu4e)
  (define-keymap :keymap mu4e-main-mode-map
    "q" #'bury-buffer
    "Q" #'mu4e-quit)
  (define-keymap :keymap mu4e-headers-mode-map
    "M" #'mu4e-headers-mark-for-move))

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

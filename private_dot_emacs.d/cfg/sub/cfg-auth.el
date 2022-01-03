(require 'cfg-package)

;; I use pass
(use-package password-store
  :ensure t
  :custom
  ;; something doesn't accept >30 today
  (password-store-password-length 30)
  )
(use-package password-store-otp
  :ensure t
  :requires password-store
  )
(use-package auth-source-pass
  :ensure nil
  :config
  (auth-source-pass-enable)
  )

(use-package pinentry
  :ensure t
  :custom
  (epg-pinentry-mode 'loopback)
  :config
  ;; this is undocumented, but shown in code: only start pinentry if
  ;; not already done so
  (unless (process-live-p pinentry--server-process)
    (pinentry-start))
  )

(provide 'cfg-auth)

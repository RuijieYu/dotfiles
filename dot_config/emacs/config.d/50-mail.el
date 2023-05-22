;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(mu4e-alert)))

;;;###autoload
(use-package smtpmail
  :straight nil
  :commands smtpmail-send-it
  :custom
  (smtpmail-queue-dir
   (expand-file-name "~/.local/mail/queued"))
  (smtpmail-queue-mail t)
  (smtpmail-smtp-service 587)
  (smtpmail-store-queue-variables t)
  (smtpmail-warn-about-unknown-extensions t))

;;;###autoload
(use-package sendmail
  :straight nil
  :custom
  (send-mail-function #'smtpmail-send-it))

;;;###autoload
(defun cfg-mail-mu4e-contexts ()
  (list
   ;; personal address
   (let ((dom "netyu.xyz"))
     (make-mu4e-context
      :name dom
      :match-func #'cfg-mail--mu4e-context-match
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
  :load-path "/usr/share/emacs/site-lisp/mu4e"
  :straight nil
  :commands (mu4e mu4e-quit)
  :defines mu4e-main-mode-map
  :custom
  (mu4e-get-mail-command "mbsync -a")
  (mu4e-change-filenames-when-moving t)
  ;; align with server settings
  (mu4e-sent-folder "/Sent")
  (mu4e-drafts-folder "/Drafts")
  (mu4e-trash-folder "/Trash")
  (mu4e-refile-folder "/Archive")
  :init
  (define-keymap :keymap (current-global-map)
    "C-<tab> e" #'mu4e
    "C-<tab> m u" #'mu4e-update-mail-and-index
    "C-<tab> m C-u" #'mu4e-update-index)
  :config
  (define-keymap :keymap mu4e-main-mode-map
    "q" #'bury-buffer
    "Q" #'mu4e-quit
    "C-c M-u" #'mu4e-update-index)
  (setq mu4e-contexts (cfg-mail-mu4e-contexts)))

;;;###autoload
(use-package mu4e-vars
  :after mu4e
  :straight nil
  :custom-face
  (mu4e-trashed-face ((t :inherit font-lock-comment-face
                         :foreground "#cfcfcf"
                         :strike-through t))))

;;;###autoload
(defun cfg-mail-toggle-include-related ()
  "Toggle the value of `mu4e-headers-include-related'."
  (interactive)
  (require 'mu4e-vars)
  (setq mu4e-headers-include-related
        (not mu4e-headers-include-related)))

;;;###autoload
(use-package mu4e-search
  :after mu4e
  :straight nil
  :custom
  (mu4e-headers-result-limit 2000)
  (mu4e-search-results-limit 2000))

;;;###autoload
(use-package mu4e-server
  :after mu4e
  :straight nil
  :custom
  (mu4e-change-filenames-when-moving t))

;;;###autoload
(defconst cfg-mail-mu4e-accounts
  (list
   ;; personal address
   (let ((name "ruijie")
         (nickname "netyu")
         (domain "netyu.xyz"))
     `(nickname
       (mu4e-sent-folder ,(format "/%s/Sent" domain))
       (user-mail-address ,(format "%s@%s" name domain))
       (smtpmail-smtp-user ,name)
       (smtpmail-local-domain ,domain)
       (smtpmail-default-smtp-server ,(format "mail.%s" domain))
       (smtpmail-smtp-service 587)))
   ;; gmail
   ))

;;;###autoload
(defun cfg-mail-find-account-for-domain (domain)
  "Get the account name for DOMAIN.
This function consults `cfg-mail-mu4e-accounts' , and assumes
that the :maildir field is the same as `smtpmail-local-domain'."
  (car
   (cl-find-if
    (lambda (elem)
      (string= domain (cadr (assoc 'smtpmail-local-domain
                                   (cdr elem)))))
    cfg-mail-mu4e-accounts)))

;;;###autoload
(defun cfg-mail-mu4e-set-account ()
  "Set the account for composing a message.

References: URL
`http://cachestocaches.com/2017/3/complete-guide-email-emacs-using-mu-and-/';
URL
`https://djcbsoftware.nl/code/mu/mu4e/Multiple-accounts.html'."
  (save-match-data
    (let* ((account
            (cond
             (mu4e-compose-parent-message
              (let ((mdir (mu4e-message-field
                           mu4e-compose-parent-message
                           :maildir)))
                (cfg-mail-find-account-for-domain
                 (save-match-data
                   (string-match
                    (rx ?/ (group (+ (not ?/))) (?  ?/))
                    mdir)
                   (match-string 1 mdir)))))
             ((length= cfg-mail-mu4e-accounts 1)
              (caar cfg-mail-mu4e-accounts))
             (t (let ((accounts
                       (mapcar #'car cfg-mail-mu4e-accounts)))
                  (completing-read
                   "Compose with account: "
                   accounts nil nil (car accounts))))))
           (account-vars
            (cdr (assoc account cfg-mail-mu4e-accounts))))
      (if account-vars
          (mapc (lambda (var) (set (car var) (cadr var)))
                account-vars)
        (error "No email account found.")))))

;;;###autoload
(add-hook 'mu4e-compose-pre-hook #'cfg-mail-mu4e-set-account)

;;;###autoload
(defun cfg-mail--mu4e-context-match (msg)
  (and msg (string-prefix-p
            "/" (mu4e-message-field msg :maildir))))

;;;###autoload
(use-package mu4e-view
  :after mu4e
  :straight nil
  :custom
  (mu4e-view-fields
   '(;; additional ones
     :message-id
     :list
     :path :size
     ;; default values
     :from
     :to
     :cc
     :subject
     :flags
     :date
     :maildir
     :mailing-list
     :tags
     :attachments
     :signature
     :decryption)))

;;;###autoload
(use-package mu4e-headers
  :straight nil
  :after mu4e
  :commands mu4e-headers-mark-for-move
  :defines mu4e-headers-mode-map
  :custom
  (mu4e-headers-fields
   '((:human-date . 12)
     (:flags . 6)
     (:maildir . 20)
     (:mailing-list . 10)
     (:from . 22)
     (:subject)))
  :config
  (define-keymap :keymap mu4e-headers-mode-map
    "M" #'mu4e-headers-mark-for-move
    "C-c C-f" #'smtpmail-send-queued-mail
    "f" #'smtpmail-send-queued-mail))

;;;###autoload
(use-package mu4e-update
  :after mu4e
  :straight nil
  :custom
  (mu4e-update-interval 600))
;; (with-eval-after-load 'mu4e
;;   (require 'mu4e-update)
;;   (setopt mu4e-update-interval 600))

;;;###autoload
(use-package mu4e-draft
  :after mu4e
  :straight nil
  :custom
  (mu4e-compose-context-policy 'ask-if-none))
;; (with-eval-after-load 'mu4e
;;   (require 'mu4e-draft)
;;   (setopt mu4e-compose-context-policy 'ask-if-none))

;;;###autoload
(defun cfg-mail-compose-setup ()
  (interactive)
  (auto-save-mode 0))

;;;###autoload
(use-package mu4e-compose
  :after mu4e
  :straight nil
  :commands (mu4e~compose-mail
             mu4e-compose-mode)
  :demand t
  :config
  (require 'nadvice)
  (advice-add #'compose-mail :override #'mu4e~compose-mail)
  (add-hook 'mu4e-compose-mode-hook
            #'cfg-mail-compose-setup))

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
(use-package mu4e-bookmarks
  :after mu4e
  :demand t
  :straight nil
  :custom
  (mu4e-bookmarks
   `((:name "Flagged" :query "flag:flagged" :key ?f)
     ,@(mapcar (lambda (n)
                 `(:name ,(format "Last %d day(s)" n)
                         :query ,(format "date:%dd..now" n)
                         :key ;; ?d
                         ,(+ ?0 n)))
               ;; '(2)
               '(1 2 3 4 5 6 7))
     ;; mailing lists
     (:name "Orgmode" :query "list:emacs-orgmode.gnu.org" :key ?O)
     (:name "EmacsBug" :query "list:bug-gnu-emacs.gnu.org" :key ?B)
     (:name "EmacsDev" :query "list:emacs-devel.gnu.org" :key ?E)
     ;; built-in bookmarks
     (:name "Unread messages" :query "flag:unread AND NOT flag:trashed" :key ?u)
     (:name "Today's messages" :query "date:today..now" :key ?t)
     (:name "Last 7 days" :query "date:7d..now" :hide-unread t :key ?w)
     (:name "Messages with images" :query "mime:image/*" :key ?p))))

;;;###autoload
(use-package mu4e-folders
  :after mu4e
  :demand t
  :straight nil
  :custom
  (mu4e-maildir-shortcuts
   (prog2 (require 'cl-lib)
       (cl-flet ((sub (sub) (concat "/netyu.xyz" sub)))
         `((:maildir ,(sub "") :key ??)
           (:maildir ,(sub "/emacs-orgmode.gnu.org") :key ?O)
           (:maildir ,(sub "/bug-gnu-emacs.gnu.org") :key ?B)
           (:maildir ,(sub "/emacs-devel.gnu.org") :key ?E)
           (:maildir ,(sub "/help-gnu-emacs.gnu.org") :key ?H)
           (:maildir ,(sub "/Job") :key ?j)
           ;; junk
           (:maildir ,(sub "/.Junk") :key ?.))))))

;;;###autoload
(use-package message
  :straight nil
  :custom
  (message-kill-buffer-on-exit t))

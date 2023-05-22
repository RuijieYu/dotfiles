;;; cfg-mu4e.el --- Configuration for mu4e.

;;; Commentary:

;; Loading this package requires that (executable-find "mbsync")
;; returns non-nil.

;;; Code:
;; * `require'
(eval-and-compile (require 'cl-lib))
(eval-and-compile
  (cl-pushnew "/usr/share/emacs/site-lisp/mu4e" load-path
              :test #'string=))
(eval-when-compile (require 'rx))
(eval-when-compile (require 'cl-macs))
(require 'cl-seq)
;; (require 'mu4e)


;; * `defvar', `declare-function'
(defvar mu4e-compose-parent-message)
(defvar mu4e-contexts)
(defvar mu4e-headers-mode-map)
(defvar mu4e-main-mode-map)

(autoload 'make-mu4e-context "mu4e-message")
(autoload 'mu4e "mu4e" nil t)
(autoload 'mu4e-headers-mark-for-move "mu4e-headers" nil t)
(autoload 'mu4e-message-field "mu4e-message")
(autoload 'mu4e-quit "mu4e" nil t)
(autoload 'mu4e-update-index "mu4e-update" nil t)
(autoload 'mu4e-update-mail-and-index "mu4e-update" nil t)


;; * Load-time Assertions
(unless (executable-find "mbsync")
  (error "`mu4e' fails to load because \"mbsync\" is absent"))


;; * `defvar' `defconst'

;;;###autoload
(defconst cfg-mu4e-accounts
  (list
   ;; personal address
   (let ((name "ruijie")
         (nick "netyu")
         (domain "netyu.xyz"))
     `(,nick
       (mu4e-sent-folder ,(format "/%s/Sent" domain))
       (user-mail-address ,(format "%s@%s" name domain))
       (smtpmail-smtp-user ,name)
       (smtpmail-local-domain ,domain)
       (smtpmail-default-smtp-server ,(format "mail.%s" domain))
       (smtpmail-smtp-service 587)))
   ;; gmail
   )
  "Locally defined mu4e accounts.")


;; * `defun'
(defun cfg-mu4e--find-account (domain)
  "Get the account name for DOMAIN.
This function consults `cfg-mu4e-accounts' , and assumes that the
:maildir field is the same as `smtpmail-local-domain'."
  (car
   (cl-find-if
    (lambda (elem)
      (string= domain (nth 1 (assq 'smtpmail-local-domain
                                   (cdr elem)))))
    cfg-mu4e-accounts)))

(defun cfg-mu4e-context-match (msg)
  "Match MSG for `make-mu4e-context'."
  (and msg (string-prefix-p
            "/" (mu4e-message-field msg :maildir))))

;;;###autoload
(defun cfg-mu4e-contexts ()
  "Return all local mu4e contexts."
  (list
   ;; personal address
   (let ((dom "netyu.xyz"))
     (make-mu4e-context
      :name dom
      :match-func #'cfg-mu4e-context-match
      :vars `((mu4e-trash-folder . ,(format "/%s/Trash" dom))
              (mu4e-drafts-folder . ,(format "/%s/Drafts" dom))
              (mu4e-refile-folder . ,(format "/%s/Archive" dom))
              (mu4e-sent-folder . ,(format "/%s/Sent" dom)))))
   ;; ...
   ))

(defun cfg-mu4e-set-account ()
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
                (cfg-mu4e--find-account
                 (save-match-data
                   (string-match
                    (rx ?/ (group (+ (not ?/))) (opt ?/))
                    mdir)
                   (match-string 1 mdir)))))
             ((length= cfg-mu4e-accounts 1)
              (caar cfg-mu4e-accounts))
             (t (let ((accounts
                       (mapcar #'car cfg-mu4e-accounts)))
                  (completing-read
                   "Compose with account: "
                   accounts nil nil (car accounts))))))
           (account-vars
            (cdr (assoc account cfg-mu4e-accounts))))
      (if account-vars
          (mapc (apply-partially #'apply #'set) account-vars)
        (error "No email account found")))))

;;;###autoload
(defun cfg-mu4e-compose-setup ()
  "Setup for mu4e mail draft buffer."
  (interactive)
  (auto-save-mode -1))


;; * `setopt'
(with-eval-after-load 'mu4e-search
  (setopt mu4e-headers-result-limit 2000
          mu4e-search-results-limit 2000))

(with-eval-after-load 'mu4e-server
  (setopt mu4e-change-filenames-when-moving t))

(with-eval-after-load 'mu4e-view
  (setopt mu4e-view-fields
          (delete-dups
           (cl-list* :message-id :list :path :size
                     (default-value 'mu4e-view-fields)))))

(with-eval-after-load 'mu4e-headers
  (setopt mu4e-headers-fields
          '((:human-date . 12)
            (:flags . 6)
            (:maildir . 20)
            (:mailing-list . 12)
            (:from . 20)
            (:to . 20)
            (:subject))))

(with-eval-after-load 'mu4e-update
  (setopt mu4e-get-mail-command "mbsync -a"
          mu4e-update-interval 600))

(with-eval-after-load 'mu4e-draft
  (setopt mu4e-compose-context-policy 'ask-if-none))

(with-eval-after-load 'mu4e-bookmarks
  (setopt
   mu4e-bookmarks
   (delete-dups
    (nconc      ; safe because all but last list are newly created
     '((:name "Flagged" :query "flag:flagged" :key ?f)
       (:name "Replied" :query "flag:replied" :key ?r))
     (mapcar (lambda (n)
               (list :name (format "Last %d day(s)" n)
                     :query (format "date:%dd..now" n)
                     :key (+ ?0 n)))
             (number-sequence 1 7))
     ;; mailing lists
     (mapcan (lambda (entry)
               (pcase entry
                 (`(,(and (pred stringp) name)
                    ,(and (pred stringp) query)
                    ,(and (pred natnump) key))
                  `((:name ,name :query ,query :key ,key)))))
             '(("Orgmode" "list:emacs-orgmode.gnu.org" ?O)
               ("EmacsBug" "list:bug-gnu-emacs.gnu.org" ?B)
               ("EmacsDev" "list:emacs-devel.gnu.org" ?E)
               ("EmacsDiff" "list:emacs-diffs.gnu.org" ?D)))
     (custom--standard-value 'mu4e-bookmarks)))))

(with-eval-after-load 'mu4e-folders
  (setopt
   ;; align with server settings
   mu4e-sent-folder "/Sent"
   mu4e-drafts-folder "/Drafts"
   mu4e-trash-folder "/Trash"
   mu4e-refile-folder "/Archive"
   mu4e-maildir-shortcuts
   (mapcan
    (lambda (entry)
      (pcase entry
        (`(,(and (pred stringp) maildir)
           ,(and (pred natnump) key))
         `((:maildir ,(concat "/netyu.xyz" maildir) :key ,key)))))
    '(("" ??)
      ("/Job" ?j)
      ;; lists
      ("/emacs-orgmode.gnu.org" ?O)
      ("/bug-gnu-emacs.gnu.org" ?B)
      ("/emacs-devel.gnu.org" ?E)
      ("/help-gnu-emacs.gnu.org" ?H)
      ("/emacs-diffs.gnu.org" ?D)
      ;; junk
      ("/.Junk" ?.)))))

(with-eval-after-load 'mu4e-lists
  (setopt
   mu4e-user-mailing-lists
   '(;; Emacs
     ("bug-gnu-emacs.gnu.org" . "EmacsBug")
     ("emacs-diffs.gnu.org" . "EmacsDiff")
     ;; SourceHut
     ("~sircmpwn/sr.ht-discuss.lists.sr.ht" . "SrHtDiscuss"))))

(with-eval-after-load 'mu4e-vars
  (setopt mu4e-eldoc-support t
          mu4e-notification-support t))

(with-eval-after-load 'mu4e-window
  (setopt mu4e-compose-in-new-frame t))

(with-eval-after-load 'mu4e-contacts
  (setopt mu4e-compose-reply-ignore-address
          (nconc (list (rx bos "bug-gnu-emacs@gnu.org" eos))
                 (custom--standard-value
                  'mu4e-compose-reply-ignore-address))))

(with-eval-after-load 'mu4e
  (setq mu4e-contexts (cfg-mu4e-contexts)))

(with-eval-after-load 'message
  (setopt message-kill-buffer-on-exit t))


;; * `define-keymap'
;;;###autoload
(define-keymap :keymap global-map
  "C-<tab> e"
  (if (executable-find "mbsync") #'mu4e
    (lambda () (interactive) (user-error "Cannot locate \"mbsync\""))))

(with-eval-after-load 'mu4e
  (define-keymap :keymap global-map
    "C-<tab> m u" #'mu4e-update-mail-and-index
    "C-<tab> m C-u" #'mu4e-update-index))

(with-eval-after-load 'mu4e-main
  (define-keymap :keymap mu4e-main-mode-map
    "q" #'bury-buffer
    "Q" #'mu4e-quit
    "C-c M-u" #'mu4e-update-index))

(with-eval-after-load 'mu4e-headers
  (define-keymap :keymap mu4e-headers-mode-map
    "C-<tab>" nil         ; we still have <tab> for thread folding
    "M" #'mu4e-headers-mark-for-move
    "C-c C-f" #'smtpmail-send-queued-mail
    "f" #'smtpmail-send-queued-mail))


;; * `custom-set-faces'
(with-eval-after-load 'mu4e-vars
  (custom-set-faces
   '(mu4e-trashed-face ((t :inherit font-lock-comment-face
                           :foreground "#cfcfcf"
                           :strike-through t)))))

;; TODO: mu4e-alert


;; * `add-hook'
;;;###autoload
(add-hook 'mu4e-compose-pre-hook #'cfg-mu4e-set-account)
;;;###autoload
(add-hook 'mu4e-compose-pre-hook #'cfg-mu4e-compose-setup)

;; https://www.djcbsoftware.nl/code/mu/mu4e/Dired.html
(add-hook 'dired-mode-hook #'turn-on-gnus-dired-mode)


(provide 'cfg-mu4e)
;;; cfg-mu4e.el ends here.

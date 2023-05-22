;;; cfg-min-ui.el --- configuration to minimise UI

;;; Commentary:

;;; Code:
;(advice-add 'yes-or-no-p :override #'y-or-n-p)
(setopt use-short-answers t)

(setopt
 ;; disable various UI modes
 scroll-bar-mode nil
 tool-bar-mode nil
 tooltip-mode nil
 menu-bar-mode nil
 ;; further UI minimisation
 inhibit-startup-message t
 use-dialog-box nil
 ;; mouse wheel scrolling
 mouse-wheel-scroll-amount '(1 ((shift) . 1)
                               ((meta) . hscroll))
 mouse-wheel-progressive-speed nil
 mouse-wheel-follow-mouse t
 scroll-step 1
 ;; don't warn about large files, I know what I'm in for
 large-file-warning-threshold nil)

(provide 'cfg-min-ui)
;;; cfg-min-ui.el ends here.

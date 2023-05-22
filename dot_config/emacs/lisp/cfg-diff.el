;;; cfg-diff.el --- Configure diff-related settings

;;; Commentary:

;;; Code:
(with-eval-after-load 'vc-git
  (setopt vc-git-diff-switches "--ignore-space-change"))


;; * `provide'
(provide 'cfg-diff)
;;; cfg-diff.el ends here.

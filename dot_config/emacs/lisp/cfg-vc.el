;;; cfg-vc.el --- VC related configuration

;;; Commentary:

;;; Code:


;; * `defgroup'
(defgroup cfg-vc nil "VC configuraions."
  :group 'cfg)


;; * `setopt'
(with-eval-after-load 'vc
  (setopt vc-diff-switches "-b --normal -d"))

(with-eval-after-load 'vc-git
  (setopt vc-git-diff-switches nil))


;; * `provide'
(provide 'cfg-vc)
;;; cfg-vc.el ends here.

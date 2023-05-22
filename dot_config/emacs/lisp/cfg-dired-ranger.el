;;; cfg-dired-ranger.el --- Configure dired-ranger (under dired-hacks)

;;; Commentary:

;;; Code:
(require 'cfg-dired-hacks)


;; * `defvar'
(defvar dired-mode-map)

;;;###autoload
(defvar-keymap cfg-dired-ranger-map
  :doc "Keymap for `dired-ranger'."
  "b" #'dired-ranger-bookmark
  "c" #'dired-ranger-copy
  "p" #'dired-ranger-paste
  "r" #'dired-ranger-move
  "v" #'dired-ranger-bookmark-visit)


;; * `define-keymap'
(with-eval-after-load 'dired
  (define-keymap :keymap dired-mode-map
    ";" (cons "Ranger" cfg-dired-ranger-map)))

(provide 'cfg-dired-ranger)
;;; cfg-dired-ranger.el ends here.

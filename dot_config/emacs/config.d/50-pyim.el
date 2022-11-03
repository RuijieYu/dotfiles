;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(pyim pyim-basedict
                  (pyim-tsinghua-dict
                   :type git
                   :host github
                   :repo "redguardtoo/pyim-tsinghua-dict"))))

;;;###autoload
(use-package pyim-common
  :straight pyim
  :commands pyim-flatten-tree)

;;;###autoload
(use-package pyim
  :after pyim-common
  :commands pyim-select-word-by-number
  :custom
  (pyim-english-input-switch-functions
   '(pyim-probe-dynamic-english         ; use M-j to convert
     pyim-probeprogram-mode))
  ;; half-width punctuations
  (pyim-punctuation-half-width-functions
   '(pyim-probe-punctuation-line-beginning
     pyim-probe-punctuation-after-punctuation))
  ;; use the first available tooltip from the list, posframe may
  ;; require additional dependencies?
  (pyim-page-tooltip '(posframe popup minibuffer))
  ;; use C-u C-\ to select an alternative IM
  (default-input-method "pyim")
  (pyim-default-scheme 'quanpin)
  (pyim-page-length 12)

  :config
  (define-keymap :keymap pyim-mode-map
    ;; TODO, check if this works as expected
    ;; ([?\M-f] . pyim-forward-word)
    ;; ([?\M-b] . pyim-backward-word)
    ;; use control-keys to switch pages
    "C-," #'pyim-page-previous-page
    "C-." #'pyim-page-next-page
    "C-;" #'pyim-page-previous-page
    "C-'" #'pyim-page-next-page
    "C-[" #'pyim-page-previous-page
    "C-]" #'pyim-page-next-page
    ;; rebind - and = to select 11th and 12th candidate
    "-" (lambda () (interactive) (pyim-select-word-by-number 11))
    "=" (lambda () (interactive) (pyim-select-word-by-number 12))))

;; Start pyim IME via M-j
;;;###autoload
(define-keymap :keymap (current-global-map)
  "M-j" #'pyim-convert-string-at-point)

;;;###autoload
(use-package pyim-basedict
  :after pyim
  :hook
  (after-init . pyim-basedict-enable))

;;;###autoload
(use-package pyim-tsinghua-dict
  :straight (pyim-tsinghua-dict
             :type git
             :host github
             :repo "redguardtoo/pyim-tsinghua-dict")
  :after pyim
  :hook
  (after-init . pyim-tsinghua-dict-enable))

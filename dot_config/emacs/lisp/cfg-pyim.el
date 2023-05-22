;;; cfg-pyim.el --- Configure Chinese IME

;;; Commentary:

;;; Code:
(require 'cfg-package-vc)
(cfg-package-install '(pyim pyim-basedict xr))
(cfg-package-vc-install
 nil
 '((pyim-tsinghua-dict
    :url "https://github.com/redguardtoo/pyim-tsinghua-dict")
   (pyim-wbdict
    :url "https://github.com/tumashu/pyim-wbdict")))

(require 'pyim)


(defgroup cfg-pyim nil
  "Configuration for pyim."
  :group 'cfg)


;; * `defcustom'
(defcustom cfg-pyim-mode-of-operation 'wubi
  "Mode of operation for pyim."
  :type '(choice (const :tag "Pinyin + toggle pyim" pinyin)
                 (const :tag "Wubi + full pyim" wubi))
  :set
  (lambda (n v)
    (pcase v
      ('wubi
       (setopt pyim-english-input-switch-functions nil
               ;; half-width punctuations
               pyim-punctuation-half-width-functions
               '(pyim-probe-punctuation-line-beginning
                 pyim-probe-punctuation-after-punctuation)))
      ('pinyin
       (setopt pyim-english-input-switch-functions
               '(pyim-probe-dynamic-english ; use M-j to convert
                 pyim-probe-program-mode)
               ;; half-width punctuations
               pyim-punctuation-half-width-functions
               '(pyim-probe-punctuation-line-beginning
                 pyim-probe-punctuation-after-punctuation)))
      (_ (error "Bad value of `%s': `%S'" n v)))
    (set n v)
    (setopt pyim-assistant-scheme 'pinyin
            pyim-default-scheme v)))


;; * `defun'
(defun cfg-pyim-setup ()
  "Setup pyim environment."
  (interactive)
  (require 'pyim-basedict)
  (require 'pyim-tsinghua-dict)
  (require 'pyim-wbdict-autoloads)
  
  (pyim-basedict-enable)
  (pyim-tsinghua-dict-enable)
  (pyim-wbdict-v86-enable)
  (pyim-wbdict-v86-single-enable))


;; * `setopt'
(setopt
 cfg-pyim-mode-of-operation 'wubi
 ;; use the first available tooltip from the list, posframe may
 ;; require additional dependencies?
 pyim-page-tooltip '(posframe popup minibuffer)
 ;; use C-u C-\ to select an alternative IM
 default-input-method "pyim"
 pyim-page-length 12
 pyim-outcome-trigger nil               ; I don't use this feature
 )


;;;###autoload
(add-hook 'after-init-hook #'cfg-pyim-setup)
(cfg-pyim-setup)


;;;###autoload
(define-keymap :keymap global-map
  "M-j" #'pyim-convert-string-at-point)

(eval-when-compile (require 'lispy))
(with-eval-after-load 'lispy
  (define-keymap :keymap lispy-mode-map
    "M-j" nil))

(define-keymap :keymap pyim-mode-map
  ;; use control-keys to switch pages
  "C-," #'pyim-page-previous-page
  "C-." #'pyim-page-next-page
  "C-;" #'pyim-page-previous-page
  "C-'" #'pyim-page-next-page
  "C-[" #'pyim-page-previous-page
  "C-]" #'pyim-page-next-page
  ;; rebind - and = to select 11th and 12th candidate
  "-" (lambda () (interactive) (pyim-select-word-by-number 11))
  "=" (lambda () (interactive) (pyim-select-word-by-number 12)))

(provide 'cfg-pyim)
;;; cfg-pyim.el ends here.

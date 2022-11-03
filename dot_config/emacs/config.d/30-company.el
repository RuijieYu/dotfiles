;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(company company-quickhelp company-box diminish)))

;;;###autoload
(progn
  (with-eval-after-load 'prog-mode
    (add-hook 'prog-mode-hook #'company-mode))
  (with-eval-after-load 'lsp-mode
    (add-hook 'lsp-mode-hook #'company-mode)))

;;;###autoload
(defun cfg-company-setup ()
  (interactive)
  (company-quickhelp-mode)
  (company-box-mode))

;;;###autoload
(add-hook 'company-mode-hook #'cfg-company-setup)

;;;###autoload
(use-package company
  :defines (company-mode-map
            company-active-mode-map)
  :commands company-mode
  :custom
  (company-backends
   '(company-capf company-bbdb company-semantic company-cmake
                  company-clang company-files
                  (company-dabbrev-code
                   company-gtags
                   company-etags
                   company-keywords)
                  company-oddmuse company-dabbrev))
  (company-dabbrev-code-ignore-case t)
  (company-dabbrev-ignore-case t)
  (company-etags-ignore-case t)
  (company-idle-delay 9999)
  (company-keywords-ignore-case t)
  (company-lighter-base "C")
  (company-require-match nil)
  (company-show-quick-access t))

;;;###autoload
(use-package company-quickhelp
  :custom
  ;; manual trigger using f1 OR C-h OR M-h
  (company-quickhelp-delay nil)
  :defines company-active-map
  :commands (company-quickhelp-manual-begin
             company-quickhelp-mode))

;; alternative visuals for company
;;;###autoload
(use-package company-box
  :after diminish
  :diminish
  :commands company-box-mode)

;;* define keymaps
;;;###autoload
(with-eval-after-load 'company
  (define-keymap :keymap company-mode-map
    "M-<tab>" #'company-complete)

  (define-remap company-mode-map
    [remap indent-for-tab-command]
    #'company-indent-or-complete-common
    [remap complete-symbol] #'company-complete)

  (define-keymap :keymap company-active-map
    "C-h" #'company-quickhelp-manual-begin
    "M-h" #'company-quickhelp-manual-begin
    "<f1>" #'company-quickhelp-manual-begin))

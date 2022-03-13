;;; config.el  -*- lexical-binding: t; no-byte-compile: t; -*-

;;; For my sanity, all keybinds in my configs are setup using
;;; vectors.  I have tried various different formats (like kbd +
;;; string, raw string, ...), but when I put in more complex ones,
;;; they become less intuitive.  It is possible that the rules for
;;; them are simpler, but these rules has always slipped my mind
;;; when I was able to grasp the syntax for vector keybinds. With
;;; vector keybinds, I only have to remember two rules:
;;;
;;; (1) Simpler keybinds like ctrl + alt + latin-key always follow
;;; [?k], [?\M-\(], [?\C-\M-\s-k] formats.  In this case, the
;;; "base key" must be represented by a single character, unless
;;; escaped by backslash, and an arbitrary amount of (unique)
;;; modifier keys are inserted between the `?' and the base key in
;;; the form of `\X-', where X is replaced by one of the following
;;; characters: C=Ctrl, M=Meta(alt), S=Shift, s=super(icon key,
;;; "windows" key), m=??, h=hyper(??).
;;;
;;; (2) More complex keybinds where the base key cannot be
;;; represented by a single character and thus first rule doesn't
;;; apply, a name in vector like [C-f5] should suffice.  In this
;;; case it might be necessary to look around for the name of this
;;; key, but that is true for all keybind schemes and is nothing
;;; particular in vector keybinds.
(defsubst cfg-load (fname)
  "Load a file FNAME from `user-emacs-directory' if it exists."
  (load (expand-file-name fname user-emacs-directory) :noerror))

;; general utility
(cfg-load "pkg.el")
(cfg-load "general.el")
(cfg-load "visual.el")
(cfg-load "exit.el")
(cfg-load "spell.el")
(cfg-load "lsp.el")
(cfg-load "chezmoi.el")

;; dev environments
(cfg-load "racket.el")
(cfg-load "java.el")
(cfg-load "local.el")
(cfg-load "cpp.el")

;; make sure buffer "*Compile-Log*" does not show up after startup
(unless :disabled
  (add-hook 'emacs-startup-hook
            (lambda () (quit-window
                        nil   ; don't kill buffer
                        (get-buffer-window "*Compile-Log*"))))
  )

;; make sure yes-or-no-p -> y-or-n-p for laziness
(defalias #'yes-or-no-p #'y-or-n-p)

;; disable C-z for accidental freezing my frames (sway cannot
;; "minimize" windows; MAYBE... maybe I can hook that into sway/i3
;; scratchpad?)
(global-unset-key [?\C-z])
(global-set-key [remap suspend-frame] nil)

;; always display the vertical bar at fill column
(global-display-fill-column-indicator-mode)

;; remote backup
(customize-set-variable
 'tramp-backup-directory-alist backup-directory-alist)

;; - diminish, hide minor modes selectively from modeline
(use-package diminish
  :demand t
  )

;; don't want to see abbrev mode
(use-package abbrev
  :straight nil
  ;; even if it was enabled, hide it
  :diminish
  ;; disable it
  :hook
  (fundamental-mode . (lambda () (abbrev-mode 0)))
  )

;; hydra
(use-package hydra
  :demand t
  )

;; recentf
(use-package recentf
  :demand t
  :straight nil
  :init
  (recentf-mode)
  :bind
  (([C-tab ?f] . recentf-open-files)
   )
  )

;; save places
(use-package saveplace
  :demand t
  :straight nil
  :init
  (save-place-mode)
  )

;; company - completion
(use-package company
  :hook (prog-mode . company-mode)
  :bind
  (:map company-mode-map
   ([M-tab] . company-complete)
    )
  )

(use-package company-quickhelp
  :hook (company-mode . company-quickhelp-mode)
  :custom
  ((company-quickhelp-delay nil)        ; manual trigger using f1 OR C-h OR M-h
   )
  :bind
  (:map company-active-map
   ([?\C-h] . company-quickhelp-manual-begin)
   ([?\M-h] . company-quickhelp-manual-begin)
   ([f1] . company-quickhelp-manual-begin)
   )
  )

;; code folding, with additional custom keybinds
(use-package hideshow
  :straight nil
  :commands hs-minor-mode
  :hook
  (prog-mode . hs-minor-mode)
  :bind
  (;; all bindings are inside hs-minor-mode-map; ctrl's are
   ;; stripped off from bindings
   :map
   hs-minor-mode-map
   ([C-tab ?\C-h] . [?\C-c ?@])         ; use the original keymap
                                        ; plagued with ctrl's,
                                        ; TODO doesn't work
   ([C-tab ?h ?a] . hs-show-all)
   ([C-tab ?h ?c] . hs-toggle-hiding)
   ([C-tab ?h ?d] . hs-hide-block)
   ([C-tab ?h ?e] . hs-toggle-hiding)
   ([C-tab ?h ?h] . hs-hide-block)
   ([C-tab ?h ?l] . hs-hide-level)
   ([C-tab ?h ?s] . hs-show-block)
   ([C-tab ?h ?t] . hs-hide-all)
   ([C-tab ?h ?\M-h] . hs-hide-all)
   ([C-tab ?h ?\M-s] . hs-show-all)
   )
  )

;; graphviz-dot
(use-package graphviz-dot-mode
  :mode ("\\.dot\\'" . graphviz-dot-mode)
  )

;; gopher
(use-package elpher
  :disabled                             ; don't have a use for it
  :commands elpher
  )

;; dired
(use-package dired
  :straight nil
  :commands dired
  :after rx
  :hook (dired-mode . dired-omit-mode)
  :bind
  (
   ;; "Y" is also specified in dired-x, but unfortunately is not
   ;; available until having loaded the package
   :map dired-mode-map
   ([?Y] . dired-do-relsymlink)
   )
  :custom
  ((dired-listing-switches
    (string-join '("--all"
		   "--human-readable"
		   ;; omit user and group information
		   "-o" "-g"
		   "--group-directories-first"
		   ) " "))
   (delete-by-moving-to-trash t)
   (dired-ls-F-marks-symlinks t)
   (dired-omit-files
    (rx (or (seq string-start ".." string-end)
	    (seq string-start ".#")
	    )))
   (dired-omit-verbose nil)
   )
  )

;; - dired with icons
(use-package all-the-icons-dired
  :after (all-the-icons
	  dired
	  )
  :hook
  (dired-mode . (lambda() (when (display-graphic-p)
			    (all-the-icons-dired-mode))))
  )

;; pdf viewer
(use-package pdf-tools
  :disabled
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :commands pdf-view-mode
  :hook
  (pdf-view-mode . auto-revert-mode)
  :config
  (pdf-tools-install :no-query
		     nil		; disable dependencies
		     )
  )

(use-package openwith
  :init (openwith-mode)            ; enable openwith-mode globally
  )

;; ligature
(use-package ligature
  ;; ligature has issues in emacs <28
  :if (version<= "28" emacs-version)
  :demand t
  :straight (ligature :host github
                      :repo "mickeynp/ligature.el"
                      )
  :config
  ;; Enable the "www" ligature in every possible major mode
  ;; (ligature-set-ligatures 't '("www"))
  
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures
   'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures
   'prog-mode
   ;; short lines because ligature makes them *very long*
   '(
     ;; four-char sequences, 4~5 per row
     "|||>" "<|||" "<==>" "<!--" "####"
     ;; three-char sequences, 5 per row
     "~~>" "***" "||=" "||>" ":::"
     "::=" "=:=" "===" "==>" "=!="
     "=>>" "=<<" "=/=" "!==" "!!."
     ">=>" ">>=" ">>>" ">>-" ">->"
     "->>" "-->" "---" "-<<" "<~~"
     "<~>" "<*>" "<||" "<|>" "<$>"
     "<==" "<=>" "<=<" "<->" "<--"
     "<-<" "<<=" "<<-" "<<<" "<+>"
     "</>" "###" "#_(" "..<" "..."
     "+++" "/==" "///" "_|_" "www"
     "://" ";;;" "/**" "**/"
     ;; two-char sequences, 6 per row
     "&&" "^=" "~~" "~@" "~=" "~>"
     "~-" "**" "*>" "*/" "||" "|}"
     "|]" "|=" "|>" "|-" "{|" "[|"
     "]#" "::" ":=" ":>" ":<" "$>"
     "==" "=>" "!=" "!!" ">:" ">="
     ">>" ">-" "-~" "-|" "->" "--"
     "-<" "<~" "<*" "<|" "<:" "<$"
     "<=" "<>" "<-" "<<" "<+" "</"
     "#{" "#[" "#:" "#=" "#!" "##"
     "#(" "#?" "#_" "%%" ".=" ".-"
     ".." ".?" "+>" "++" "?:" "?="
     "?." "??" ";;" "/*" "/=" "/>"
     "//" "__" "~~" "(*" "*)" "\\\\"
     ))
  ;; Enables ligature checks globally in all buffers. You can also
  ;; do it per mode with `ligature-mode'.
  (global-ligature-mode t))

;; python
(use-package python
  :straight nil
  :commands python-mode
  )

;; - jupyter python
(use-package jupyter
  :if (executable-find "jupyter")
  :after (org python)
  :custom
  (org-babel-default-header-args:jupyter-python
   '((:async . "yes")
     (:kernel . "python3")
     (:eval . "never-export")
     (:exports . "both")
     ))
  :config
  (dolist (lang '((python . t)
		  (jupyter . t)
		  ))
    (add-to-list 'org-babel-load-languages lang))
  (org-babel-do-load-languages
   'org-babel-load-languages
   org-babel-load-languages)
  )

;; - python formatting
(use-package yapfify
  :diminish yapf-mode
  :after python
  :hook
  (python-mode . yapf-mode)
  :bind
  (; only within python
   :map python-mode-map
   ([C-tab ?f ?f] . yapfify-region-or-buffer)
   ([C-tab ?f ?b] . yapfify-buffer)
   ([C-tab ?f ?r] . yapfify-region)
   )
  )

;; orgmode TODO: take inspiration from
;; https://github.com/ymherklotz/dotfiles/blob/master/emacs/loader.org
(use-package org
  :preface
  (defvar cfg--org-map
    (make-sparse-keymap)
    "Keymap for custom org mode."
    )
  (global-set-key [C-tab ?o] `("[ORG]" . ,cfg--org-map))
  
  :commands (org-mode
	     org-agenda-list
	     )
  
  :bind
  (([?\C-c ?l] . org-agenda-list)
   :map org-mode-map
   ([C-tab ?l] . org-agenda-list)
   :map cfg--org-map
   ([?l] . org-agenda-list)
   )
  
  :diminish ((ispell-minor-mode . "I")
	     (auto-fill-mode . "AF")
	     (org-indent-mode . "O[i]")
	     (org-num-mode . "O[n]")
	     )
  
  :hook
  (org-mode . ispell-minor-mode)
  (org-mode . org-indent-mode)
  (org-mode . org-num-mode)

  :custom
  (org-src-preserve-indentation t)
  (org-ellipsis " ▾")
  (org-hide-emphasis-markers t)
  (org-src-fontify-natively t)
  (org-fontify-quote-and-verse-blocks t)
  (org-src-tab-acts-natively t)
  (org-hide-block-startup nil)
  (org-startup-folded 'content)
  (org-cycle-separator-lines 2)
  
  :config
  (font-lock-add-keywords
   'org-mode
   (font-lock-add-keywords
    'org-mode
    `(("^ +\\([-*]\\) "
       ;; ,(rx
       ;;   line-start
       ;;   (or (seq (zero-or-more ? ) ?i)
       ;;       (seq (one-or-more ? ) ?*)
       ;;       )
       ;;   ? )
       (0
	(prog1 ()
	  (compose-region
	   (match-beginning 1)
	   (match-end 1)
	   "•")))
       )))
   )
  )

;; - org with id?
(use-package org-id
  :straight nil
  :after org
  )

;; - orgmode export to markdown
(use-package ox-md
  :demand t
  :straight nil
  :after org
  )

;; - orgmode auto-show latex snippet
(use-package org-fragtog
  :disabled                          ; looks weird on sway/wayland
  :diminish
  :after org
  :hook
  (org-mode . org-fragtog-mode)
  )

;; - orgmode auto-show markup symbols
(use-package org-appear
  :diminish
  :after org
  :hook
  (org-mode . org-appear-mode)
  )

;; - dispatch src block templates
(use-package org-tempo
  :straight nil
  :after org
  :init
  (dolist (pair '(("sh" . "sh")
		  ("el" . "emacs-lisp")
		  ("py" . "python")
		  ("md" . "markdown")
		  ))
    (add-to-list 'org-structure-template-alist
		 `(,(car pair) .
		   ,(concat "src " (cdr pair)))))
  )

;; calc
(use-package calc-frac
  :straight nil
  :after calc
  :custom
  (calc-frac-format '("/" nil))
  )

(use-package calc
  :straight nil
  :commands calc
  :custom
  (calc-prefer-frac t)
  (calc-display-working-message t)
  )

;; cpp

;; - clang-format
(defcustom cfg-path--clang-format
  (expand-file-name "clang-format/" user-emacs-directory)
  "The path to the *.el files for clang-format"
  :type 'directory
  :group 'custom
  )

;; TODO: maybe refactor such that all formatter keybinds are
;; combined into a single kepmap
(defvar cfg-map--clang-format-submap
  (let ((map (make-sparse-keymap)))
    map
    )
  "My clang-format keymap under prefix")

(defcustom cfg-map--clang-format-prefix
  [?\C-c ?f]
  "My clang-format keymap prefix"
  :type 'key-sequence
  :group 'custom
  :group 'custom-map
  ;; :set (lambda (arg0 key-seq)
  ;;        ;; (message "ARG0=%s ; KEY-SEQ=%s" arg0 key-seq)
  ;;        (define-key global-map
  ;;          key-seq
  ;;          cfg-map--clang-format-submap))
  )

(use-package clang-format
  :straight nil                       ; provided by arch "clang"
  :if (file-exists-p cfg-path--clang-format)
  :load-path cfg-path--clang-format
  :commands (clang-format
             clang-format-buffer
             clang-format-region)
  :bind
  (([?\C-c ?f ?f] . #'clang-format)
   ([?\C-c ?f ?b] . #'clang-format-buffer)
   ([?\C-c ?f ?r] . #'clang-format-region)
   :map cfg-map--clang-format-submap
   ([?b] . #'clang-format-buffer)
   ([?f] . #'clang-format)
   ([?r] . #'clang-format-region)
   )
  )

;; text mode
(use-package text-mode
  :straight nil
  :hook
  (text-mode . visual-line-mode)
  )

;; unfill text
(use-package unfill
  ;; :requires simple
  :bind
  (([?\C-c ?q] . unfill-paragraph)
   :map visual-line-mode-map
   ([?\C-\M-q] . unfill-paragraph)
   )
  )

;; terminal modes

;; - term
(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode)
  )

(use-package term
  :straight nil
  :commands (term
	     new-term)
  :custom
  (explicit-shell-file-name (or (getenv "SHELL")
				"zsh"))
  (explicit-zsh-args nil)
  :config
  (defun cfg-term--buffer-usable (buffer-or-name)
    ;; a buffer is usable if any of these are true:
    ;; 1. it does not exist;
    ;; 2. it exists but the terminal is "dead"
    ;;
    ;; return the buffer if it is usable, otherwise nil
    (let ((buffer (get-buffer-create buffer-or-name)))
      (if (not (term-check-proc buffer))
          buffer))
    )

  (defun cfg-term--next (name &optional index)
    "Get the first usable terminal buffer.
Check whether the buffer \"*NAME*<INDEX>\" is usable as a
terminal. Iterate index until the first usable buffer and return
this usable buffer."
    (let* ((index (or index 0))
	   (buffer-name
	    (concat "*" name "*<"
		    (number-to-string index)
		    ">"))
           (buffer-or-nil
	    (cfg-term--buffer-usable buffer-name)))
      (or buffer-or-nil
          (cfg-term--next name (+ index 1))))
    )

  (defun cfg-term--make (name
			 program
			 &optional startfile
			 &rest switches)
    "Make a term process NAME in a buffer, running PROGRAM.
The name of the buffer is verbatim to the argument NAME.
Optional third arg STARTFILE is the name of a file to send the
contents of to the process.  Any more args (SWITCHES) are
arguments to PROGRAM."
    (let ((buffer (cfg-term--next name)))
      ;; If no process, or nuked process, crank up a new one and put
      ;; buffer in term mode.  Otherwise, leave buffer and existing
      ;; process alone.
      (cond ((not (term-check-proc buffer))
	     (with-current-buffer buffer
	       (term-mode)) ; Install local vars, mode, keymap, ...
	     (term-exec buffer name program startfile switches)))
      buffer)
    )

  ;; create a new terminal
  (defun new-term (program)
    "Start a terminal-emulator with PROGRAM in a new, indexed buffer.
The buffer is in Term mode; see `term-mode' for the commands to
use in that buffer.  Also see `term' and `make-term'."
    
    (interactive
     (list
      (read-from-minibuffer
       "Run program: "
       (or explicit-shell-file-name
	   (getenv "ESHELL")
	   shell-file-name))))

    (let ((buffer (cfg-term--make "terminal" program)))
      (set-buffer buffer)
      (term-mode)
      (term-char-mode)
      (switch-to-buffer buffer))
    )
  )

;; - vterm
(use-package vterm
  :if (executable-find "cmake")
  :commands vterm
  :custom
  (vterm-shell (or (getenv "SHELL")
		   "zsh"))
  (vterm-max-scrollback 10000)
  )

;; - eshell
(use-package esh-opt
  :straight nil
  :custom
  (eshell-destroy-buffer-when-process-dies t)
  (eshell-visual-commands
   '("htop" "btop"
     "bash" "zsh" "fish"
     "vim" "less" "more" "man"))
  )

(use-package esh-mode
  :straight nil
  )

(use-package eshell
  :straight nil
  :after (esh-mode
	  esh-opt)
  :commands eshell
  :hook
  (eshell-pre-command . eshell-save-some-history)
  (eshell-first-time-mode
   . (lambda ()
       (push #'eshell-truncate-buffer
	     eshell-output-filter-functions)))
  (eshell-mode
   . (lambda ()
       (display-line-numbers-mode -1)))
  
  :bind
  ;;; ref: https://stackoverflow.com/a/3645477
  ;; idea: C-z goes to a shell in tty; also let C-z go back to
  ;; previous buffer when already in eshell
  (([remap suspend-frame] . eshell)
   :map eshell-mode-map
   ([?\C-z] . bury-buffer)
   )
  ;; :bind
  ;; (([C-tab ?\r] . eshell)
  ;;  ([C-tab C-return] . eshell)
  ;;  )
  :preface
  (global-set-key [C-tab ?\r] #'eshell)
  (global-set-key [C-tab C-return] #'eshell)
  ;; :init
  ;; (cfg-keybind--leader
  ;;   "<RET>" . '(eshell
  ;;               :which-key "eshell")
  ;;   )
  :custom
  (eshell-history-size 10000)
  (eshell-buffer-maximum-lines 10000)
  (eshell-hist-ignoredups t)
  (eshell-scroll-to-bottom-on-input t)
  :config
  (use-package eshell-git-prompt
    :demand t
    :config
    (eshell-git-prompt-use-theme 'powerline)
    )
  )

(use-package eshell-syntax-highlighting
  :after esh-mode
  :hook
  (eshell-mode . eshell-syntax-highlighting-mode)
  )

;; - shell in org babel
(with-eval-after-load 'org
  (dolist (lang '((shell . t)
		  ))
    (add-to-list 'org-babel-load-languages lang))
  (org-babel-do-load-languages
   'org-babel-load-languages
   org-babel-load-languages)
  )

;; elisp
(use-package elisp-mode
  ;; TODO
  :straight nil
  :commands (eval-last-sexp
             eval-defun
	     elisp-mode)
  :bind
  (([?\C-c ?\C-c] . #'eval-buffer)
   )
  )

;; utilities

;; - which-key
(use-package which-key
  :demand t
  :after diminish
  :diminish; which-key-mode
  :custom
  (which-key-idle-delay 1)
  :config
  (which-key-mode)
  )

;; - helpful
(use-package helpful
  :after counsel
  :bind
  (([remap describe-function] . #'counsel-describe-function)
   ([remap describe-variable] . #'counsel-describe-variable)
   )
  )

(use-package counsel
  :commands (counsel-describe-function
             counsel-describe-variable
             )
  :bind
  (([remap describe-command] . #'helpful-command)
   ([remap describe-key] . #'helpful-key)
   )
  )

;; - swiper
(use-package swiper
  :commands swiper
  :bind
  (([remap isearch-forward] . #'swiper)
   ;; ([remap isearch-backward] . swiper-backward)
   ;; ([remap isearch-backward] . #'swiper-backward)
   )
  )

;; - completion
(use-package vertico
  :demand t
  :custom
  (vertico-cycle t) ; <up> for last entry
  :config
  (vertico-mode)
  )

(use-package marginalia
  :demand t
  :bind
  (; no global map
   :map minibuffer-local-map
   ([?\M-a] . marginalia-cycle)
   )
  :config
  (marginalia-mode)
  )

;; - window selection
(use-package ace-window
  :custom
  (aw-scope 'frame)
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-minibuffer-flag t)
  :bind
  (([?\M-o] . ace-window)
   )
  :config
  (ace-window-display-mode)
  )

;; - region selection
(use-package expand-region
  :bind
  (([?\M-\[] . #'er/expand-region)
   ([?\M-\]] . #'er/contract-region)
   ;; the following may not work in tty
   ([?\C-\(] . #'er/mark-outside-pairs)
   ([?\C-\)] . #'er/mark-inside-pairs)
   )
  )

;; - magit
(use-package magit
  ;; TODO add autoloads
  ;; :demand t
  )

;; - snippets
(use-package yasnippet
  :after diminish
  :demand t
  :diminish yas-minor-mode
  :hook
  (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all)
  )

;; - rainbow delimiters
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode)
  )

;; - ediff
(use-package ediff
  :straight nil
  :commands (ediff
	     ediff-files
	     )
  :custom
  (ediff-diff-options "-w")
  (ediff-split-window-function #'split-window-horizontally)
  (ediff-window-setup-functions #'ediff-setup-windows-plain)
  )

;; - mouse?
(use-package disable-mouse
  :disabled
  :config
  (global-disable-mouse-mode)
  )

;; - input method
(use-package pyim
  :bind
  (([?\M-j] . pyim-convert-string-at-point)
   :map pyim-mode-map
   ([?.] . #'pyim-page-next-page)
   ([?,] . #'pyim-page-previous-page)
   ;; rebind - and = to select 11th and 12th candidate
   ([?-] . (lambda nil (interactive)
            (pyim-select-word-by-number 11)))
   ([?=] . (lambda nil (interactive)
            (pyim-select-word-by-number 12)))
   ;; TODO, check if this works as expected
   ([?\M-f] . #'pyim-forward-word)
   ([?\M-b] . #'pyim-backward-word)
   )
  :custom
  (pyim-english-input-switch-functions
   #'(pyim-probe-dynamic-english        ; use M-j to convert
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
  )

(use-package pyim-basedict
  :after pyim
  :config
  (pyim-basedict-enable)
  )

;; linting

;; - flycheck

;; TODO

;; security and authentication

;; TODO

;; text scaling
;; (defvar cfg--text-scale 'placeholder-for-debugger)
(with-eval-after-load 'hydra
  (defhydra cfg--text-scale (:timeout 5)
    "text scaling"
    ("j" text-scale-increase "enlarge")
    ("k" text-scale-decrease "shrink")
    ("<RET>" nil "finish" :exit t)
    ("f" nil "finish" :exit t)
    ("q" nil "finish" :exit t)
    )

  (global-set-key
   [C-tab ?s] #'cfg--text-scale/body))

;; (with-eval-after-load 'general
;;   (cfg-keybind--leader
;;     "s" '(cfg--text-scale/body
;;           :which-key "text-scaling")
;;     ))

;;; need to figure out what this actually does
;; (use-package default-text-scale
;;   :config
;;   (default-text-scale-mode)
;;   )

;; automatic file reload
(use-package autorevert
  :straight nil
  :demand t
  :custom
  (global-auto-revert-non-file-buffers nil)
  :config
  (global-auto-revert-mode)
  )

;; tramp
(customize-set-variable
 'tramp-default-method "sshx"
 )

;; inferior editing
(with-eval-after-load 'server
  (when server-process
    (setenv "EDITOR" "emacsclient")
    (setenv "VISUAL" "emacsclient")
    ))

;; llvm
(defcustom cfg-path--llvm-mode
  (expand-file-name "llvm-mode/" user-emacs-directory)
  "Path to LLVM-mode files."
  :type 'directory
  :group 'custom
  )

(use-package llvm-mode
  :straight nil
  :load-path cfg-path--llvm-mode
  :if (file-exists-p cfg-path--llvm-mode)
  :mode ("\\.ll\\'" . llvm-mode)
  )

;; registers
(let ((reg-file (expand-file-name "registers.el" user-emacs-directory))
      )
  (when (file-exists-p reg-file)
    (load fname nil nil :nosuffix)))

;; Local Variables:
;; fill-column: 66
;; End:

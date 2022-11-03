;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(ligature)))

;;;###autoload
(defvar cfg-ligature-enabled-ligatures
  '("|||>" "<|||" "<==>" "<!--" "####"
    "~~>" "***" "||=" "||>" ":::"
    "::=" "=:=" "===" "==>" "=!="
    "=>>" "=<<" "=/=" "!==" ">=>"
    ">>=" ">>>" ">>-" ">->" "->>"
    "-->" "---" "-<<" "<~~" "<~>"
    "<*>" "<||" "<|>" "<$>" "<=="
    "<=>" "<=<" "<->" "<--" "<-<"
    "<<=" "<<-" "<<<" "<+>" "</>"
    "###" "#_(" "..<" "..." "+++"
    "/==" "///" "_|_" ";;;" "/**"
    ;; "www" "://" "**/" "!!."
    "&&" "^=" "~~" "~@" "~>"
    "~-" "**" "*>" "*/" "||" "|}"
    "|]" "|=" "|>" "|-" "{|" "[|"
    "]#" ;; "::"
    ":=" ":>" ":<" "$>"
    "==" "=>" "!=" "!!" ">:" ">="
    ">>" ">-" "-~" "-|" "->" "--"
    "-<" "<~" "<*" "<|" "<:" "<$"
    "<=" "<>" "<-" "<<" "<+" "</"
    ;; "#{"
    ;; "#["
    "#:" "#=" "#!" "##"
    "#(" "#?" "#_" "%%" ".=" ".-"
    ".." ".?" "+>" "++" "?:" "?="
    "?." "??" ";;" "/*" "/=" "/>"
    "//" "__" "~~"
    ;; "(*" "*)"
    ;; "\\\\" "~="
    )
  "Shared ligatures amongst `prog-mode' buffers.")

;;;###autoload
(use-package ligature
  ;; ligature has issues in emacs <28
  :if (version<= "28" emacs-version)
  :hook
  (after-init . global-ligature-mode)
  :config
  ;; clear up ligature table
  (defvar ligature-composition-table)
  (setq ligature-composition-table nil)

  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures
   #'eww-mode '("ff" "fi" "ffi"))
  ;; rust ligatures
  (ligature-set-ligatures
   #'rust-mode '("&&" "||" "///" "//" "//!" "/*" "/**" "*/"
                 ;; "::" ; too short
                 ))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures
   'prog-mode cfg-ligature-enabled-ligatures))

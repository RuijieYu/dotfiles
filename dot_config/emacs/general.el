;; -*- lexical-binding: t; no-byte-compile: t; -*-

;; general.el
(use-package general
  :commands (general-create-definer
	     ;; cfg-keybind--leader
	     cfg-keybind--C-c)
  :config
  ;; (general-create-definer
  ;;  cfg-keybind--leader
  ;;  :prefix "<C-tab>"
  ;;  ;; :prefix [C-tab]
  ;;  )
  (general-create-definer
   cfg-keybind--C-c
   :prefix [?\C-c]
   )
  )

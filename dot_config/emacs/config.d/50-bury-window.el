;;; bury-window.el -*- no-byte-compile: nil; -*-
;; set a keybind for burying the window
;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-z" #'bury-buffer)

;; -*- no-byte-compile: nil; -*-
;;;###autoload
(defvar-keymap cfg-comment-map
  :doc "Keymap for various comment-manipulating commands.")

;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-c k" #'kill-comment
  "C-c ;" cfg-comment-map
  "C-<tab> ;" cfg-comment-map)

;; for C-like languages, both /* */ and // are valid
;;;###autoload
(defun cfg-comment-switch-style-c-like ()
  "Switch comment styles for a C-like language.  That is, switch
comments between // and /* */, and between /// and /** */,
respectively.  No-op if current position is not at a line ending
with a comment, or inside a comment block."
  (interactive)
  'todo)

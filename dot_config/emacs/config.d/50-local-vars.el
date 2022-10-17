;;; local-vars.el -*- no-byte-compile: nil; -*-

;;* Declare keymaps
;;;###autoload
(defvar-keymap cfg-local-vars-map
  :doc "Keymap for local variable manipulations.")
;;;###autoload
(defvar-keymap cfg-local-vars-add-map
  :doc "Keymap for local variable additions.")
;;;###autoload
(defvar-keymap cfg-local-vars-copy-map
  :doc "Keymap for local variable duplications.")
;;;###autoload
(defvar-keymap cfg-local-var-mod-map
  :doc "Keymap for local variable modifications.")
;;;###autoload
(defvar-keymap cfg-local-var-del-map
  :doc "Keymap for local variable deletions.")

;;* Redirect to each other
;;;###autoload
(dolist (map (list cfg-local-vars-map
                   cfg-local-vars-add-map
                   cfg-local-vars-copy-map
                   cfg-local-var-mod-map
                   cfg-local-var-del-map))
  (define-keymap :keymap map
    "a" cfg-local-vars-add-map
    "c" cfg-local-vars-copy-map
    "m" cfg-local-var-mod-map
    "D" cfg-local-var-del-map))

;;* Add new variables
;;;###autoload
(define-keymap :keymap cfg-local-vars-add-map
  "p" #'add-file-local-variable-prop-line
  "l" #'add-file-local-variable
  "d" #'add-dir-local-variable)

;;* Copy variables around
;;;###autoload
(define-keymap :keymap cfg-local-vars-copy-map
  "p" #'copy-dir-locals-to-file-locals-prop-line
  "l" #'copy-dir-locals-to-file-locals
  "d" #'copy-file-locals-to-dir-locals)

;;* Modify variables
;;;###autoload
(define-keymap :keymap cfg-local-var-mod-map
  "p" #'modify-file-local-variable-prop-line
  "l" #'modify-file-local-variable
  "d" #'modify-dir-local-variable)

;;* Delete variables
;;;###autoload
(define-keymap :keymap cfg-local-var-del-map
  "p" #'delete-file-local-variable-prop-line
  "l" #'delete-file-local-variable
  "d" #'delete-dir-local-variable)

;;* Put everything together
;;;###autoload
(define-keymap :keymap (current-global-map)
  "C-<tab> v" cfg-local-vars-map)

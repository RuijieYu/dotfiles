;;;###autoload
(require 'cfg-util-backports "../utils/backports")

;;;###autoload
(defun define-remap (keymap &rest definitions)
  "Define remaps.  Each KEY and DEF should be acceptable by
 `define-key'.

\(fn KEYMAP &rest [KEY DEFINITION]...)"
  (declare (indent 1))
  ;; ref: `define-keymap'
  (unless (keymapp keymap)
    (error "Need a keymap"))
  (let (seen-keys)
    (while definitions
      (let* ((key (pop definitions))
             (def (if definitions (pop definitions)
                    (error
                     "Uneven number of key/definition pairs"))))
        (when (member key seen-keys)
          (error "Duplicate definition for key: %S %s"
                 key keymap))
        (define-key keymap key def)))))

;;;###autoload
(progn (cfg-backport-version "29.0.60")
       (require 'keymap "keymap"))

;;; cfg-keymap.el --- Keymap functionalities

;;; Commentary:

;;; Code:
(eval-when-compile (require 'cl-macs))


(defun cfg-keymap-remap (&rest args)
  "Define a keymap remap, similar to `define-keymap'.
ARGS should be first keywords, then pairs of FROM TO, where FROM
is a command symbol to be remapped, and TO is a target acceptable
by `define-key'\'s DEF.

Keywords:
:keymap - the keymap to be defined.  If not specified, create one."
  (declare (indent 2))
  (let (keywords remapped)
    (while (and args (keywordp (car args)))
      (let ((kw (or (pop args) (error "Keyword cannot be nil")))
            (val (pop args)))
        (if (assoc kw keywords)
            (error "Repeated keyword: `%s'" kw)
          (push (cons kw val) keywords))))
    (let ((keymap (or (cdr (assoc :keymap keywords))
                      (make-sparse-keymap))))
      (while args
        (let ((from (pop args))
              (to (pop args)))
          (cond
           ((not (and (symbolp from) (commandp from)))
            (error "`%s' not a command" from))
           ((seq-find from remapped)
            (error "`%s' already remapped" from))
           (t (push from remapped)
              (define-key keymap `[remap ,from] to)))))
      keymap)))

(defun cfg-keymap-lookup (keymap key)
  "Look up a KEY from KEYMAP."
  (and (keymapp keymap)
       (characterp key)
       (keymap-lookup keymap (key-description key) t)))

(define-obsolete-function-alias 'cfg-keymap-lookup-vector 'cfg-keymap-lookup nil)
;; (defun cfg-keymap-lookup-vector (keymap key)
;;   "Look up a vector KEY from KEYMAP."
;;   (and (keymapp keymap) key
;;        (cond ((key-valid-p key) (keymap-lookup keymap key))
;;              ((or (stringp key) (vector-or-char-table-p key))
;;               (let ((max (length key)))
;;                 (cl-do ((idx 0 (1+ idx))
;;                         (map keymap
;;                              (cfg-keymap-lookup
;;                               map (aref key idx))))
;;                     ((or (not map) (>= idx max)) map)))))))

(provide 'cfg-keymap)
;;; cfg-keymap.el ends here.

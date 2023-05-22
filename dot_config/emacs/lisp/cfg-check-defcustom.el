;;; cfg-check-defcustom.el --- Ensure type-strictness of defcustom

;;; Commentary:

;;; Code:
(autoload 'customize-read-group "cus-edit")
(autoload 'custom-variable-prompt "cus-edit")

(defun ccd (variable)
  "Check the standard value of VARIABLE is of the correct type."
  (interactive (custom-variable-prompt))
  (custom-load-symbol variable)
  (when-let ((type (get variable 'custom-type)))
    (let* ((value (custom--standard-value variable))
           (widget (widget-convert type)))
      (cond
       ((null (widget-get widget :match))
        (warn "Invalid type `%S'" type))
       ((null (widget-apply widget :match value))
        (warn "Type mismatch on `%s': value `%S'; type %s"
              variable value type))))))

(defun ccd--vars-in-group (group &optional recursive)
  "Return a list of all variable symbols contained in GROUP.
When RECURSIVE is non-nil, the list contains variables in
subgroups recursively."
  (when-let (((symbolp group))
             (gp (get group 'custom-group)))
    (let* ((filter
            (lambda (s)
              (mapcar
               #'car (seq-filter (lambda (c) (eq s (nth 1 c))) gp))))
           (child (funcall filter 'custom-variable))
           (subgroup (and recursive
                          (funcall filter 'custom-group))))
      (nconc child (mapcan #'ccd--vars-in-group-r subgroup)))))

(defun ccd--vars-in-group-r (group)
  "Shorthand for \\(cfg-check-defcustom--vars-in-group GROUP t)."
  (ccd--vars-in-group group t))

(defun ccd-group (group &optional recursive)
  "Check all variables within GROUP.
When RECURSIVE is non-nil, check the group recursively.  See also
`cfg-check-defcustom'."
  (interactive (list (customize-read-group) current-prefix-arg))
  (mapc #'ccd (ccd--vars-in-group (intern group) recursive)))

(provide 'cfg-check-defcustom)
;;; cfg-check-defcustom.el ends here.

;; Local Variables:
;; read-symbol-shorthands: (("ccd" . "cfg-check-defcustom"))
;; End:

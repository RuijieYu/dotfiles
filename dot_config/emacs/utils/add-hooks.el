;;;###autoload
(defun add-all-hooks (func &rest hooks)
  "Add FUNC to all HOOKS.  See `add-hook’."
  (cl-do ((hooks hooks (cdr hooks)))
      ((not hooks))
    (add-hook (car hooks) func)))

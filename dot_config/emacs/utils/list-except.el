;;;###autoload
(defun cfg-list-except (list except-inds &optional safe)
  "Return a list composed from elements of LIST, except the indices
from the list EXCEPT-INDS.  The order of elements in LIST is
preserved.  EXCEPT-INDS is destructively sorted in increasing
order, unless SAFE is non-nil."
  (let ((except-inds (if safe (copy-sequence except-inds)
                       except-inds)))
    (pcase (cfg-list-except--internal list (sort except-inds #'<))
      (`(,list . ,acc) (append acc (reverse list))))))

;;;###autoload
(defun cfg-list-except--internal (list except-inds
                                       &optional curr-ind acc)
  "Helper for `cfg-list-except', which specifies LIST and
EXCEPT-INDS.  Assume EXCEPT-INDS passed into this function is
sorted from small to large.  CURR-IND is current index defaulting
to 0, and ACC is internal accumulated values.  Return a `cons'
cell whose `car' is the unprocessed elements from LIST, and whose
`cdr' is the accumulated result."
  (let ((ind (car-safe except-inds))
        (curr-ind (or curr-ind 0)))
    (cond
     ;; run out of input or no more indices to remove
     ((or (not list) (not except-inds)) `(,list . ,acc))
     ;; index < current, drop this index
     ((< ind curr-ind)
      (cfg-list-except--internal
       list (cdr except-inds) curr-ind acc))
     ;; index = current, drop this value from list
     ((= ind curr-ind) (cfg-list-except--internal
                        (cdr list)        ; element dropped
                        (cdr except-inds) ; index processed
                        (1+ curr-ind)     ; next index
                        acc))
     ;; otherwise (index > current), accumulate and next index
     (t (cfg-list-except--internal
         (cdr list)                     ; element accumulated
         except-inds                    ; index unchanged
         (1+ curr-ind)                  ; next index
         `(,(car list)                  ; accumulate elem
           . ,acc))))))

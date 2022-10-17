;; ref: (elisp)Advice-Combinators
(defun cfg-maybe-n (n &rest vals)
  "Check whether the N-th element of the list VALS is non-nil,
where 0-th element is the `car' of VALS.  When used as
:before-while advice, only run the named function when this value
is non-nil."
  (cond
   ((= n 0) (car vals))
   (t (let ((vals (cdr vals)))
        (cfg--maybe-n (1- n) vals)))))

(defun cfg-maybe-n-f (n)
  "Return a function that behaves like `cfg-maybe-n' with number N
passed-in."
  (pcase n
    (0 #'cfg-maybe)
    (_ (eval `(lambda (&rest vals)
                ,(format "See `cfg-maybe-n', where N is %d." n)
                (apply #'cfg-maybe-n ,n vals))))))

(defun cfg-maybe (val &rest _)
  "Check whether VAL is non-nil.  When used as :before-while
advice, only run the named function when VAL is non-nil."
  val)

;; no-op (return t) when `load-theme' receives nil
;; (advice-add #'load-theme :before-while #'cfg-maybe)

;;;###autoload
(defun cfg-theme-disable-all ()
  "Disable all loaded themes"
  (interactive)
  (dolist (theme custom-enabled-themes)
    (disable-theme theme)))
;; (advice-add #'load-theme :before #'cfg-theme-disable-all)

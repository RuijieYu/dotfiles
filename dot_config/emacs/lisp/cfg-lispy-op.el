;;; cfg-lispy-op.el --- Lispy extension: wrap sexp with operator

;;; Commentary:

;;; Code:
(eval-when-compile (require 'rx))
(require 'cfg-lispy)
(require 'cfg-keymap)


(autoload 'lispy--remember "lispy")
(autoload 'lispy-mark-symbol "lispy")
(autoload 'lispy-mark-list "lispy")
(autoload 'lispy-parens "lispy")
(autoload 'lispy-backward "lispy")
(defvar lispy-mode)
(defvar lispy-mode-map)


(defcustom cfg-lispy-op-allowed-ops
  '(([?=] . "eql") ([?!] . "not")
    ([?&] . "and") ([?|] . "or") ([?^] . "xor")
    ([?+] . "+") ([?-] . "-")
    ([?*] . "*") ([?/] . "/") ([?%] . "mod"))
  "Alist from key to their corresponding operator name."
  :type '(alist :key-type (vector :tag "Key" character)
                :value-type (string :tag "Operator name"))
  :group 'cfg)


(defun cfg-lisp-op-insert (&optional key)
  "Insert an operator name according to KEY.
See `cfg-lispy-op-allowed-ops’ for the list of allowed operators."
  (interactive)
  (lispy--remember)
  (let* ((key (or key (this-single-command-keys)))
         (fname (cdr-safe
                 (assoc key cfg-lispy-op-allowed-ops)))
         (at-atom (lambda (&optional pos)
                    (string-match-p
                     (rx (any alnum "-_+=!@#$%^&*|/?~"))
                     (string (char-after pos)))))
         (act-atom (lambda ()
                     ;; M-m
                     (lispy-mark-symbol)
                     ;; (
                     (lispy-parens nil)
                     ;; now at |(ORIG), move right
                     (forward-char)
                     ;; now at (|ORIG), add the function name and
                     ;; then a space
                     (insert fname ? ))))
    (when fname
      (unless
          (and (string-match-p (rx (+ (any alnum punct))) fname)
               (not (string-match-p
                     (rx (any ",’`()[]{}\"\""))
                     fname)))
        (error "Invalid function name %s" fname)))
    (cond
     ;; |( OR )|
     ((and fname
           (or (eq ?\( (char-after))
               (eq ?\) (char-after (1- (point))))))
      ;; create a new nesting and insert function name
      ;; m
      (lispy-mark-list 1)
      ;; (
      (lispy-parens nil)
      ;; now at (| (orig...)), insert the name
      (insert fname)
      ;; go to the opening paren
      (lispy-backward 1))
     ;; otherwise when at an atom (point is alphanumeric), mark
     ;; current sexp, parenthesize and insert function name
     ((and fname (funcall at-atom (point)))
      (funcall act-atom))
     ;; otherwise when currently at space, and prev is an atom,
     ;; act on this previous atom
     ((and fname (eql ?  (char-after))
           (funcall at-atom (1- (point))))
      (backward-char)
      (funcall act-atom))
     ;; otherwise insert self
     (t (mapc #'insert key)))))


(with-eval-after-load 'lispy
  (dolist (key (mapcar #'car cfg-lispy-op-allowed-ops))
    (let ((old (cfg-keymap-lookup lispy-mode key)))
      (lispy-define-key lispy-mode-map
          (concat key) #'cfg-lisp-op-insert
        :inserter old))))

(provide 'cfg-lispy-op)
;;; cfg-lispy-op.el ends here.

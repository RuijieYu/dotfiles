;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(lispy comment-or-uncomment-sexp)))

;; This might become obsolete as I start using lispy
(use-package comment-or-uncomment-sexp
  :commands comment-or-uncomment-sexp)

;;;###autoload
(defun cfg-lisp-common-setup ()
  "Common setups for all lisp family buffers."
  (interactive)
  (add-to-list 'prettify-symbols-alist '("lambda" . ?λ))
  (prettify-symbols-mode))

;;;###autoload
(add-all-hooks #'cfg-lisp-common-setup
               'lisp-mode-hook
               'lisp-data-mode-hook
               'lisp-interaction-mode-hook
               'emacs-lisp-mode-hook
               'scheme-mode-hook
               'slime-mode-hook)

;;;###autoload
(defconst cfg-lisp-insert-allowed-operators
  '(([?=] . "eql") ([?!] . "not")
    ([?&] . "and") ([?|] . "or") ([?^] . "xor")
    ([?+] . "+") ([?-] . "-")
    ([?*] . "*") ([?/] . "/") ([?%] . "mod"))
  "An alist whose keys are single characters to their corresponding
function names.")

;;;###autoload
(defun cfg-lisp-insert-operators (&optional key)
  "Insert an operator name.
See `cfg-lisp-insert-allowed-operators’ for the list of allowed
operators."
  (interactive)
  (lispy--remember)
  (let* ((key (or key (this-single-command-keys)))
         (fname (cdr-safe
                 (assoc key cfg-lisp-insert-allowed-operators)))
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

;;;###autoload
(defun cfg-keymap-lookup-single (keymap key)
  (and (keymapp keymap) key
       (cl-do ((map (cdr keymap) (cdr map))
               (sub nil
                    (let ((map (car map)))
                      (or (and (keymapp map)
                               (cfg-keymap-lookup-single map key))
                          (and (eql key (car map))
                               (cdr map))))))
           ((or sub (not map)) sub))))

;;;###autoload
(defun cfg-keymap-lookup-vector (keymap key)
  (and (keymapp keymap) key
       (cond ((key-valid-p key) (keymap-lookup keymap key))
             ((or (stringp key) (vector-or-char-table-p key))
              (let ((max (length key)))
                (cl-do ((idx 0 (1+ idx))
                        (map keymap
                             (cfg-keymap-lookup-single
                              map (aref key idx))))
                    ((or (not map) (>= idx max)) map)))))))

;; for simplicity, add the keymap directly at `lispy-mode-map’.
;;;###autoload
(with-eval-after-load 'lispy
  (dolist (key (mapcar #'car cfg-lisp-insert-allowed-operators))
    (let ((old (cfg-keymap-lookup-vector lispy-mode key)))
      (lispy-define-key lispy-mode-map
          (concat key) #'cfg-lisp-insert-operators
        :inserter old)))
  ;; `special-lispy-splice' has been overriden
  (lispy-define-key lispy-mode-map "\\" #'lispy-splice))

;;;###autoload
(defun cfg-lisp-insert-lambda ()
  "Insert the \"lambda\" string."
  (interactive)
  (insert "lambda"))

;;;###autoload
(defun cfg-lisp-insert-raw-lambda ()
  "Insert the greek letter \"λ\" when inside comments or strings;
otherwise insert \"lambda\" string."
  (interactive)
  ;; Insert "lambda" instead of λ when inside strings or comments
  (let ((syn (syntax-ppss)))
    (insert (if (or (nth 3 syn) (nth 4 syn)) "λ"
              "lambda"))))

;;;###autoload
(defun cfg-lisp-bind-lambda (keymap)
  "Bind lambda related keybinds for lisp-family modes."
  (require 'comment-or-uncomment-sexp)
  (define-keymap :keymap keymap
    ;; similar to racket-mode's λ insertion
    "C-M-y" #'cfg-lisp-insert-lambda
    ;; when inserting raw λ, convert to lambda?
    "λ" #'cfg-lisp-insert-raw-lambda
    ;; comment or uncomment sexp (might become obsolete from lispy)
    "C-M-;" #'comment-or-uncomment-sexp))

;;;###autoload
(with-eval-after-load 'lisp-mode
  (cfg-lisp-bind-lambda lisp-mode-map))
(use-package lisp-mode
  :straight nil
  :defines lisp-mode-map)

;; lispy mode
;;;###autoload
(use-package lispy
  :straight
  (lispy :fork
         (:repo "RuijieYu/lispy"
                ;; :branch "clisp-support-named-chars"
                :branch "elisp-customizable-cl-indent-funcs"))
  :after lisp-mode
  :commands lispy-mode
  :custom
  (lispy-no-space t))

;;;###autoload
(progn (add-hook 'lisp-mode-hook #'lispy-mode)
       (add-hook 'lisp-data-mode-hook #'lispy-mode))

;;;###autoload
(put '<- 'common-lisp-indent-function 0)

;;;###autoload
(put 'cl-defun 'common-lisp-indent-function 'defun)

;;;###autoload
(defun cfg-lisp-fill-list (&optional arg limit)
  "Fill children.  If cursor is currently not at a list, an implicit
`lispy-backward' is implied.  When prefixed with a single
`universal-argument', fill recursively."
  (interactive "P")
  (unless (and (boundp 'lispy-mode) lispy-mode)
    (user-error
     "`cfg-lisp-fill-list' requires `lispy-mode'."))
  (when (< fill-column 10)
    (error "Value of `fill-column' too small: %s" fill-column))
  (lispy-save-excursion
    (cond ((lispy-right-p) (lispy-different))
          ((not (lispy-left-p)) (lispy-backward)))
    (with-buffer-unmodified-if-unchanged
      (let ((recursive arg))
        (cfg-lisp--fill-list :limit limit
                             :recursive recursive)))))

(defun cfg-lisp--col-of (&optional point)
  (let ((point (or point (point))))
    (save-excursion (goto-char point) (current-column))))

(defun cfg-lisp--out-column-p (col)
  (> col fill-column))

(defun cfg-lisp--oobp (&optional point)
  (let ((point (or point (point))))
    (cfg-lisp--out-column-p (cfg-lisp--col-of point))))

(cl-defun cfg-lisp--fill-list (&key limit recursive inner)
  "Assuming at the beginning of a list sexp, fill it, without
preserving cursor.  Return the highest end column of its child."
  (let ((end-marker (copy-marker (cdr (lispy--bounds-dwim)) t)))
    ;; go to beginning of car (fn name), then to the end of car
    (forward-char) (forward-sexp)
    ;; remove excess spaces if any
    (just-one-space)
    (cl-do ((count 0 (1+ count))
            (col -1
                 (cl-destructuring-bind (new-col . next-p)
                     (cfg-lisp--fill-at-child
                      end-marker
                      :init (zerop count) :recursive recursive)
                   (let ((col (max col new-col)))
                     (when (or (and limit (>= count limit))
                               (and inner
                                    (cfg-lisp--out-column-p col))
                               (not next-p))
                       (cl-return col))
                     col))))
        (nil))))

(cl-defun cfg-lisp--fill-at-child (end-marker &key init recursive)
  "Try to fill the next child.  Return a `cons' cell whose `car' is
the highest end column of the child, and whose `cdr' is whether
more children should be filled."
  (when indent-line-function (funcall indent-line-function))
  (cl-flet* ((parent* ()
               (save-excursion
                 (cfg-lisp--fill-list :recursive recursive
                                      :inner t)))
             (skip-space (&optional backward newline)
               (funcall (if backward #'skip-chars-backward
                          #'skip-chars-forward)
                        (if newline " \t\n" " \t")))
             (parent ()
               (if recursive
                   (let ((first (parent*)))
                     (if (cfg-lisp--out-column-p first)
                         (progn (skip-space t)
                                (newline-and-indent)
                                (parent*))
                       first))
                 -1))
             (skip-comment () (forward-comment (buffer-size)))
             (cfg-lisp--col-of (point)
               (save-excursion (goto-char point)
                               (current-column)))
             (next-line-only-comment-p ()
               (save-excursion
                 (forward-line 1)
                 (< (point)
                    (save-excursion (skip-comment)
                                    (forward-line 0) (point))))))
    (cl-destructuring-bind (left . right) (lispy--bounds-dwim)
      (let ((last-child-p (>= (1+ right) end-marker))
            (left (copy-marker left t))
            (right (copy-marker right t))
            (col -1))
        (cl-flet
            ((put-col (point)
               (setq col (max col (cfg-lisp--col-of point)))))
          (cond
           ;; option (1): at cadr (arg 1); (2): at comment; (3):
           ;; at newline
           ((lispy--in-comment-p)
            (fill-comment-paragraph) (skip-comment))
           ((eql (char-after) ?\C-j)
            (forward-line 1) (skip-space))
           (t
            ;; at beginning of child sexp
            (let ((line-first-child-p
                   (save-excursion
                     (skip-space 'backward)
                     (zerop (point)))))
              ;; Work on current child
              (cond
               ;; if child is list-like, fill it
               ((lispy-left-p) (put-col (parent)))
               ;; no-op if first sexp of the line or parent
               ((or init line-first-child-p)
                (put-col (cdr (lispy--bounds-dwim))))
               ;; otherwise, assume child is an atom.  (1): if
               ;; left is out of bound, break line from the end of
               ;; previous sexp; (2): if end of parent sexp, and
               ;; end or closing paren out of bound, break line
               ;; from the end of previous sexp
               (t (when (or (cfg-lisp--oobp left)
                            (cfg-lisp--oobp right)
                            (and last-child-p
                                 (cfg-lisp--oobp end-marker)))
                    (skip-space 'backward)
                    (put-col right)
                    (newline-and-indent))))
              ;; go to the next child
              (if last-child-p nil
                (forward-sexp)
                (just-one-space
                 (let ((next (save-excursion
                               (skip-space) (char-after))))
                   (cond
                    ((and (eql next ?\C-j)
                          (next-line-only-comment-p))
                     0)
                    ((eql next ?\C-j) -1)
                    (t 1))))))))
          (put-col right)
          (cons col (not last-child-p)))))))

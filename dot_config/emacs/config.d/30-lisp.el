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
  "Insert an operator name.  See `cfg-lisp-insert-allowed-operators’
for the list of allowed operators."
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
        :inserter old))))

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
  :after lisp-mode
  :commands lispy-mode
  :custom
  (lispy-no-space t))

;;;###autoload
(progn (add-hook 'lisp-mode-hook #'lispy-mode)
       (add-hook 'lisp-data-mode-hook #'lispy-mode))

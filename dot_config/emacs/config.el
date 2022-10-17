;;; config.el  -*- lexical-binding: t; no-byte-compile: nil; -*-

;;; For my sanity, all keybinds in my configs are setup using
;;; vectors.  I have tried various different formats (like kbd +
;;; string, raw string, ...), but when I put in more complex ones,
;;; they become less intuitive.  It is possible that the rules for
;;; them are simpler, but these rules has always slipped my mind
;;; when I was able to grasp the syntax for vector keybinds. With
;;; vector keybinds, I only have to remember two rules:
;;;
;;; (1) Simpler keybinds like ctrl + alt + latin-key always follow
;;; [?k], [?\M-\(], [?\C-\M-\s-k] formats.  In this case, the
;;; "base key" must be represented by a single character, unless
;;; escaped by backslash, and an arbitrary amount of (unique)
;;; modifier keys are inserted between the `?' and the base key in
;;; the form of `\X-', where X is replaced by one of the following
;;; characters: C=Ctrl, M=Meta(alt), S=Shift, s=super(icon key,
;;; "windows" key), m=??, h=hyper(??).
;;;
;;; (2) More complex keybinds where the base key cannot be
;;; represented by a single character and thus first rule doesn't
;;; apply, a name in vector like [C-f5] should suffice.  In this
;;; case it might be necessary to look around for the name of this
;;; key, but that is true for all keybind schemes and is nothing
;;; particular in vector keybinds.

(eval-and-compile (load "utils"))

;; local (private) configurations
(eval-and-compile (cfg-load "local"))

;; make sure buffer "*Compile-Log*" does not show up after startup

;; (unless :disabled
;;   (add-hook
;;    'emacs-startup-hook
;;    ;; don't kill buffer
;;    (lambda () (quit-window nil (get-buffer-window "*Compile-Log*")))))

;; linting

;; - flycheck

;; TODO

;; security and authentication

;; TODO

;; recursively load all *.el files
;; (cfg-load-recurse cfg--init-dir 'no-compile)
(cfg-control-dir "config.d" "autoloads/config.el")

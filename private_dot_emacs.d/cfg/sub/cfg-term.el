(require 'cfg-package)

(use-package eterm-256color
  :ensure t
  :hook (term-mode . eterm-256color-mode)
  )

(use-package term
  :ensure nil
  :commands (term
	     new-term)
  :preface
  (defvar explicit-zsh-args)
  :custom
  (explicit-shell-file-name "zsh")
  (explicit-zsh-args nil)
  :functions (cfg-term--buffer-usable
	      cfg-term--next
	      cfg-term--make
	      term-check-proc
	      term-mode
	      term-exec
	      term-char-mode
	      new-term)
  :config
  (defun cfg-term--buffer-usable (buffer-or-name)
    ;; a buffer is usable if any of these are true:
    ;; 1. it does not exist;
    ;; 2. it exists but the terminal is "dead"
    ;;
    ;; return the buffer if it is usable, otherwise nil
    (let ((buffer (get-buffer-create buffer-or-name)))
      (if (not (term-check-proc buffer))
          buffer))
    )

  (defun cfg-term--next (name &optional index)
    "Get the first usable terminal buffer.
Check whether the buffer \"*NAME*<INDEX>\" is usable as a
terminal. Iterate index until the first usable buffer and return
this usable buffer."
    (let* ((index (or index 0))
	   (buffer-name
	    (concat "*" name "*<"
		    (number-to-string index)
		    ">"))
           (buffer-or-nil
	    (cfg-term--buffer-usable buffer-name)))
      (or buffer-or-nil
          (cfg-term--next name (+ index 1))))
    )

  (defun cfg-term--make (name
			 program
			 &optional startfile
			 &rest switches)
    "Make a term process NAME in a buffer, running PROGRAM.
The name of the buffer is verbatim to the argument NAME.
Optional third arg STARTFILE is the name of a file to send the
contents of to the process.  Any more args (SWITCHES) are
arguments to PROGRAM."
    (let ((buffer (cfg-term--next name)))
      ;; If no process, or nuked process, crank up a new one and put
      ;; buffer in term mode.  Otherwise, leave buffer and existing
      ;; process alone.
      (cond ((not (term-check-proc buffer))
	     (with-current-buffer buffer
	       (term-mode)) ; Install local vars, mode, keymap, ...
	     (term-exec buffer name program startfile switches)))
      buffer)
    )

  ;; create a new terminal
  (defun new-term (program)
    "Start a terminal-emulator with PROGRAM in a new, indexed buffer.
The buffer is in Term mode; see `term-mode' for the commands to
use in that buffer.  Also see `term' and `make-term'."
    
    (interactive
     (list
      (read-from-minibuffer
       "Run program: "
       (or explicit-shell-file-name
	   (getenv "ESHELL")
	   shell-file-name))))

    (let ((buffer (cfg-term--make "terminal" program)))
      (set-buffer buffer)
      (term-mode)
      (term-char-mode)
      (switch-to-buffer buffer))
    )
  )

(provide 'cfg-term)

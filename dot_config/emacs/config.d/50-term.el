(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(eterm-256color
             vterm)))

;;;###autoload
(defun cfg-term-get-shell ()
  "Function to get the shell to use."
  (or (getenv "SHELL")
      (executable-find "zsh")
      (executable-find "bash")
      "/bin/sh"))

;; vterm
;;;###autoload
(use-package vterm
  :if (executable-find "cmake")
  :commands vterm
  :hook
  (vterm-mode
   . (lambda () (display-fill-column-indicator-mode -1)))
  :custom
  (vterm-shell (cfg-term-get-shell))
  (vterm-max-scrollback 10000))

;; term
;;;###autoload
(use-package eterm-256color
  :after term
  :hook (term-mode . eterm-256color-mode))

;;;###autoload
(use-package term
  :straight nil
  :commands term new-term
  :hook
  (term-mode
   . (lambda () (display-fill-column-indicator-mode -1)))
  :custom
  (explicit-shell-file-name (or (getenv "SHELL")
                                "zsh"))
  (explicit-zsh-args nil)
  :config
  (defun cfg-term--buffer-usable (buffer-or-name)
    ;; a buffer is usable if any of these are true:
    ;; 1. it does not exist;
    ;; 2. it exists but the terminal is "dead"
    ;;
    ;; return the buffer if it is usable, otherwise nil
    (let ((buffer (get-buffer-create buffer-or-name)))
      (if (not (term-check-proc buffer))
          buffer)))

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
          (cfg-term--next name (+ index 1)))))

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
      buffer))

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
      (switch-to-buffer buffer))))

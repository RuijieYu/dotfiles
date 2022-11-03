;;;###autoload
(defconst gui-features
  ;; ref: https://emacs.stackexchange.com/q/28840
  '("X11"                     ; Xorg build for Linux & macOS
    "PGTK"                    ; Pure GTK build for Linux (Wayland)
    "NS"                      ; Nextstep build for macOS (?)
    "COCOA"                   ; (maybe?)
    )
  "Features to check for to determine whether Emacs is built with
GUI support.")

;;;###autoload
(defun gui-p ()
  "Determine whether the current Emacs program is built with GUI
support."
  (interactive)
  (cl-do ((features (split-string system-configuration-features)
                    (cdr features)))
      ((or (member (car features) gui-features)
           (null features))
       features)))

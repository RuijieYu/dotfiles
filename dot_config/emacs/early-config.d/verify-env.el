;;;###autoload
(defconst cfg-critical-envs
  '(DISPLAY
    WAYLAND_DISPLAY
    I3SOCK
    SWAYSOCK
    MOZ_ENABLE_WAYLAND
    PYENV_ROOT
    GTK_IM_MODULE
    QT_IM_MODULE
    SDL_IM_MODULE
    GLFW_IM_MODULE
    XMODIFIERS
    XDG_SEAT
    XDG_SESSION_CLASS
    XDG_SESSION_DESKTOP
    XDG_SESSION_ID
    XDG_SESSION_TYPE
    XDG_VTNR))

;;;###autoload
(defun cfg-show-critical-envs ()
  "Show certain critical environment variables to make sure systemd
is working as intended."
  (interactive)
  (message
   "*** ENV: %s"
   (mapcar (lambda (name) `(,name ,(getenv (symbol-name name))))
           cfg-critical-envs)))

;;;###autoload
(add-hook 'emacs-startup-hook #'cfg-show-critical-envs)

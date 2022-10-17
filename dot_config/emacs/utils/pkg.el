(load (expand-file-name "autoloads/utils" user-emacs-directory))

;;;###autoload
(defvar cfg-compile-now nil
  "When non-nil, compile all `use-package''d packages.  Effectively,
all `use-package' calls require the package immediately.

TODO: how to, and whether we should, ignore the effects of
:defer?")

(if init-file-debug
    (setq use-package-verbose t
          use-package-expand-minimally nil
          use-package-compute-statistics t
          debug-on-error t)
  (setq use-package-verbose nil
        use-package-expand-minimally t))

;;;###autoload
(defvar bootstrap-version)

;;;###autoload
(autoload 'straight-use-package
  (expand-file-name "utils/pkg" user-emacs-directory) nil t)

(eval-and-compile
  ;; bootstrap straight.el
  (setq package-enable-at-startup nil)
  (let* ((straight-el
          (expand-file-name "straight/repos/straight.el"
                            user-emacs-directory))
         (bootstrap-file (concat straight-el "/bootstrap.el"))
         (bootstrap-version 5))
    ;; make sure the repository exists
    (unless (file-exists-p bootstrap-file)
      ;; make sure git exists
      (unless (executable-find "git")
        (error "Require \"git\"."))
      (shell-command
       (format "git clone %s %s"
               "https://github.com/raxod502/straight.el"
               straight-el)))
    (load bootstrap-file))
  (setq straight-use-package-by-default t)

  ;; ensure installation of use-package
  (straight-use-package 'use-package)

  ;; configure use-package's default behavior
  (setq use-package-always-defer t)

  ;; override for when `cfg-compile-now' is non-nil
  (setq use-package-always-demand cfg-compile-now
        use-package-always-defer (not cfg-compile-now))

  ;; additional straight keybinds
  (use-package straight
    :commands (straight-use-package
               straight-visit-package-website))
  (define-keymap :keymap (current-global-map)
    "C-<tab> s u" #'straight-use-package
    "C-<tab> s v" #'straight-visit-package-website)

  ;; not sure why, but org always complains about mismatched
  ;; versions
  (straight-use-package 'org))

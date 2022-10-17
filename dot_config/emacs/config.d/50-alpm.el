;;; alpm.el  -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils"))

;; recognize PKGBUILD files
(defun cfg-pkgbuild--is-p ()
  (string= "PKGBUILD"
           (file-name-nondirectory buffer-file-name)))

;;;###autoload
(defun cfg-pkgbuild-setup ()
  (with-eval-after-load 'sh-script
    (when (cfg-pkgbuild--is-p)
      (sh-set-shell "sh")
      (define-keymap :keymap (current-local-map)
        "C-c C-c" #'cfg-pkgbuild-build
        "C-c C-d" #'cfg-pkgbuild-update-sums
        "C-c C-s" #'cfg-pkgbuild-gen-srcinfo
        "C-c C-b" #'cfg-pkgbuild-makepkg))))

(defun cfg-pkgbuild--compile-with (cmd)
  (when (cfg-pkgbuild--is-p)
    (let ((compile-command cmd))
      (call-interactively #'compile))))

(defconst cfg-pkgbuild--makepkg "makepkg --force --syncdeps "
  "Command for building the package without chroot.")

(defun cfg-pkgbuild--makepkg ()
  "Build the package using \"makepkg\".  See URL `man:makepkg(1)'
for futher explanation."
  (interactive nil)
  (cfg-pkgbuild--compile-with cfg-pkgbuild--makepkg))

(defconst cfg-pkgbuild--makechrootpkg
  "makechrootpkg -cur '%s'"
  "Command formatter for building the package with chroot.  First
argument is the chroot directory.")

(defun cfg-pkgbuild--makechrootpkg-fmt (&optional chroot-dir)
  "Format the string for `cfg-pkgbuild--makechrootpkg'."
  (format cfg-pkgbuild--makechrootpkg
          (or chroot-dir (read-directory-name
                          "Chroot directory? "
                          "/var/lib/aurbuild/x86_64/"
                          nil :must-match))))

(defun cfg-pkgbuild--makechrootpkg (&optional chroot-dir)
  "Build the package inside CHROOT-DIR."
  ;; (format cfg-pkgbuild--makechrootpkg )
  (error "Function definition lost, need reconstruction.  Got %s"
         chroot-dir))

(defun cfg-pkgbuild-makepkg--fmt (&optional use-chroot)
  (if use-chroot (cfg-pkgbuild--makechrootpkg-fmt)
    cfg-pkgbuild--makepkg))

(defun cfg-pkgbuild-makepkg (&optional use-chroot)
  "Build the package.  When USE-CHROOT is non-nil, defer to
`cfg-pkgbuild--makechrootpkg'; otherwise defer to
`cfg-pkgbuild--makepkg'."
  (interactive "P")
  (call-interactively
   (if use-chroot #'cfg-pkgbuild--makechrootpkg
     #'cfg-pkgbuild--makepkg)))

(defconst cfg-pkgbuild-gen-srcinfo
  "makepkg --printsrcinfo >.SRCINFO"
  "Command to generate .SRCINFO file.")

(defun cfg-pkgbuild-gen-srcinfo ()
  "Generate .SRCINFO file."
  (interactive nil)
  (cfg-pkgbuild--compile-with cfg-pkgbuild-gen-srcinfo))

(defconst cfg-pkgbuild-update-sums "updpkgsums"
  "Command to update checksums.")

(defun cfg-pkgbuild-update-sums ()
  "Update PKGBUILD checksums. Requires the executable
\"pkdpkgsums\"."
  (interactive nil)
  (cfg-pkgbuild--compile-with cfg-pkgbuild-update-sums))

(defun cfg-pkgbuild-build (&optional use-chroot)
  "Build a PKGBUILD file.  See also `cfg-pkgbuild-makepkg',
`cfg-pkgbuild-gen-srcinfo', and `cfg-pkgbuild-update-sums' for
individual steps."
  (interactive "P")
  (cfg-pkgbuild--compile-with
   (mapconcat #'identity
              `(,cfg-pkgbuild-update-sums
                ,cfg-pkgbuild-gen-srcinfo
                ,(cfg-pkgbuild-makepkg--fmt use-chroot))
              " && ")))

;;;###autoload
(use-package sh-script
  :straight nil
  :hook
  (sh-mode . cfg-pkgbuild-setup))

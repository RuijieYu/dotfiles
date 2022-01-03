(defconst cfg-all-distros
  '(arch
    macos
    win
    nil)
  "This variable contains all recognized distros.")

(defconst cfg-all-archs
  '(x86_64
    m1
    nil)
  "This variable contains all recognized architectures.")

(defcustom cfg-distro
  "arch"
  "This variable holds the string of the current distro. Default
managed by chezmoi."
  :type 'string
  :group 'custom
  )

(defcustom cfg-arch
  "x86_64"
  "This variable holds the string of the current architecture. Default managed by chezmoi."
  :type 'string
  :group 'custom
  )

(defun cfg-distro ()
  "This function returns the current distro as a symbol.  See the
variable `cfg-distro'."
  (intern cfg-distro))

(defun cfg-arch ()
  "This function returns the current architecture as a symbol.
See the variable `cfg-arch'."
  (intern cfg-arch))

(provide 'cfg-platform)

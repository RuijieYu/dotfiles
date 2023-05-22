(defun cfg-noop (&rest -)
  "A no-op keybind.  Especially useful when remapping certain
undesired keybinds to disable *all* of its keybinds.  See also
`define-remap'."
  (interactive))

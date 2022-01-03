(global-set-key
 ;; this keybind does not work in tty, but I don't need color
 ;; inversion in tty anyways
 (kbd "<C-=>")
 (lambda () (interactive) (invert-face 'default)))

(provide 'cfg-invert-color)

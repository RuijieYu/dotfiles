;;; early-init.el --- Early init  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(setopt load-prefer-newer t
        custom-file "/dev/null"
        package-native-compile t)

(autoload 'package--user-selected-p "package")
(ignore (package--user-selected-p 'emacs))

(provide 'early-init)
;;; early-init.el ends here.

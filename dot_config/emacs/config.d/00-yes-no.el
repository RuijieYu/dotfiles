;; -*- no-byte-compile: nil; -*-
;; make sure yes-or-no-p -> y-or-n-p for laziness
;;;###autoload
(defalias 'yes-or-no-p #'y-or-n-p)

;; -*- no-byte-compile: t; -*-
(use-package helpful
  :disabled
  :after counsel
  :bind
  (([remap describe-function] . #'counsel-describe-function)
   ([remap describe-variable] . #'counsel-describe-variable)))

()

;; -*- no-byte-compile: t; -*-
(use-package dockerfile-mode
  :disabled
  :mode
  ((rx "Containerfile") . dockerfile-mode))

(use-package docker-compose-mode
  :disabled)

()

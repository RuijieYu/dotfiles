(require 'cfg-package)

(use-package swiper
  :ensure t
  :commands (swiper
	     swiper-backward)
  :bind
  ([remap isearch-forward] . swiper)
  ([remap isearch-backward] . swiper-backward)
  )

(provide 'cfg-swiper)

(require 'package)

;; make sure melpa is available
;; (add-to-list 'package-archives
;; 	     '("melpa" . "https://melpa.org/packages/"))
(push '("melpa" . "https://melpa.org/packages/") package-archives)

;; initialize db, and refresh packages if necessary
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; when `use-package' is absent, install it
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(provide 'cfg-package)

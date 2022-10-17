;; -*- no-byte-compile: t; -*-

;; (defun cfg-sgml-pretty-print (&optional start end)
;;   "Like `sgml-pretty-print', but with `auto-fill-mode' enabled.
;; When a region is active, START and END defaults to the start and
;; end of the region; otherwise START and END defaults to the start
;; and end of the entire buffer."
;;   (interactive)
;;   (cfg--with-minor-enabled #'auto-fill-mode
;;     (let* ((region (region-active-p))
;;            (use (and start end))
;;            (start (cond (use start)
;;                         (region (region-beginning))
;;                         (t (point-min))))
;;            (end (cond (use end)
;;                       (region (region-end))
;;                       (t (point-max)))))
;;       (sgml-pretty-print start end))))

;; (dont-compile
;;   (use-package sgml-mode
;;     :straight nil
;;     )

;;   (use-package mhtml-mode
;;     ;; :mode ((rx ".html" string-end) . mhtml-mode)
;;     :after sgml-mode
;;     :bind
;;     ( :map mhtml-mode-map
;;       ([C-tab ?= ?=] . cfg-sgml-pretty-print)
;;       ([C-tab ?= ?b] . cfg-sgml-pretty-print)
;;       ([C-tab ?= ?r] . cfg-sgml-pretty-print)
;;       )
;;     )
;;   )

;; (use-package html5-schema)

;; (defun cfg-html-pretty-format ()
;;   "Pretty-print the currently-visible parts of an HTML buffer.  See
;; `sgml-pretty-print'."
;;   (interactive)
;;   (save-mark-and-excursion
;;     ;; (cfg--with-minor-enabled #'auto-fill-mode
;;     (auto-fill-mode 1)
;;     (delete-indentation nil (point-min) (point-max))
;;     (sgml-pretty-print (point-min) (point-max))
;;     ;; )
;;     ))

;; (cfg-load "lsp.el")
;; (use-package nxml-mode
;;   :straight nil
;;   :mode ((rx ".html" string-end) . nxml-mode)
;;   :after sgml-mode
;;   :bind
;;   ( :map nxml-mode-map
;;     ([?\C-c ?\C-c] . #'browse-url-of-buffer)
;;     ([C-tab ?= ?=] . #'cfg-html-pretty-format)
;;     ([?\C-c ?l ?= ?=] . #'cfg-html-pretty-format)
;;     ))

()

;; this modifies EDITOR and VISUAL envvar inside a client session so
;; that new editing sessions are opened in the same client.
(defvar server-process)
(when
    ;; only when in a client
    (and (featurep 'server) ; when in client, 'server should be loaded
	 server-process)
  (setenv "EDITOR" "emacsclient")
  (setenv "VISUAL" "emacsclient")
  )

(provide 'cfg-subedit)

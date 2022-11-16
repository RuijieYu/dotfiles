;;;###autoload
(with-eval-after-load 'server
  (add-hook 'after-init-hook
	    (lambda () (message "*** Server loaded ***"))))

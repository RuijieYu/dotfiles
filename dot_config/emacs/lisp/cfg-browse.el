;;; cfg-browse.el --- Configure browsing experience

;;; Commentary:

;;; Code:
(autoload 'browse-url-default-browser "browse-url")


(with-eval-after-load 'browse-url
  (setopt browse-url-browser-function
          #'browse-url-default-browser
          browse-url-secondary-browser-function
          #'eww))

(provide 'cfg-browse)
;;; cfg-browse.el ends here.

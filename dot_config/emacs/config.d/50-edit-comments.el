;;; Integrate my edit-comments package
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '((edit-comments :type git
                            :host github
                            :repo "RuijieYu/emacs-edit-comments"))))

;;;###autoload
(use-package edit-comments
  :straight (edit-comments :type git
                           :host github
                           :repo "RuijieYu/emacs-edit-comments")
  :commands edit-comments--kill-hook
  :custom
  (edit-comments-window-setup 'reorganize-frame)
  :hook
  (prog-mode . edit-comments-mode))

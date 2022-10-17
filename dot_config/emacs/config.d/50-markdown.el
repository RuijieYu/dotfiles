;; "https://github.com/sindresorhus/github-markdown-css/raw/main/github-markdown.css"
;; "https://github.com/sindresorhus/github-markdown-css/raw/main/github-markdown-light.css"
(eval-and-compile
  (defconst cfg--css-remote
    "https://github.com/sindresorhus/github-markdown-css/raw/main/github-markdown-dark.css")
  (defconst cfg--css-remote-file-name
    (file-name-nondirectory cfg--css-remote))
  (defconst cfg--css-local-dir
    (expand-file-name "share" user-emacs-directory))
  (defconst cfg--css-local-file
    (expand-file-name cfg--css-remote-file-name cfg--css-local-dir))
  (make-directory cfg--css-local-dir :parents)
  (unless (file-exists-p cfg--css-local-file)
    (url-copy-file cfg--css-remote
                   (expand-file-name
                    cfg--cs-remote-file-name
                    cfg--css-local-dir)
                   :ok-if-exists)))

(defun cfg--read-file (file-name)
  ;; ref: http://xahlee.info/emacs/emacs/elisp_read_file_content.html
  (with-temp-buffer
    (insert-file-contents file-name)
    (buffer-string)))

(defvar cfg--current-markdown nil
  "non-nil for github api, nil for default")
(defconst cfg--markdown-api-command
  (format "'%s' --json --gfm"
          (expand-file-name "share/markdown-github.sh"
                            user-emacs-directory)))
(defun cfg-toggle-markdown ()
  (interactive)
  (setq cfg--current-markdown (not cfg--current-markdown))
  (customize-set-variable
   'markdown-command (if cfg--current-markdown
                         cfg--markdown-api-command
                       "markdown")))

(with-eval-after-load 'rx-insensitive
  (defun cfg-markdown--readme-github-style ()
    (when (string-match-p (rx-insensitive "/readme" string-end)
                          buffer-file-name)
      (gfm-mode)))

  (eval
   ;; unfortunately :mode only recognizes `rx' and raw-string
   `(use-package markdown-mode
      ;; use some common cases
      :mode (,(rx-insensitive "/readme.md" string-end)
             . gfm-mode)
      ;; may also just be "readme", convert it at mode start
      :hook
      (markdown-mode . cfg-markdown--readme-github-style)
      :custom
      ;; github dark theme
      (markdown-css-paths `(,cfg--css-local-file))
      ;; stylize the class
      (markdown-xhtml-header-content
       (format "<style>%s</style>"
               (cfg--read-file (expand-file-name
                                "etc/markdown-dark.css"
                                user-emacs-directory))))
      ;; add class to entire body
      (markdown-xhtml-body-preamble
       "<div class=\"markdown-body\">")
      (markdown-xhtml-body-epilogue "</div>"))))

;; (use-package markdown-preview-mode
;;   :after markdown-mode
;;   :hook
;;   (markdown-mode . markdown-preview-mode)
;;   )

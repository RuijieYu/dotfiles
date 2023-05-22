;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(dired-open
             all-the-icons-dired
             dired-collapse
             dired-rainbow
             dired-ranger)))

;;;###autoload
(defun cfg-dired-setup ()
  "Custom setup hook for `dired-mode'."
  (interactive)
  (dired-omit-mode)
  (cfg-dired--enable-icons)
  (cfg-dired-setup--avoid-remote-trash))

(defun cfg-dired-setup--avoid-remote-trash ()
  (when (and (boundp 'dired-directory)
             dired-directory
             (file-remote-p dired-directory))
    (setq-local delete-by-moving-to-trash nil)))

;;;###autoload
(add-hook 'dired-mode-hook #'cfg-dired-setup)

;;;###autoload
(defconst cfg-dired-recognized-office-suites
  '("libreoffice" "openoffice")
  "The list of recognized office suites.  The earlier elements of
the list have higher precedence.  See
`cfg-dired-office-suite’.")

;;;###autoload
(defun cfg-dired-office-suite ()
  "Return the first office suite found from the system.  This office
suite executable should be able to open any acceptable file
types.  The returned executable name might not be an absolute
path."
  (cl-do ((choices cfg-dired-recognized-office-suites))
      ((or (null choices)
           (executable-find (car choices)))
       (and choices (car choices)))))

;;;###autoload
(use-package dired-x
  :straight nil
  :custom
  (dired-guess-shell-alist-user
   `((,(rx ".pdf" string-end) "zathura --fork")
     (,(rx ?. (or "png" "jpg" "jpeg" "gif") string-end) "imv")
     (,(rx ?. (or "ppt" "pptx" "doc" "docx") string-end)
      ,(cfg-dired-office-suite)))))

;;;###autoload
(use-package dired
  :straight nil
  :commands dired
  :after rx
  :custom
  (dired-listing-switches
   ;; "-o" and "-g" omits user and group information
   (string-join '("--all" "--human-readable" "-o" "-g"
                  "--group-directories-first")
                " "))
  (delete-by-moving-to-trash t)
  (dired-ls-F-marks-symlinks t)
  (dired-omit-files
   (rx (or (seq string-start ".." string-end)
           (seq string-start ".#"))))
  (dired-omit-verbose nil))

;;;###autoload
(defun cfg-dired--maybe-trash (path trash)
  (and trash (file-remote-p path) t))

;;;###autoload
(defun cfg-dired-open-remote-buffer ()
  "Handle remote filename via `dired-find-file'.

See also `dired-open-functions'."
  (interactive)
  (and (file-remote-p (dired-get-file-for-visit))
       (prog1 t (dired-find-file))))

;; open files with enter
;;;###autoload
(use-package dired-open
  ;; FIXME: usually dired-open does not work for remote files --
  ;; either copy to local temp dir, or try to open from buffer
  :demand t
  :after dired
  :custom
  (dired-open-functions
   '(cfg-dired-open-remote-buffer
     dired-open-guess-shell-alist
     dired-open-subdir)))

;;* Dired with icons
;;;###autoload
(defun cfg-dired--enable-icons ()
  (interactive)
  (when (display-graphic-p)
    (require 'all-the-icons-dired)
    (all-the-icons-dired-mode)))

;;;###autoload
(use-package all-the-icons-dired
  :after (all-the-icons dired)
  :commands all-the-icons-dired-mode
  :diminish all-the-icons-dired-mode)

;;* Additional dired features
;;;###autoload
(use-package dired-collapse
  :after dired
  :hook (dired-mode . dired-collapse-mode))

;;;###autoload
(use-package dired-rainbow
  :after dired
  :commands (dired-rainbow-define-chmod
             dired-rainbow-define)
  :defines dired-rainbow-ext-to-face
  :config
  (function-put 'dired-rainbow-define 'lisp-indent-function 2)

  (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
  (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*")

  (dired-rainbow-define html "#eb5286"
    ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml"
     "mustache" "xhtml"))
  (dired-rainbow-define xml "#f2d024"
    ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn"
     "rss" "yaml" "yml" "rdata"))
  (dired-rainbow-define document "#9561e2"
    ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu"
     "epub" "odp" "ppt" "pptx"))
  (dired-rainbow-define markdown "#ffed4a"
    ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst"
     "tex" "textfile" "txt"))
  (dired-rainbow-define database "#6574cd"
    ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
  (dired-rainbow-define media "#de751f"
    ("mp3" "mp4" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov"
     "mid" "midi" "wav" "aiff" "flac"))
  (dired-rainbow-define image "#f66d9b"
    ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps"
     "svg"))
  (dired-rainbow-define log "#c17d11" ("log"))
  (dired-rainbow-define shell "#f6993f"
    ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
  (dired-rainbow-define interpreted "#38c172"
    ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r"
     "clj" "cljs" "scala" "js"))
  (dired-rainbow-define compiled "#4dc0b5"
    ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m"
     "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03"
     "f08" "s" "rs" "hi" "hs" "pyc" "java"))
  (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
  (dired-rainbow-define compressed "#51d88a"
    ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "zst" "jar"
     "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
  (dired-rainbow-define packaged "#faad63"
    ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk"
     "bsp" "pkg.tar.zst"))
  (dired-rainbow-define encrypted "#ffed4a"
    ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
  (dired-rainbow-define fonts "#6cb2eb"
    ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
  (dired-rainbow-define partition "#e3342f"
    ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
  (dired-rainbow-define vc "#0074d9"
    ("git" "gitignore" "gitattributes" "gitmodules")))

;;;###autoload
(use-package dired-ranger
  :after dired
  :commands (dired-ranger-bookmark
             dired-ranger-copy
             dired-ranger-paste
             dired-ranger-move
             dired-ranger-bookmark-visit))

;;;###autoload
(defvar-keymap cfg-dired-ranger-map
  :doc "Keymap for dired-ranger."
  "b" #'dired-ranger-bookmark
  "c" #'dired-ranger-copy
  "p" #'dired-ranger-paste
  "r" #'dired-ranger-move
  "v" #'dired-ranger-bookmark-visit)

;;;###autoload
(with-eval-after-load 'dired
  (define-keymap :keymap dired-mode-map
    ";" (cons "dired-ranger" cfg-dired-ranger-map)))

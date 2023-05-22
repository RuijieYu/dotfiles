;;; cfg-org-latex.el --- Configure org->latex

;;; Commentary:

;;; Code:
(require 'cfg-org)


(defvar org-latex-src-block-backend)


;; * `defgroup'
(defgroup cfg-org-latex nil
  "Configuration for org exporting."
  :group 'cfg)


;; * `defcustom'
(defcustom cfg-org-latex-ref nil
  "A meta value controlling `org-latex-reference-command'."
  :type '(choice (const :tag "\\cref{}" cref)
          (const :tag "\\ref{}" nil))
  :set (lambda (n v)
         (set n v)
         (setopt org-latex-reference-command
                 (pcase v
                   ('cref "\\cref{%s}")
                   ('nil "\\ref{%s}")
                   (_ (error "Bad value of `%s'" n))))))

(defcustom cfg-org-latex-hyperref
  '(("pdfauthor" . "{%a}")
    ("pdftitle" . "{%t}")
    ("pdfkeywords" . "{%k}")
    ("pdfsubject" . "{%d}")
    ("pdfcreator" . "{%c}")
    ("pdflang" . "{%L}"))
  "A meta variable controlling `org-latex-hyperref-template'.
This is an alist of hyperref setup key-values, where the key is a
string, and the value is either nil or a string.

When the value is nil, the corresponding key does not take any
value input."
  :type '(alist :key-type string
          :value-type (choice (const :tag "no value" nil)
                       (string :tag "value")))
  :set (lambda (n v)
         (set n v)
         (thread-last
           (seq-reduce
            (lambda (a kv)
              (let ((line
                     (thread-last
                       (pcase kv
                         (`(,k . nil) k)
                         (`(,k . ,v) (concat k [?=] v)))
                       (concat " "))))
                (if (eq t a) line (concat a ",\n" line))))
            v t)
           (format "\\hypersetup{\n%s}\n")
           (setopt org-latex-hyperref-template))))

(defcustom cfg-org-latex-src-block-backend 'verbatim
  "Backend in use.
See `org-latex-src-block-backend' and `org-latex-pdf-process'."
  :type '(choice (const minted)
          (const verbatim)
          (const listings)
          (const engraved))
  :set (lambda (n v)
         (set n v)
         (setopt org-latex-src-block-backend v
                 org-latex-pdf-process
                 (pcase v
                   ('minted
                    `(,(concat
                        "latexmk -f -pdf "
                        "-%latex "
                        "-%latex='%latex --shell-escape %%O %%S' "
                        "-interaction=nonstopmode "
                        "-output-directory=%o %f")))
                   (_ `(,(concat "latexmk -f -pdf "
                                 "-%latex "
                                 "-interaction=nonstopmode "
                                 "-output-directory=%o %f")))))))


;; `setopt'
(with-eval-after-load 'ox-latex
  (setopt
   org-latex-compiler "xelatex"
   ;; in which environment are quotes contained
   org-latex-default-quote-environment "quotation"

   org-latex-packages-alist
   (let ((geometry (list "letterpaper,margin=.75in" "geometry"))
         (minted (and (eq org-latex-src-block-backend 'minted)
                      '("newfloat" "minted")))
         (cref (and cfg-org-latex-ref
                    '("nameinlink" "cleveref"))))
     (seq-filter #'identity (list geometry minted cref)))

   ;; how to cross-reference
   cfg-org-latex-ref 'cref

   ;; use colorized code blocks
   cfg-org-latex-src-block-backend 'minted

   ;; slightly modified from default
   cfg-org-latex-hyperref
   '(("colorlinks")
     ("linkcolor" . "blue")
     ("citecolor" . "blue")
     ("urlcolor" . "blue")
     ("pdfauthor" . "{%a}")
     ("pdftitle" . "{%t}")
     ("pdfkeywords" . "{%k}")
     ("pdfsubject" . "{%d}")
     ("pdfcreator" . "{%c}")
     ("pdflang" . "{%L}"))))


(provide 'cfg-org-latex)
;;; cfg-org-latex.el ends here.

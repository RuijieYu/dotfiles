;; -*- no-byte-compile: nil; -*-
(eval-when-compile
  (add-to-list
   'load-path (expand-file-name "autoloads" user-emacs-directory))
  (load "utils")
  (preload '(org)))

;;;###autoload
(use-package ox-md
  :straight org
  :after org
  :demand t)

;;;###autoload
(defconst cfg-org-export-use-ref 'cref
  "The reference command to use for org -> latex.  Currently only
recognizing nil or ’cref.")

;;;###autoload
(use-package ox-latex
  :straight org
  :after org
  :demand t
  :defines org-latex-minted-langs
  :custom
  (org-latex-compiler "xelatex")
  (org-latex-src-block-backend 'minted)
  (org-latex-hyperref-template
   ;; slightly modified from default
   (concat "\\hypersetup{"
           "colorlinks,"
           "linkcolor=blue,"
           "citecolor=blue,"
           "urlcolor=blue,"
           "pdfauthor={%a},"
           "pdftitle={%t},"
           "pdfkeywords={%k},"
           "pdfsubject={%d},"
           "pdfcreator={%c},"
           "pdflang={%L}"
           "}"))
  (org-latex-pdf-process
   (if (eq org-latex-src-block-backend 'minted)
       (list (concat
              "latexmk -f -pdf "
              "-%latex "
              "-%latex='%latex --shell-escape %%O %%S' "
              "-interaction=nonstopmode "
              "-output-directory=%o %f"))
     '("latexmk -f -pdf -%latex -interaction=nonstopmode -output-directory=%o %f")))
  (org-latex-packages-alist
   (let ((geometry (list "letterpaper,margin=.75in" "geometry"))
         (minted (and (eq org-latex-src-block-backend 'minted)
                      '("newfloat" "minted")))
         (cref (and cfg-org-export-use-ref
                    '("nameinlink" "cleveref"))))
     (cl-remove-if-not
      #'identity (list geometry minted cref))))
  (org-latex-reference-command
   (pcase cfg-org-export-use-ref
     ('cref "\\cref{%s}")
     ;; default value
     (_ "\\ref{%s}"))))

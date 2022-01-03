(require 'cfg-package)
(eval-and-compile
  (defcustom cfg-cpp--clang-format-path
    "/usr/share/clang"
    "The path to the *.el files for clang-format."
    :type 'directory
    :group 'custom
    )

  ;; can't find a way to disable undefined functions warning
  (push cfg-cpp--clang-format-path load-path)
  (require 'clang-format))

;; (declare-function clang-format load-file-name)
;; (declare-function clang-format-buffer load-file-name)
;; (declare-function clang-format-buffer load-file-name)

(use-package clang-format
  :ensure nil ; provided by arch "clang"
  :load-path "/usr/share/clang"
  ;; :functions (clang-format
  ;; 	      clang-format-buffer
  ;; 	      clang-format-region)
  :bind
  ("<C-c>fb" . #'clang-format-buffer)
  ("<C-c>ff" . #'clang-format)
  ("<C-c>fr" . #'clang-format-region)
  )

(provide 'cfg-cpp)

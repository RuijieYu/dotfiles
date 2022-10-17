;;; -*- no-byte-compile: nil; -*-
;; disable C-z for accidental freezing my frames (sway cannot
;; "minimize" windows; MAYBE... maybe I can hook that into sway/i3
;; scratchpad?)

;;;###autoload
(define-remap (current-global-map)
  [remap suspend-frame] nil
  [remap suspend-emacs] nil)

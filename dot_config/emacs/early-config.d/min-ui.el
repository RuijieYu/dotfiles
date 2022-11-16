;;;###autoload
(progn
  ;; minimize UI elements
  (with-eval-after-load 'scroll-bar (scroll-bar-mode -1))
  (with-eval-after-load 'tool-bar (tool-bar-mode -1))
  ;; show tooltip in minibuffer instead of pop-up window
  (with-eval-after-load 'tooltip (tooltip-mode -1))
  (with-eval-after-load 'menu-bar (menu-bar-mode -1))
  (with-eval-after-load 'simple (column-number-mode 1))

  ;; UI minimization
  (setq
   inhibit-startup-message t          ; thanks but see you no more
   mouse-wheel-scroll-amount
   '(1 ((shift) . 1))                 ; scroll one line each time
   mouse-wheel-progressive-speed nil  ; don't accelerate scrolling
   mouse-wheel-follow-mouse t         ; scroll the correct buffer
   scroll-step 1                      ; keyboard scrolling
   use-dialog-box nil
   large-file-warning-threshold nil     ; I know what I'm doing
   vc-follow-symlinks t                 ; don't ask
   )

  (setq-default
   fill-column 80                       ; much shorter lines
   indent-tabs-mode nil                 ; no tabs
   tab-width 4                          ; smaller tab size
   ))

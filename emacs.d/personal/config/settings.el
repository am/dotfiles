;; Settings
(setq-default
 ad-redefinition-action 'accept                  ; Silence warnings for redefinition
 confirm-kill-emacs 'yes-or-no-p                 ; Confirm before exiting Emacs
 create-lockfiles nil                            ; Prevent emacs from creating lock-files
 delete-by-moving-to-trash t                     ; Delete files to trash
 fill-column 100                                 ; Set width for automatic line breaking
 indent-tabs-mode nil                            ; Stop using tabs to indent
 initial-scratch-message ""                      ; Empty the initial *scratch* buffer
 line-spacing 3                                  ; Change line height
 mac-command-modifier 'meta                      ; Map cmd to meta
 mac-option-modifier 'super                      ; Map alt as super
 projectile-completion-system 'helm              ; Projectile completion system
 helm-M-x-fuzzy-match t                          ; Heml fuzzy match
 uniquify-buffer-name-style 'forward             ; Uniquify buffer names
 linum-format " %d "
 js-indent-level 2
 js2-basic-offset 2
 js2-bounce-indent-p t)

(set-frame-parameter nil 'fullscreen 'fullboth)  ; Set fullscreen at startup
(set-scroll-bar-mode nil)                        ; Hide scrollbars
(global-diff-hl-mode 0)                          ; Disable diff-hl since we use git-gutter

(key-chord-define-global "XX" 'helm-M-x)
(key-chord-define-global "f3" 'split-window-right)
(key-chord-define-global "f2" 'split-window-below)
(key-chord-define-global "f0" 'delete-window)
(key-chord-define-global "PP" 'helm-projectile-switch-project)
(key-chord-define-global "FF" 'helm-projectile-find-file)
(key-chord-define-global "SS" 'helm-projectile-ag)
(key-chord-define-global "GG" 'magit-status)
(key-chord-define-global "JJ" 'avy-go-word-1)
(key-chord-define-global "JK" 'avy-go-char-1)
(key-chord-define-global "JL" 'avy-go-line)
(key-chord-define-global "UU" 'undo-tree-visualize)

;; scroll
(setq mouse-wheel-scroll-amount '(1))
(setq mouse-wheel-progressive-speed nil)

(provide 'settings)

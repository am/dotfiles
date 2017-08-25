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
 js-indent-level 2)

(global-subword-mode 1)                          ; Iterate through CamelCase words
(line-number-mode 1)                             ; Show the line number
(set-frame-parameter nil 'fullscreen 'fullboth)  ; Set fullscreen at startup
(set-scroll-bar-mode nil)                        ; Hide scrollbars
(global-diff-hl-mode 0)                          ; Disable diff-hl since we use git-gutter


(setq key-chord-two-keys-delay 0.08) ; default 0.1
(setq key-chord-one-key-delay 0.15) ; default 0.2

(key-chord-define-global "xx" 'helm-M-x)
(key-chord-define-global " 3" 'split-window-right)
(key-chord-define-global " 2" 'split-window-below)
(key-chord-define-global " 0" 'delete-window)
(key-chord-define-global "dd" 'duplicate-thing)
(key-chord-define-global " p" 'helm-projectile-switch-project)
(key-chord-define-global " f" 'helm-projectile-find-file)
(key-chord-define-global "gg" 'magit-status)

;; scroll
(setq mouse-wheel-scroll-amount '(1))
(setq mouse-wheel-progressive-speed nil)

(provide 'settings)
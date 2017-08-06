;;; config.el --- custom over prelude
;;; Commentary:
;;; Foo
;;; Code:

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
 projectile-completion-system 'grizzl            ; Projectile completion system
 uniquify-buffer-name-style 'forward             ; Uniquify buffer names
 linum-format " %d "
 js-indent-level 2
 )

(global-subword-mode 1)                          ; Iterate through CamelCase words
(line-number-mode 1)                             ; Show the line number
(set-frame-parameter nil 'fullscreen 'fullboth)  ; Set fullscreen at startup
(set-scroll-bar-mode nil)                        ; Hide scrollbars
(global-diff-hl-mode 0)                          ; Disable diff-hl since we use git-gutter

;; Themes and colors
(defvar me/font-family            "Operator Mono"      "The font to use.")
(defvar me/font-size-default      140                  "The font size to use for default text.")
(defvar me/font-size-header       160                  "The font size to use for headers.")
(defvar me/font-size-mode-line    140                  "The font size to use for the mode line.")

;; For isolate package configuration, uses use-package
;; https://github.com/jwiegley/use-package

(prelude-require-packages '(use-package))
(eval-when-compile
  (require 'use-package)
  (setq-default
   use-package-always-defer t
   use-package-always-ensure t))

(defvar me/theme 'sanityinc-tomorrow-night)
(defvar me/theme-scheme 'night)

(defun get-theme-color (color)
  (assoc-default color (assoc me/theme-scheme color-theme-sanityinc-tomorrow-colors)))

;; Packages

;; Load the theme
(use-package color-theme-sanityinc-tomorrow
  :init
  (disable-theme 'zenburn)
  (load-theme me/theme t)
  :config
  ;; set font
  (when (member me/font-family (font-family-list))
    (set-face-attribute 'default nil :font me/font-family :height me/font-size-default))
  ;; set mode-line
  (set-face-attribute 'mode-line nil
                      :box `(:line-width 10 :color , (get-theme-color 'current-line))
                      :background (get-theme-color 'current-line)))

;; Multiple cursors, like sublime ;)
(use-package multiple-cursors
  :bind
  (("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("C-S-c C-S-c" . mc/edit-lines)
   ("C-S-<mouse-1>" . mc/add-cursor-on-click)
   ("C-' . mc-hide-unmatched-lines"))
  :init
  (setq mc/list-file "~/.emacs.d/personal/mc-lists.el"))

;; Jump through symbols
(use-package dumb-jump
  :ensure t
  :bind
  (("C-M-g" . dumb-jump-go)
   ("C-M-p" . dumb-jump-back)))

;; Highlight symbols
(use-package highlight-thing
  :init
  (add-hook 'prog-mode-hook 'highlight-thing-mode)
  :config
  (setq
   highlight-thing-delay-seconds 1
   highlight-thing-limit-to-defun t
   highlight-thing-case-sensitive-p t)
  (set-face-attribute 'highlight-thing nil
                      :inherit nil
                      :underline (get-theme-color 'yellow)))

;; DeMinifies and pretiffies js/css/html files
(use-package web-beautify
  :ensure t
  :commands (web-beautify-css
             web-beautify-css-buffer
             web-beautify-html
             web-beautify-html-buffer
             web-beautify-js
             web-beautify-js-buffer))

;; Move lines across the buffer
(use-package move-text
  :config (move-text-default-bindings))

;; Neotree
(use-package all-the-icons)
(use-package neotree
  :config
  (setq-default
   neo-window-fixed-size nil
   neo-show-hidden-files t
   neo-persist-show nil
   neo-vc-integration '(face)
   neo-theme 'nerd))

;; Helm everywhere
(use-package helm
  :no-require t
  :init (require 'prelude-helm-everywhere)
  :delight helm-mode "⇥"
  :config
  (setq-default
   helm-M-x-fuzzy-match t
   helm-buffers-fuzzy-matching t
   helm-recentf-fuzzy-match t)
  (helm-mode t))

;; Web-mode configuration
(use-package web-mode
  :no-require t
  :init
  (progn
    (setq web-mode-script-padding 2)
    (setq web-mode-style-padding 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-markup-indent-offset 2)))

;; Gutter diff changes with live update
(use-package git-gutter
  :ensure t
  :init
  (global-git-gutter-mode t)
  :config
  (progn
    (setq git-gutter:modified-sign " • ")
    (setq git-gutter:added-sign " + ")
    (setq git-gutter:deleted-sign " - ")))

;; Customize minor modes mode-line
(use-package delight
  :config
  (defadvice powerline-major-mode (around delight-powerline-major-mode activate)
    (let ((inhibit-mode-name-delight nil)) ad-do-it))
  (defadvice powerline-minor-modes (around delight-powerline-minor-modes activate)
    (let ((inhibit-mode-name-delight nil)) ad-do-it)))

;; Show indent guide
(use-package indent-guide
  :init
  (indent-guide-global-mode)
  :config
  (setq indent-guide-char "|"))

;; Duplicate line
(use-package duplicate-thing :ensure t)

;; Utils

;; Show lines only on goto-line M-g g
;; http://whattheemacsd.com//key-bindings.el-01.html

(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))

;; Toggle fullscreen
(defun toggle-fullscreen ()
  "Toggle full screen."
  (interactive)
  (set-frame-parameter
   nil 'fullscreen
   (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

;; Extract Jira ticket number on magit commit buffer
(fset 'jira
      [?\C-s ?t ?r ?i ?b ?- return ?\C-  ?\C-e ?\M-w ?\C-x ?\[ ?\[ ?T ?R ?I ?B ?- ?\C-y ?\] ? ])

;; scroll
(setq mouse-wheel-scroll-amount '(1))
(setq mouse-wheel-progressive-speed nil)

;;; config.el ends here

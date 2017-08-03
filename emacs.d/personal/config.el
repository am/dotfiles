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
(defvar me/font-size-default      130                  "The font size to use for default text.")
(defvar me/font-size-header       150                  "The font size to use for headers.")
(defvar me/font-size-mode-line    130                  "The font size to use for the mode line.")

(defconst tomorrow/background    "#2d2d2d")
(defconst tomorrow/current-line  "#393939")
(defconst tomorrow/selection     "#515151")
(defconst tomorrow/foreground    "#cccccc")
(defconst tomorrow/comment       "#999999")
(defconst tomorrow/red           "#f2777a")
(defconst tomorrow/orange        "#f99157")
(defconst tomorrow/yellow        "#ffcc66")
(defconst tomorrow/green         "#99cc99")
(defconst tomorrow/aqua          "#66cccc")
(defconst tomorrow/blue          "#6699cc")
(defconst tomorrow/purple        "#cc99cc")

;; Color blending to background
(defconst tomorrow/red-db1       "#D16B6D")
(defconst tomorrow/red-db2       "#B05E60")
(defconst tomorrow/red-db3       "#905254")
(defconst tomorrow/red-db4       "#6F4647")
(defconst tomorrow/red-db5       "#4E393A")
(defconst tomorrow/green-db1       "#87B287")
(defconst tomorrow/green-db2       "#759775")
(defconst tomorrow/green-db3       "#637D63")
(defconst tomorrow/green-db4       "#516251")
(defconst tomorrow/green-db5       "#3F483F")
(defconst tomorrow/yellow-db1       "#DCB25D")
(defconst tomorrow/yellow-db2       "#B99753")
(defconst tomorrow/yellow-db3       "#967D4A")
(defconst tomorrow/yellow-db4       "#736240")
(defconst tomorrow/yellow-db5       "#504837")

;; For isolate package configuration, uses use-package
;; https://github.com/jwiegley/use-package

(prelude-require-packages '(use-package))
(eval-when-compile
  (require 'use-package)
  (setq-default
   use-package-always-defer t
   use-package-always-ensure t))

;; Packages

;; Load the theme
(use-package color-theme-sanityinc-tomorrow
  :init
  (load-theme 'sanityinc-tomorrow-eighties t)
  :config
  (when (member me/font-family (font-family-list))
    (set-face-attribute 'default nil :font me/font-family :height me/font-size-default))
  ;; Ediff colors
  (set-face-attribute 'ediff-odd-diff-A nil
                      :background tomorrow/selection
                      :foreground tomorrow/foreground
                      :inverse-video nil)
  (set-face-attribute 'ediff-odd-diff-B nil
                      :background tomorrow/selection
                      :foreground tomorrow/foreground
                      :inverse-video nil)
  (set-face-background 'ediff-odd-diff-C tomorrow/selection)
  (set-face-background 'ediff-current-diff-A tomorrow/red-db5)
  (set-face-background 'ediff-fine-diff-A tomorrow/red-db4)
  (set-face-underline 'ediff-fine-diff-A tomorrow/red)
  (set-face-background 'ediff-current-diff-B tomorrow/green-db5)
  (set-face-background 'ediff-fine-diff-B tomorrow/green-db4)
  (set-face-underline 'ediff-fine-diff-B tomorrow/green)
  (set-face-background 'ediff-current-diff-C tomorrow/yellow-db5)
  (set-face-background 'ediff-fine-diff-C tomorrow/yellow-db4)
  (set-face-background 'helm-visible-mark tomorrow/green)
  (set-face-foreground 'helm-visible-mark tomorrow/background)
  (set-face-attribute 'helm-header nil
                      :inherit 'unspecified
                      :foreground tomorrow/aqua
                      :background tomorrow/background
                      :box nil)
  (set-face-attribute 'js2-error nil :underline '(:color "#6D0900" :style wave)))

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
                      :underline tomorrow/red))

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
   neo-theme 'nerd)
  (set-face-foreground 'neo-root-dir-face tomorrow/orange)
  (set-face-foreground 'neo-dir-link-face tomorrow/blue)
  (set-face-foreground 'neo-expand-btn-face tomorrow/blue)
  (set-face-foreground 'neo-vc-added-face tomorrow/green)
  (set-face-foreground 'neo-vc-edited-face tomorrow/yellow)
  (set-face-foreground 'neo-vc-conflict-face tomorrow/red)
  )

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
    (setq git-gutter:deleted-sign " - "))
  (set-face-foreground 'git-gutter:modified tomorrow/aqua)
  (set-face-foreground 'git-gutter:added tomorrow/green)
  (set-face-foreground 'git-gutter:deleted tomorrow/red)
  )

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
  (setq indent-guide-char "|")
  (set-face-background 'indent-guide-face tomorrow/background)
  (set-face-foreground 'indent-guide-face tomorrow/current-line))

;; Duplicate line
(use-package duplicate-thing :ensure t)

;; Theming mode-line
(use-package spaceline :demand t)
(use-package spaceline-config
  :ensure nil
  :after spaceline

  :config

  ;; Configure the mode-line
  (setq-default
   mode-line-format '("%e" (:eval (spaceline-ml-main)))
   powerline-default-separator 'slant
   powerline-height 22
   spaceline-highlight-face-func 'spaceline-highlight-face-modified
   spaceline-flycheck-bullet "• %s"
   spaceline-separator-dir-left '(left . left)
   spaceline-separator-dir-right '(right . right))
  (spaceline-helm-mode)

  ;; Build the segments
  (spaceline-define-segment me/helm-follow
    (when (and (bound-and-true-p helm-alive-p)
               spaceline--helm-current-source
               (eq 1 (cdr (assq 'follow spaceline--helm-current-source))))
      (propertize "" 'face 'success)))

  ;; Build the mode-lines
  (spaceline-install
   `((major-mode :face highlight-face)
     ((remote-host buffer-id line) :separator ":")
     anzu)
   `((selection-info)
     ((flycheck-error flycheck-warning flycheck-info) :when active)
     ((projectile-root version-control) :separator "  ")
     (hud)
     (global :face highlight-face)))
  (spaceline-install
   'helm
   '((helm-buffer-id :face spaceline-read-only)
     helm-number
     (me/helm-follow :fallback "")
     helm-prefix-argument)
   '((helm-help :face spaceline-read-only)))

  ;; Customize the mode-line
  (set-face-attribute 'mode-line nil
                      :box `(:line-width 1 :color ,tomorrow/selection)
                      :foreground tomorrow/comment
                      :height me/font-size-mode-line)
  (set-face-attribute 'mode-line-inactive nil
                      :box `(:line-width 1 :color ,tomorrow/selection)
                      :foreground tomorrow/comment
                      :height me/font-size-mode-line)
  (set-face-attribute 'powerline-active2 nil :background tomorrow/background)
  (set-face-attribute 'powerline-inactive2 nil :background tomorrow/background)
  (set-face-attribute 'spaceline-flycheck-error nil :foreground tomorrow/red)
  (set-face-attribute 'spaceline-flycheck-info nil :foreground tomorrow/blue)
  (set-face-attribute 'spaceline-flycheck-warning nil :foreground tomorrow/orange)
  (set-face-attribute 'spaceline-modified nil
                      :background tomorrow/red :foreground tomorrow/yellow)
  (set-face-attribute 'spaceline-read-only nil
                      :background tomorrow/blue :foreground tomorrow/foreground)
  (set-face-attribute 'spaceline-unmodified nil
                      :background tomorrow/green :foreground tomorrow/current-line))

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

;;; config.el ends here

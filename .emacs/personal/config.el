;;; config.el --- custom over prelude
;;; Commentary:
;;; Code:
;; keys
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)

;; projectile
(setq projectile-completion-system 'grizzl)

;; indent-guide
(require 'indent-guide)

;; git-gutter
(require 'git-gutter-fringe+)
(set-face-foreground 'git-gutter-fr+-modified "yellow")
(set-face-foreground 'git-gutter-fr+-added    "blue")
(set-face-foreground 'git-gutter-fr+-deleted  "white")

;; autosave location
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq create-lockfiles nil)

;; projectile
(setq projectile-switch-project-action 'projectile-dired)

;; ui
;; disable zenburn
(disable-theme 'zenburn)
(load-theme 'afternoon t)
(setq-default line-spacing 3)

;; start maximized
;; (toggle-frame-fullscreen)
(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
   nil
   'fullscreen (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

;; indent-guide
(indent-guide-global-mode)

;; disable scrollbars
(set-scroll-bar-mode nil)

;; highlight current line color
(global-hl-line-mode 1)

(global-linum-mode)
(setq linum-format "%3d ")
(setq show-trailing-whitespace t)

;; coffee
(custom-set-variables '(coffee-tab-width 2))

(setq js-indent-level 2)

;; json-mode set indent level to 2
(add-hook 'json-mode-hook
          (lambda ()
            (make-variable-buffer-local 'js-indent-level)
            (setq js-indent-level 2)))

;; multiple-cursors
(require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

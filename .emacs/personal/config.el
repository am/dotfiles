;;; config.el --- custom over prelude
;;; Commentary:
;;; Code:
;; keys
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)

;; projectile
(setq projectile-completion-system 'grizzl)

;; helm
(require 'prelude-helm-everywhere)
(setq helm-M-x-fuzzy-match t)
(setq helm-buffers-fuzzy-matching t)
(setq helm-mode t)
(setq helm-recentf-fuzzy-match t)

;; key-chord
(require 'prelude-key-chord)
(key-chord-mode 1)

;; indent-guide
(require 'indent-guide)

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

;; tab-width 2
(setq coffee-tab-width 2)
(setq js-indent-level 2)
(add-hook 'json-mode-hook
          (lambda ()
            (make-variable-buffer-local 'js-indent-level)
            (setq js-indent-level 2)))
(setq js2-basic-offset 2)
(setq json-reformat:indent-width 2)

;; multiple-cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; neotree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-show-hidden-files t)
(setq neo-theme (quote nerd))
(setq neo-vc-integration (quote (face char)))
(setq neo-window-width 30)
(setq neo-persist-show nil)

;; expand region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; macros
(fset 'jira
      [?\C-s ?t ?r ?i ?b ?- return ?\C-  ?\C-e ?\M-w ?\C-x ?\[ ?\[ ?T ?R ?I ?B ?- ?\C-y ?\] ? ])

;; move-lines
(add-to-list 'load-path "~/.emacs.d/personal/modules/")
(require 'move-lines)
(move-lines-binding)

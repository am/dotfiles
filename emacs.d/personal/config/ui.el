;; Themes and colors
(defvar me/font-family            "Operator Mono"      "The font to use.")
(defvar me/font-size-default      140                  "The font size to use for default text.")
(defvar me/font-size-header       160                  "The font size to use for headers.")
(defvar me/font-size-mode-line    140                  "The font size to use for the mode line.")

(defvar me/theme 'sanityinc-tomorrow-night)
(defvar me/theme-scheme 'night)

(defun get-theme-color (color)
  (assoc-default color (assoc me/theme-scheme color-theme-sanityinc-tomorrow-colors)))

(use-package all-the-icons)

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

(provide 'ui)

;; DeMinifies and pretiffies js/css/html files
(use-package web-beautify
  :ensure t
  :commands (web-beautify-css
             web-beautify-css-buffer
             web-beautify-html
             web-beautify-html-buffer
             web-beautify-js
             web-beautify-js-buffer))

;; emmet
(use-package emmet-mode
  :ensure t
  :config
  (setq emmet-expand-jsx-className? t)
  :bind
  (("C-j" . emmet-expand-line)))

;; Move lines across the buffer
(use-package move-text
  :bind
  (("M-s-p" . move-text-up)
   ("M-s-n" . move-text-down)))

;; Multiple cursors, like sublime ;)
(use-package multiple-cursors
  :bind
  (("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("C-S-c C-S-c" . mc/edit-lines)
   ("C-S-<mouse-1>" . mc/add-cursor-on-click)
   ("C-'" . mc-hide-unmatched-lines))
  :init
  (setq mc/list-file "~/.emacs.d/personal/mc-lists.el")
  :chords
  ((">>" . mc/mark-next-like-this)
   ("<<" . mc/mark-previous-like-this)))

(use-package duplicate-thing
  :ensure t
  :chords
  ((" d" . duplicate-thing)))

(provide 'transform)

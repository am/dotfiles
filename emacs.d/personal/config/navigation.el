;; Jump through symbols
(use-package dumb-jump
  :ensure t
  :bind
  (("C-M-g" . dumb-jump-go)
   ("C-M-p" . dumb-jump-back)))

;; Neotree
(use-package neotree
  :config
  (setq-default
   neo-window-fixed-size nil
   neo-show-hidden-files t
   neo-persist-show nil
   neo-vc-integration '(face)
   neo-theme 'nerd)
  :chords
  (("]]" . neotree-show)
   ("[[" . neotree-hide)))

(provide 'navigation)

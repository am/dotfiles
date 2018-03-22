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

(use-package swiper
  :ensure t
  :init
  (global-set-key (kbd "C-s") nil)
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  :bind
  (("C-s" . swiper)))

(use-package nlinum
  :ensure t
  :config (add-hook 'prog-mode-hook '(lambda () (nlinum-mode t))))

(provide 'navigation)

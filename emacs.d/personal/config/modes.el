;; Web-mode configuration
(use-package web-mode
  :no-require t
  :init
  (progn
    (setq web-mode-script-padding 2)
    (setq web-mode-style-padding 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-markup-indent-offset 2)))

;; rjsx
(use-package rjsx-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode)))

(use-package json-mode
  :no-require t
  :init
  (message "config for json-mode")
  (defun my/json-mode-hook ()
    (lambda ()
      (make-local-variable 'js-indent-level)
      (setq js-indent-level 2))
    )
  (add-hook 'json-mode-hook 'my/json-mode-hook))

(use-package emojify
  :init (add-hook 'after-init-hook #'global-emojify-mode))

(use-package helm-projectile
  :ensure    helm-projectile
  :init
  (helm-projectile-on)
  :config
  (progn
    (setq projectile-switch-project-action 'projectile-vc)
    (setq projectile-completion-system 'helm)))

(provide 'modes)

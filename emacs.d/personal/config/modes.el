;; Web-mode configuration
(use-package web-mode
  :no-require t
  :init
  (progn
    (setq web-mode-script-padding 2)
    (setq web-mode-style-padding 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-markup-indent-offset 2)))

(use-package zencoding-mode
  :ensure t
  :init
  (add-hook 'sgml-mode-hook 'zencoding-mode))

(use-package company
  :init
  (setq company-dabbrev-ignore-case t
        company-dabbrev-downcase nil)
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  ;; (use-package company-tern
  ;;   :init (add-to-list 'company-backends 'company-tern))
  )

(use-package js2-mode
  :config
  ;; (use-package tern
  ;;   :init
  ;;   (add-hook 'js2-mode-hook 'tern-mode))
  (use-package js2-refactor
    :init
    (add-hook 'js2-mode-hook #'js2-refactor-mode))
  (use-package xref-js2
    :init
    (define-key js-mode-map (kbd "M-.") nil)
    (add-hook 'js2-mode-hook (lambda ()
                               (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))))

;; (use-package tern
;;   :config (add-hook 'js-mode-hook (lambda () (tern-mode t))))

(use-package vue-mode
  :ensure t
  :config
  (add-to-list 'vue-mode-hook 'smartparens-mode)
  ;; remove www background color
  (setq mmm-submode-decoration-level 0))

(use-package add-node-modules-path :ensure t)

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

;; (use-package magithub
;;   :after magit
;;   :config (magithub-feature-autoinject t))

(use-package dtrt-indent
  :ensure t)

(use-package magit-gh-pulls
  :after magit
  :config
  (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls))

(provide 'modes)

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

(provide 'modes)

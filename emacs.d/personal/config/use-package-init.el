;; For isolate package configuration, uses use-package
;; https://github.com/jwiegley/use-package

(prelude-require-packages '(use-package))
(eval-when-compile
  (require 'use-package)
  (use-package use-package-chords
    :config (key-chord-mode 1))
  (setq-default
   use-package-always-defer t
   use-package-always-ensure t))

(provide 'use-package-init)

;;; config.el --- custom over prelude
;;; Commentary:
;;; Foo
;;; Code:

(push "~/.emacs.d/personal/config/" load-path)

(require 'settings)
(require 'use-package-init)
(require 'navigation)
(require 'transform)
(require 'modes)
(require 'ui)

;;; config.el ends here

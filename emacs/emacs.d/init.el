(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)


(load "~/.emacs.d/functions.el")
;;(load "~/.emacs.d/helm.el")
(load "~/.emacs.d/ivy.el")
(load "~/.emacs.d/keymap.el")

(setq packages '(coffee-mode json-mode json-reformat haml-mode yaml-mode rspec-mode inf-ruby magit gruvbox-theme idea-darkula-theme darktooth-theme cider))
(apply #'ensure-package-installed packages)

(delete-selection-mode 1)
(setq visible-bell 1)
(defalias 'yes-or-no-p 'y-or-n-p)
(show-paren-mode t)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))

;; desert, gruvbox, idea-darkula, darktooth
(load-theme 'gruvbox t)
(enable-theme 'gruvbox)

(menu-bar-mode -1)
(global-auto-revert-mode t)
(setq wdired-allow-to-change-permissions "t")
;;(setq linum-format "%3d \u2503 ")
(setq linum-format "%3d ")
;;(global-linum-mode t)

(add-hook 'after-init-hook 'inf-ruby-switch-setup)

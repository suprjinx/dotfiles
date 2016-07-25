(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)


(load "~/.emacs.d/functions.el")
;;(load "~/.emacs.d/helm.el")
(load "~/.emacs.d/ivy.el")
(load "~/.emacs.d/keymap.el")

(setq packages '(coffee-mode json-mode json-reformat haml-mode yaml-mode rspec-mode crux magit gruvbox-theme idea-darkula-theme darktooth-theme))
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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d09467d742f713443c7699a546c0300db1a75fed347e09e3f178ab2f3aa2c617" "57d7e8b7b7e0a22dc07357f0c30d18b33ffcbb7bcd9013ab2c9f70748cfa4838" "badc4f9ae3ee82a5ca711f3fd48c3f49ebe20e6303bba1912d4e2d19dd60ec98" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

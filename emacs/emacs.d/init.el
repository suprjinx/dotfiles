(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)


(load "~/.emacs.d/functions.el")
(load "~/.emacs.d/packages.el")
(load "~/.emacs.d/keymap.el")
;;(load "~/.emacs.d/helm.el")
(load "~/.emacs.d/ivy.el")

;; (setq packages '(coffee-mode json-mode json-reformat haml-mode yaml-mode rspec-mode inf-ruby ruby-tools magit gruvbox-theme idea-darkula-theme darktooth-theme cider ag restclient))
;; (apply #'ensure-package-installed packages)

(delete-selection-mode 1)
(setq visible-bell 1)
(defalias 'yes-or-no-p 'y-or-n-p)
(show-paren-mode t)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))

;; desert, gruvbox, idea-darkula, darktooth, railscasts
(load-theme 'railscasts t)
(enable-theme 'railscasts)

(menu-bar-mode -1)
(global-auto-revert-mode t)
(setq wdired-allow-to-change-permissions "t")
;;(setq linum-format "%3d \u2503 ")
(setq linum-format "%3d ")
(setq column-number-mode t)
;; more readable :)
(when (display-graphic-p)
  (set-frame-font "Monaco 14" nil t)
  (menu-bar-mode 1))
;;(global-linum-mode t)

(add-hook 'after-init-hook 'inf-ruby-switch-setup)
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Reverse colors for the border to have nicer line
(set-face-inverse-video-p 'vertical-border nil)
(set-face-background 'vertical-border (face-background 'default))

;; Set symbol for the border
(set-display-table-slot standard-display-table
			'vertical-border
			(make-glyph-code ?┃))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (railscasts-reloaded-theme railscasts-theme markdown-mode markdown-preview-mode amx slime rainbow-blocks tango-dark restclient yasnippet yaml-mode swiper-helm ruby-electric rspec-mode powerline paredit neotree monokai-theme magit leuven-theme json-mode inf-ruby idea-darkula-theme hydandata-light-theme haml-mode gruvbox-theme git-gutter flx-ido diff-hl darktooth-theme crux counsel-projectile coffee-mode cider ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)

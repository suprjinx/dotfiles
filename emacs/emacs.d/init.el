(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)


(load "~/.emacs.d/functions.el")
(load "~/.emacs.d/packages.el")
(load "~/.emacs.d/keymap.el")
;;(load "~/.emacs.d/helm.el")
(load "~/.emacs.d/ivy.el")
(load "~/.emacs.d/org.el")

;; (setq packages '(coffee-mode json-mode json-reformat haml-mode yaml-mode rspec-mode inf-ruby ruby-tools magit gruvbox-theme idea-darkula-theme darktooth-theme cider ag restclient))
;; (apply #'ensure-package-installed packages)

(delete-selection-mode 1)
(setq visible-bell 1)
(defalias 'yes-or-no-p 'y-or-n-p)
(show-paren-mode t)

(setq ring-bell-function 'ignore)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))
(setq js-indent-level 2)

(setq rg-group-result 1)

;; desert, gruvbox, idea-darkula, darktooth, railscasts
(load-theme 'railscasts t)
(enable-theme 'railscasts)

(menu-bar-mode -1)
(global-auto-revert-mode t)
(global-hl-line-mode 1)

(setq wdired-allow-to-change-permissions "t")
;;(setq linum-format "%3d \u2503 ")
(setq linum-format "%3d ")
(setq column-number-mode t)
;; more readable :)
(when (display-graphic-p)
  (set-frame-font "Monaco 14" nil t)
  (menu-bar-mode 1)
  ;; Set Frame width/height
  (setq default-frame-alist
        '((width . 160) (height . 48)))
  )
;;(global-linum-mode t)

(add-hook 'after-init-hook 'inf-ruby-switch-setup)

;; Reverse colors for the border to have nicer line
(set-face-inverse-video-p 'vertical-border nil)
(set-face-background 'vertical-border (face-background 'default))

;; Set symbol for the border
(set-display-table-slot standard-display-table
			'vertical-border
			(make-glyph-code ?┃))

(setq abbrev-file-name
      "~/.emacs.d/abbrev_defs") 
(setq save-abbrevs t)
(setq-default abbrev-mode t)
(setq rspec-use-docker-when-possible t)
(setq rspec-docker-command "docker-compose exec")
;;  (setq rspec-docker-container "web")
(custom-set-variables '(coffee-tab-width 2))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (docker docker-tramp wgrep-ag railscasts-reloaded-theme railscasts-theme markdown-mode markdown-preview-mode amx slime rainbow-blocks tango-dark restclient yasnippet yaml-mode swiper-helm ruby-electric rspec-mode powerline paredit neotree monokai-theme magit leuven-theme json-mode inf-ruby idea-darkula-theme hydandata-light-theme haml-mode gruvbox-theme git-gutter flx-ido diff-hl darktooth-theme crux counsel-projectile coffee-mode cider ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)

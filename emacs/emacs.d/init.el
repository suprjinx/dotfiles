
(package-initialize)

(load "~/.emacs.d/packages.el")
(load "~/.emacs.d/functions.el")
(load "~/.emacs.d/keymap.el")
;;(load "~/.emacs.d/helm.el")
;;(load "~/.emacs.d/ivy.el")
(load "~/.emacs.d/vertico.el")
(load "~/.emacs.d/org.el")
;;(load "~/.emacs.d/sunrise-commander.el")


(delete-selection-mode 1)
(setq visible-bell 1)
(defalias 'yes-or-no-p 'y-or-n-p)
(show-paren-mode t)
(normal-erase-is-backspace-mode 0)

(setq ring-bell-function 'ignore)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))
(setq js-indent-level 2)

(setq rg-group-result 1)

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; desert, gruvbox, idea-darkula, darktooth, railscasts, moe-theme
(load-theme 'gruvbox t)
(enable-theme 'gruvbox)

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
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  ;; Set Frame width/height
  (setq default-frame-alist
        '((width . 160) (height . 48)))
  )

(when (eq system-type 'darwin)
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil))

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
(setq rspec-docker-container "main_http")

;; Company mode
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)

;; Go mode
(add-hook 'go-mode-hook 'go-mode-setup)
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(coffee-tab-width 2)
 '(custom-safe-themes
   '("046a2b81d13afddae309930ef85d458c4f5d278a69448e5a5261a5c78598e012"
     "573182354a59c672f89b8a7ea98ef020a54ff3fc93cf67bbfae4aa5bd41fdd5d"
     "43cf3d1a792bfc1fb1965c36561327c8b59ac76760eeec621ce24b74136ec751"
     "7b8f5bbdc7c316ee62f271acf6bcd0e0b8a272fdffe908f8c920b0ba34871d98"
     "b89ae2d35d2e18e4286c8be8aaecb41022c1a306070f64a66fd114310ade88aa"
     "5a04c3d580e08f5fc8b3ead2ed66e2f0e5d93643542eec414f0836b971806ba9"
     "bf4b3dbc59b2b0873bd74ebf8f3a8c13d70dc3d36a4724b27edb1e427f047c1e"
     "939ea070fb0141cd035608b2baabc4bd50d8ecc86af8528df9d41f4d83664c6a"
     "4cf9ed30ea575fb0ca3cff6ef34b1b87192965245776afa9e9e20c17d115f3fb"
     "aded61687237d1dff6325edb492bde536f40b048eab7246c61d5c6643c696b7f"
     default))
 '(highlight-indent-guides-character 124)
 '(package-selected-packages nil)
 '(pdf-view-midnight-colors '("#FDF4C1" . "#282828"))
 '(pos-tip-background-color "#36473A")
 '(pos-tip-foreground-color "#FFFFC8"))



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

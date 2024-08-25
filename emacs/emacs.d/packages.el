(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.org/packages/"))

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; packages
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(use-package go-mode :defer t :ensure t)
(use-package gotest :defer t :ensure t)
(use-package company :defer t :ensure t)
(use-package yasnippet :defer t :ensure t)
(use-package docker :defer t :ensure t)
(use-package json-mode :defer t :ensure t)
(use-package json-reformat :defer t :ensure t)
(use-package haml-mode :defer t :ensure t)
(use-package yaml-mode :defer t :ensure t)
(use-package markdown-mode :defer t :ensure t)
(use-package org-bullets :defer t :ensure t)
(use-package rspec-mode :defer t :ensure t)
(use-package inf-ruby :defer t :ensure t)
(use-package ruby-tools :defer t :ensure t)
(use-package smartparens :defer t :ensure t)
(use-package magit :defer t :ensure t)
(use-package ag :defer t :ensure t)
(use-package rg :defer t :ensure t)
(use-package wgrep :defer t :ensure t)
(use-package wgrep-ag :defer t :ensure t)
(use-package restclient :defer t :ensure t)
(use-package ansi-color :defer t :ensure t)
(use-package org-bullets :defer t :ensure t)
(use-package dired-narrow :defer t :ensure t)
(use-package dired-quick-sort :defer t :ensure t :config (dired-quick-sort-setup))
(use-package chatgpt-shell
  :ensure t
  :custom
  ((chatgpt-shell-openai-key
    (lambda ()
      (auth-source-pass-get 'secret "KEYHERE")))))

(use-package gruvbox-theme :defer t :ensure t)
(use-package idea-darkula-theme :defer t :ensure t)
(use-package darktooth-theme :defer t :ensure t)
(use-package railscasts-theme :defer t :ensure t)
(use-package moe-theme :defer t :ensure t)
(use-package kubel
  :after (vterm)
  :config (kubel-vterm-setup))

;; eglot lsp
;; (use-package eglot
;;   :defer t
;;   :ensure t)

;; (add-hook 'go-mode-hook 'eglot-ensure)

;; lsp-mode
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-go-env '((GOFLAGS . "-tags=integration")))
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (go-mode . lsp)
	 (python-mode . lsp)
	 (ruby-mode . lsp)
         ;; if you want which-key integration
         ;; (lsp-mode . lsp-enable-which-key-integration)
	 )
  :commands lsp)

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred))))

;; optionally
;; (use-package lsp-ui :commands lsp-ui-mode)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
;; (use-package which-key
;;    :config
;;    (which-key-mode))

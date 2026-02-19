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
(use-package restclient
  :ensure t
  :mode ("\\.http\\'" . restclient-mode))
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
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-go-env '((GOFLAGS . "-tags=integration")))
  (setq lsp-gopls-server-args '("-remote=auto" "-remote.listen.timeout=1h"))
  :hook ((go-mode . lsp-deferred)
         (python-mode . lsp-deferred)
         (ruby-mode . lsp-deferred))
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-peek-enable nil))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright))))

(use-package lsp-treemacs :ensure t :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
;; (use-package which-key
;;    :config
;;    (which-key-mode))

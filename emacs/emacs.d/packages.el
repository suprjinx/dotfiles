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

(use-package auto-complete :defer t :ensure t)
(use-package go-complete :defer t :ensure t)
(use-package go-eldoc :defer t :ensure t)
(use-package go-errcheck :defer t :ensure t)
(use-package go-mode :defer t :ensure t)
(use-package gotest :defer t :ensure t)
(use-package lsp-mode :defer t :ensure t)
(use-package company :defer t :ensure t)
(use-package docker :defer t :ensure t)
(use-package docker-tramp :defer t :ensure t)
(use-package coffee-mode :defer t :ensure t)
(use-package json-mode :defer t :ensure t)
(use-package json-reformat :defer t :ensure t)
(use-package haml-mode :defer t :ensure t)
(use-package yaml-mode :defer t :ensure t)
(use-package markdown-mode :defer t :ensure t)
(use-package rspec-mode :defer t :ensure t)
(use-package inf-ruby :defer t :ensure t)
(use-package ruby-tools :defer t :ensure t)
(use-package smartparens :defer t :ensure t)
(use-package magit :defer t :ensure t)
(use-package cider :defer t :ensure t)
(use-package ag :defer t :ensure t)
(use-package rg :defer t :ensure t)
(use-package wgrep :defer t :ensure t)
(use-package wgrep-ag :defer t :ensure t)
(use-package restclient :defer t :ensure t)
(use-package ansi-color :defer t :ensure t)
(use-package org-bullets :defer t :ensure t)
(use-package dired-narrow :defer t :ensure t)
(use-package dired-quick-sort :defer t :ensure t :config (dired-quick-sort-setup))

(use-package gruvbox-theme :defer t :ensure t)
(use-package idea-darkula-theme :defer t :ensure t)
(use-package darktooth-theme :defer t :ensure t)
(use-package railscasts-theme :defer t :ensure t)
(use-package moe-theme :defer t :ensure t)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; packages
(use-package coffee-mode)
(use-package json-mode)
(use-package json-reformat)
(use-package haml-mode)
(use-package yaml-mode)
(use-package rspec-mode)
(use-package inf-ruby)
(use-package ruby-tools)
(use-package magit)
(use-package cider)
(use-package ag )
(use-package restclient)

(use-package gruvbox-theme)
(use-package idea-darkula-theme)
(use-package darktooth-theme)

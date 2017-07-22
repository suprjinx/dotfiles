;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; packages
(use-package coffee-mode :defer t :ensure t)
(use-package json-mode :defer t :ensure t)
(use-package json-reformat :defer t :ensure t)
(use-package haml-mode :defer t :ensure t)
(use-package yaml-mode :defer t :ensure t)
(use-package rspec-mode :defer t :ensure t)
(use-package inf-ruby :defer t :ensure t)
(use-package ruby-tools :defer t :ensure t)
(use-package magit :defer t :ensure t)
(use-package cider :defer t :ensure t)
(use-package ag  :defer t :ensure t)
(use-package restclient :defer t :ensure t)

(use-package gruvbox-theme :defer t :ensure t)
(use-package idea-darkula-theme :defer t :ensure t)
(use-package darktooth-theme :defer t :ensure t)

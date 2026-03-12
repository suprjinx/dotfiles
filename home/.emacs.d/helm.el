(use-package helm :defer t :ensure t)
(use-package projectile :defer t :ensure t)
(use-package helm-projectile :defer t :ensure t)

(projectile-global-mode)
(helm-mode 1)
(setq projectile-completion-system 'helm)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-d") 'helm-browse-project)
(global-set-key (kbd "M-p") 'projectile-find-file)

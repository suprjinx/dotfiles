;; Vertico: Minimal vertical completion UI (ivy replacement)
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :config
  ;; Match ivy's height of 10 candidates
  (setq vertico-count 10)
  ;; Don't resize, keep consistent like ivy
  (setq vertico-resize nil)
  ;; Enable cycling like ivy
  (setq vertico-cycle t)
  ;; Different scroll margin
  (setq vertico-scroll-margin 0)

  ;; Swiper-like M-q query-replace from consult-line
  (defvar consult-line--replace-search nil)
  (defun consult-line-query-replace ()
    "Exit consult-line and start `query-replace' with the current search string."
    (interactive)
    (setq consult-line--replace-search (minibuffer-contents-no-properties))
    (run-at-time 0.1 nil
                 (lambda ()
                   (when consult-line--replace-search
                     (let ((search consult-line--replace-search))
                       (setq consult-line--replace-search nil)
                       (query-replace search
                                      (read-string (format "Replace \"%s\" with: " search)))))))
    (abort-recursive-edit))
  (define-key vertico-map (kbd "M-q") #'consult-line-query-replace))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations for Vertico
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;; Set up completion styles - orderless if available, otherwise built-in
(condition-case nil
    (progn
      (require 'orderless)
      (setq completion-styles '(orderless basic)
            completion-category-defaults nil
            completion-category-overrides '((file (styles partial-completion))))
      (setq orderless-matching-styles '(orderless-literal orderless-regexp)))
  (error
   ;; Fallback to built-in completion styles if orderless is not available
   (message "Orderless not available, using built-in completion styles")
   (setq completion-styles '(substring partial-completion flex basic)
         completion-category-defaults nil
         completion-category-overrides '((file (styles partial-completion))))))

;; Prescient: Smart sorting and filtering
(use-package prescient
  :ensure t)

;; Vertico-prescient integration
(use-package vertico-prescient
  :ensure t
  :after vertico prescient
  :config
  (vertico-prescient-mode +1))

;; Marginalia: Rich annotations in the minibuffer (like ivy's display transformers)
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode)
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle)))

;; Embark: Contextual actions (like ivy/counsel actions)
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none))))

)

;; Consult-embark integration
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; Enable virtual buffers (recentf integration) like ivy
(use-package recentf
  :config
  (recentf-mode 1)
  (setq recentf-max-menu-items 100)
  (setq recentf-max-saved-items 100))

;; Consult configuration (counsel replacement) with ivy-like keybindings
(use-package consult :defer t :ensure t
  ;; Replace bindings to match ivy/counsel configuration
  :bind (;; Global bindings matching ivy/counsel
         ("C-s" . consult-line)                    ;; swiper replacement
         ("C-x f" . consult-git-grep)              ;; counsel-git replacement
         ("C-x C-f" . find-file)                   ;; Keep default find-file (vertico enhances it)
         ("<f1> f" . describe-function)            ;; counsel-describe-function replacement
         ("<f1> v" . describe-variable)            ;; counsel-describe-variable replacement
         ("<f1> l" . consult-library)              ;; counsel-load-library replacement
         ("<f2> i" . consult-info)                 ;; counsel-info-lookup-symbol replacement
         ("<f2> u" . insert-char)                  ;; counsel-unicode-char replacement
         ("C-c g" . consult-git-grep)              ;; counsel-git replacement
         ("C-c j" . consult-git-grep)              ;; counsel-git-grep
         ("C-c C-j" . consult-git-grep)            ;; counsel-git-grep
         ("C-c k" . consult-ripgrep)               ;; counsel-ag replacement (using ripgrep)
         ("C-x l" . consult-locate)                ;; counsel-locate replacement
         
         ;; Additional useful consult bindings
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c b" . consult-bookmark)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complet-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-project-imenu)
         ;; M-s bindings (search-map)
         ("M-s f" . consult-find)
         ("M-s L" . consult-locate)
         ("M-s g" . consult-grep)
         ("C-c s" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch)
         :map isearch-mode-map
         ("M-e" . consult-isearch)                 ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch)               ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; required by consult-line to detect isearch
         :map read-expression-map
         ("C-r" . consult-history))                ;; counsel-expression-history replacement

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Enable virtual buffers (show recent files like ivy-use-virtual-buffers)
  ;; This makes consult-buffer show recent files like ivy does
  (setq consult-buffer-sources
        '(consult--source-hidden-buffer
          consult--source-modified-buffer
          consult--source-buffer
          consult--source-recent-file  ;; Virtual buffers from recentf
          consult--source-file-register
          consult--source-bookmark
          consult--source-project-buffer-hidden
          consult--source-project-recent-file))

  ;; Configure consult-line to behave like swiper
  ;; Show line numbers in consult-line like swiper does
  (setq consult-line-numbers-widen t)
  (setq consult-add-history t)
  (setq consult-line-start-from-top nil)
  
  ;; Configure preview for swiper-like behavior - immediate preview as you type
  (setq consult-preview-key 'any)  ;; Preview on any key press, like swiper
  
  ;; Make consult-line more swiper-like with better defaults
  (consult-customize
   consult-line :prompt "Swiper: "
   :preview-key 'any
   :initial (thing-at-point 'symbol))
  
  ;; Customize the display of line numbers in consult-line to match swiper
  (setq consult-fontify-preserve nil)
  (setq consult-line-point-placement 'match-beginning)
  
  ;; Optional: Add highlighting to the current line in consult-line previews
  ;; This makes it behave more like swiper's line highlighting
  (add-hook 'consult-after-jump-hook 
            (lambda () (pulse-momentary-highlight-one-line (point))))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; Probably not needed if you are using which-key.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; Optionally configure a function which returns the project root directory.
  ;; There are multiple reasonable alternatives to chose from:
  ;; * projectile-project-root
  ;; * vc-root-dir
  ;; * project-roots
  ;; * locate-dominating-file
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-root-function #'projectile-project-root)
  (setq consult-project-root-function #'vc-root-dir)
  ;; (setq consult-project-root-function
  ;;       (lambda ()
  ;;         (when-let (project (project-current))
  ;;           (car (project-roots project)))))
  ;; (setq consult-project-root-function #'vc-root-dir)
  ;; (setq consult-project-root-function
  ;;       (lambda () (locate-dominating-file "." ".git")))
)

;; LSP + consult integration (replaces lsp-ivy)
(use-package consult-lsp
  :ensure t
  :after (lsp-mode consult)
  :bind (:map lsp-mode-map
              ("C-c l s" . consult-lsp-symbols)
              ("C-c l d" . consult-lsp-diagnostics)
              ("C-c l f" . consult-lsp-file-symbols)))

;; Optionally add the `consult-flycheck' command.
(use-package consult-flycheck
  :bind (:map flycheck-command-map
              ("!" . consult-flycheck)))

;; (setq ivy-use-virtual-buffers t)
;; (setq ivy-height 10)

;; (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
;; (setq ivy-use-selectable-prompt t)
;; (global-set-key "\C-s" 'swiper)
;; (global-set-key (kbd "C-c C-r") 'ivy-resume)
;; (global-set-key (kbd "<f6>") 'ivy-resume)
;; (global-set-key (kbd "M-x") 'counsel-M-x)
;; (global-set-key (kbd "M-p") 'counsel-git)
;; (global-set-key (kbd "C-x f") 'counsel-git)
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;; (global-set-key (kbd "<f1> l") 'counsel-load-library)
;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;; (global-set-key (kbd "C-c g") 'counsel-git)
;; (global-set-key (kbd "C-c j") 'counsel-git-grep)
;; (global-set-key (kbd "C-c C-j") 'counsel-git-grep)
;; (global-set-key (kbd "C-c k") 'counsel-ag)
;; (global-set-key (kbd "C-x l") 'counsel-locate)
;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;; (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)

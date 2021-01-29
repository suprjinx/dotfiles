(global-set-key (kbd "M-Y") 'yank-pop-forwards)
(global-set-key (kbd "C-l") 'duplicate-line)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)
(global-set-key (kbd "C-c s") 'ag)

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c b") 'org-iswitchb)
(global-set-key (kbd "C-c f") 'org-cycle-agenda-files)


;; Bind (shift-right) and (shift-left) function to your favorite keys. I use
;; the following so that Ctrl-Shift-Right Arrow moves selected text one 
;; column to the right, Ctrl-Shift-Left Arrow moves selected text one
;; column to the left:

(global-set-key [C-S-right] 'shift-right)
(global-set-key [C-S-left] 'shift-left)

;; go-test functions to match ruby/rspec
(progn
  (setq go-mode-map (make-sparse-keymap))
  (define-key go-mode-map (kbd "C-c , v") 'go-test-current-file)
  (define-key go-mode-map (kbd "C-c , s") 'go-test-current-test)
  (define-key go-mode-map (kbd "C-c , p") 'go-test-current-project)
  (define-key go-mode-map (kbd "C-c , b") 'go-test-current-benchmark)
  (define-key go-mode-map (kbd "C-c C-c") 'go-run)
  (define-key go-mode-map (kbd "M-.") 'godef-jump)
  )

(progn
  ;; modify dired keys
  (require 'dired )
  (define-key dired-mode-map (kbd "S") 'dired-quick-sort)
  (define-key dired-mode-map (kbd "C-x n") 'dired-narrow)
  )

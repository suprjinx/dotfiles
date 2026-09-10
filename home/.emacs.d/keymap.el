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

(global-set-key (kbd "M-n") (lambda () (interactive) (scroll-up 1)))
(global-set-key (kbd "M-p") (lambda () (interactive) (scroll-down 1)))

(global-set-key "\C-x\M-d" `timestamp)

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
  )

;; In any Magit diff, visit the real file in the working tree, at the
;; corresponding line.  RET already does this for unstaged hunks; for
;; staged hunks and commit diffs it opens a read-only blob buffer
;; ("my/file.go.~018765~") instead.  S-RET always visits the worktree
;; file, which is what magit binds C-RET to.
(with-eval-after-load 'magit-diff
  (define-key magit-diff-section-map (kbd "S-<return>") 'magit-diff-visit-worktree-file))

;; Same key from inside a blob buffer: jump to the real file, same line.
(with-eval-after-load 'magit-files
  (define-key magit-blob-mode-map (kbd "S-<return>") 'magit-blob-visit-file))

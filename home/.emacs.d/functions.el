(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(defun shift-region (distance)
  (let ((mark (mark)))
    (save-excursion
      (indent-rigidly (region-beginning) (region-end) distance)
      (push-mark mark t t)
      ;; Tell the command loop not to deactivate the mark
      ;; for transient mark mode
      (setq deactivate-mark nil))))

(defun shift-right ()
  (interactive)
  (shift-region 1))

(defun shift-left ()
  (interactive)
  (shift-region -1))

(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))

(defun join-region (beg end)
  "Apply join-line over region."
  (interactive "r")
  (if mark-active
      (let ((beg (region-beginning))
	    (end (copy-marker (region-end))))
	(goto-char beg)
	(while (< (point) end)
	  (join-line 1)))))

;; clipboard / kill-ring
(defun yank-pop-forwards (arg)
  (interactive "p")
  (yank-pop (- arg)))

(defun pbcopy ()
  (interactive)
  (let ((deactivate-mark t))
    (call-process-region (point) (mark) "pbcopy")))

(defun pbpaste ()
  (interactive)
  (call-process-region (point) (if mark-active (mark) (point)) "pbpaste" t t))

(defun pbcut ()
  (interactive)
  (pbcopy)
  (delete-region (region-beginning) (region-end)))

(defun shell-command-on-buffer ()
  (interactive)
  (let ((line (line-number-at-pos)))
    ;; replace buffer with output of shell command
    (shell-command-on-region (point-min) (point-max) (read-shell-command "Shell command on buffer: ") nil t)
    ;; restore cursor position
    (goto-line line)
    (recenter-top-bottom)))

(defun timestamp ()
   (interactive)
   (insert (format-time-string "%Y-%m-%dT%H:%M:%S")))

(defun go-mode-setup ()
 (setq compile-command "CGO_ENABLED=1 go build -v -tags netgo,osusergo,sqlite_foreign_keys,sqlite_math_functions,sqlite_omit_load_extension,sqlite_unlock_notify,sqlite_vacuum_incr,integration && CGO_ENABLED=1 go test -tags integration")
 (define-key (current-local-map) "\C-c\C-c" 'compile)
 (yas-minor-mode))
 
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(add-hook 'ruby-mode-hook
          (lambda () (hs-minor-mode)))

(eval-after-load "hideshow"
  '(add-to-list 'hs-special-modes-alist
              `(ruby-mode
                ,(rx (or "def" "class" "module" "do" "{" "[" "if" "else" "unless")) ; Block start
                ,(rx (or "}" "]" "end"))                       ; Block end
                ,(rx (or "#" "=begin"))                        ; Comment start
                ruby-forward-sexp nil)))

(defun colorize-compilation ()
  "Colorize from `compilation-filter-start' to `point'."
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region
     compilation-filter-start (point))))

(add-hook 'compilation-filter-hook
          'colorize-compilation)

;; Open files in dired mode using 'open'
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map (kbd "z")
       (lambda () (interactive)
         (let ((fn (dired-get-file-for-visit)))
           (start-process "default-app" nil "open" fn))))))

(setq rspec-use-docker-when-possible t)
(setq rspec-docker-command "sudo docker-compose exec")
(setq rspec-docker-container "web")

;; (eval-after-load "rspec-mode"
;;   '(defun rspec-spring-p()
;;      "Always use spring"
;;      t))

(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
(defun add-d-to-ediff-mode-map () (define-key ediff-mode-map "d" 'ediff-copy-both-to-C))
(add-hook 'ediff-keymap-setup-hook 'add-d-to-ediff-mode-map)

;;; ---- Magit "quick" mode: lean rendering for huge diffs -------------------

(defvar magit-quick--saved nil
  "Saved Magit settings, restored when `magit-quick-mode' is turned off.")

(defconst magit-quick--heavy-sections
  '(magit-insert-tags-header
    magit-insert-unpushed-to-upstream-or-recent
    magit-insert-unpulled-from-upstream
    magit-insert-unpulled-from-pushremote
    magit-insert-modules)
  "Expensive status sections disabled by `magit-quick-mode'.")

(define-minor-mode magit-quick-mode
  "Global minor mode that makes Magit lean for repos with huge diffs.
Collapses the diff sections, turns off expensive diff painting, drops
the costly status sections, and stops auto-refreshing the status
buffer.  Turning the mode off restores whatever the values were before."
  :global t :lighter " MagitQuick"
  (require 'magit)
  (if magit-quick-mode
      (progn
        ;; remember current values (copy lists so remove-hook can't mutate them)
        (setq magit-quick--saved
              (mapcar (lambda (v)
                        (cons v (let ((val (symbol-value v)))
                                  (if (listp val) (copy-sequence val) val))))
                      '(magit-section-initial-visibility-alist
                        magit-diff-refine-hunk
                        magit-diff-paint-whitespace
                        magit-diff-highlight-trailing
                        magit-diff-highlight-indentation
                        magit-refresh-status-buffer
                        magit-status-sections-hook)))
        ;; apply the lean values
        (setq magit-section-initial-visibility-alist
              '((unstaged . hide) (staged . hide) (stashes . hide)
                (unpushed . hide) (unpulled . hide))
              magit-diff-refine-hunk nil
              magit-diff-paint-whitespace nil
              magit-diff-highlight-trailing nil
              magit-diff-highlight-indentation nil
              magit-refresh-status-buffer nil)
        (dolist (fn magit-quick--heavy-sections)
          (remove-hook 'magit-status-sections-hook fn)))
    ;; disable: put everything back exactly as it was
    (dolist (cell magit-quick--saved)
      (set (car cell) (cdr cell)))
    (setq magit-quick--saved nil))
  ;; reflect the change in any open Magit buffers right away
  (when (fboundp 'magit-refresh-all)
    (ignore-errors (magit-refresh-all)))
  (when (called-interactively-p 'any)
    (message "Magit quick mode %s" (if magit-quick-mode "ON" "OFF"))))

(defun magit-quick-mode-on ()
  "Turn `magit-quick-mode' on."
  (interactive) (magit-quick-mode 1))

(defun magit-quick-mode-off ()
  "Turn `magit-quick-mode' off."
  (interactive) (magit-quick-mode -1))

(defalias 'magit-run-lean 'magit-quick-mode-on)

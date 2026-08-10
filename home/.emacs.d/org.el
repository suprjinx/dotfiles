(setq org-use-speed-commands 1)
(setq org-directory "~/Dropbox/org")
(setq org-default-notes-file (concat org-directory "/capture.org"))
(setq org-agenda-files '("~/Dropbox/org"))
(setq org-refile-targets (quote (("~/Dropbox/org/personal.org" :level . 1)
                                 ("~/Dropbox/org/work.org" :level . 1))))
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;;; RET makes a sibling heading/item; S-RET is Org's normal RET ----------------
;; Only headings and list items change behaviour; prose, tables and links keep
;; `org-return', which is also what S-RET now runs (displacing the default
;; S-RET binding, `org-table-copy-down').

(defun gw/org-empty-item-p ()
  "Non-nil when point is on a plain-list item with no content yet."
  (and (org-in-item-p)
       (save-excursion
         (beginning-of-line)
         (looking-at "[ \t]*\\([-+*]\\|[0-9]+[.)]\\)[ \t]+\\(\\[[ X-]\\][ \t]*\\)?$"))))

(defun gw/org-return-dwim ()
  "Insert a heading or list item at the same level as the one at point.
Falls back to `org-return' everywhere else, and on an empty item ends
the list instead of adding another empty one."
  (interactive)
  (cond
   ((org-at-table-p) (org-return))
   ;; Bare bullet + RET means "I'm done with this list": drop the bullet and
   ;; leave point on the now-empty line rather than adding a blank one.
   ((gw/org-empty-item-p)
    (delete-region (line-beginning-position) (line-end-position)))
   ((org-at-heading-p) (org-insert-heading))
   ;; Keep checkbox items checkboxed; org-insert-item is nil outside a list.
   ((org-in-item-p)
    (unless (org-insert-item (and (org-at-item-checkbox-p) t))
      (org-return)))
   (t (org-return))))

(with-eval-after-load 'org
  ;; Bind both spellings: <return> is the GUI key event, RET the terminal one.
  (define-key org-mode-map (kbd "<return>") #'gw/org-return-dwim)
  (define-key org-mode-map (kbd "RET") #'gw/org-return-dwim)
  (define-key org-mode-map (kbd "S-<return>") #'org-return)
  (define-key org-mode-map (kbd "S-RET") #'org-return))

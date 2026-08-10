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

;;; Streaming availability lookup for movie headings (TMDB API) ----------------
;; Get a free v3 API key at https://www.themoviedb.org/settings/api and either
;; export TMDB_API_KEY or drop the key (alone) into ~/.config/tmdb-api-key.

(defvar org-tmdb-api-key
  (or (getenv "TMDB_API_KEY")
      (let ((f (expand-file-name "~/.config/tmdb-api-key")))
        (when (file-readable-p f)
          (string-trim (with-temp-buffer (insert-file-contents f)
                                         (buffer-string))))))
  "TMDB v3 API key used by `org-fetch-streaming'.")

(defvar org-streaming-region "US"
  "ISO 3166-1 country code to look up streaming providers for.")

(defvar org-streaming-types '(flatrate free ads)
  "TMDB provider categories to include, in priority order.
Possible values: flatrate (subscription), free, ads, rent, buy.")

(defun org--tmdb-get-json (url)
  "Fetch URL and return the parsed JSON body as an alist."
  (with-current-buffer (url-retrieve-synchronously url t t 15)
    (goto-char (point-min))
    (unless (re-search-forward "\n\n" nil t)
      (kill-buffer)
      (error "TMDB: malformed HTTP response"))
    (let ((json (json-parse-buffer :object-type 'alist
                                   :array-type 'list
                                   :null-object nil
                                   :false-object nil)))
      (kill-buffer)
      (when (alist-get 'status_message json)
        (error "TMDB: %s" (alist-get 'status_message json)))
      json)))

(defun org--tmdb-movie (title &optional year)
  "Return (ID . MATCHED-TITLE) for the best TMDB match for TITLE/YEAR."
  (let* ((url (format (concat "https://api.themoviedb.org/3/search/movie"
                              "?api_key=%s&include_adult=false&query=%s%s")
                      org-tmdb-api-key
                      (url-hexify-string title)
                      (if year (concat "&year=" year) "")))
         (hit (car (alist-get 'results (org--tmdb-get-json url)))))
    (when hit
      (cons (alist-get 'id hit) (alist-get 'title hit)))))

(defun org--tmdb-providers (id)
  "Return (PROVIDER-NAMES . LINK) for movie ID in `org-streaming-region'."
  (let* ((url (format (concat "https://api.themoviedb.org/3/movie/%s"
                              "/watch/providers?api_key=%s")
                      id org-tmdb-api-key))
         (region (alist-get (intern org-streaming-region)
                            (alist-get 'results (org--tmdb-get-json url)))))
    (cons (delete-dups
           (mapcan (lambda (type)
                     (mapcar (lambda (p) (alist-get 'provider_name p))
                             (alist-get type region)))
                   org-streaming-types))
          (alist-get 'link region))))

(defun org-fetch-streaming ()
  "Look up where to stream the movie named by the current heading.
Writes the result into the entry's :STREAMING: property drawer.
A trailing \"(YYYY)\" in the heading is used to disambiguate the search."
  (interactive)
  (unless org-tmdb-api-key
    (user-error "No TMDB API key; set TMDB_API_KEY or ~/.config/tmdb-api-key"))
  (save-excursion
    (org-back-to-heading t)
    (let* ((heading (org-get-heading t t t t))
           (year (when (string-match "(\\([12][0-9]\\{3\\}\\))" heading)
                   (match-string 1 heading)))
           (title (string-trim
                   (replace-regexp-in-string "([12][0-9]\\{3\\})" "" heading))))
      (message "Looking up \"%s\"..." title)
      (let ((movie (org--tmdb-movie title year)))
        (unless movie
          (user-error "No TMDB match for \"%s\"" title))
        (let* ((providers (org--tmdb-providers (car movie)))
               (names (car providers))
               (link (cdr providers)))
          (org-entry-put (point) "STREAMING"
                         (if names (string-join names ", ") "not available"))
          (when (and names link)
            (org-entry-put (point) "STREAMING_LINK" link))
          (org-entry-put (point) "STREAMING_CHECKED"
                         (format-time-string "%Y-%m-%d"))
          (message "%s [%s]: %s" (cdr movie) org-streaming-region
                   (if names (string-join names ", ") "not available")))))))

(defun org-fetch-streaming-buffer ()
  "Run `org-fetch-streaming' on every level-1 heading in the buffer.
Adjust the \"LEVEL=1\" match below if your movies sit at another level."
  (interactive)
  (org-map-entries
   (lambda ()
     (condition-case err
         (org-fetch-streaming)
       (error (message "Skipped \"%s\": %s"
                       (org-get-heading t t t t)
                       (error-message-string err))))
     (sit-for 0.1))
   "LEVEL=1"))

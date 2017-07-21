(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

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



(defun yank-pop-forwards (arg)
  (interactive "p")
  (yank-pop (- arg)))

(defun ensure-package-installed (&rest packages)
    "Assure every package is installed, ask for installation if it’s not.
    Return a list of installed packages or nil for every skipped package."
    (mapcar
     (lambda (package)
       ;; (package-installed-p 'evil)
       (if (package-installed-p package)
	   nil
	 (package-install package)
	   ))
	packages))

;;; jcs-org.el --- Org mode functionalities.  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'org)

;;----------------------------------------------------------------------------
;; Highlighting

(defun jcs-init-org-faces ()
  "Initialize Org mode faces highlihgting."
  (let ((org-font-lock-comment-face-modes '(org-mode)))
    (dolist (mode org-font-lock-comment-face-modes)
      (font-lock-add-keywords
       mode
       '(("\\(#[[:blank:][:graph:]]*\\)" 1 'font-lock-comment-face))
       'end))))

;;----------------------------------------------------------------------------
;; Table

(defun jcs-org--is-row-a-dividers-p ()
  "Check if current row is a dividers row."
  (save-excursion
    (let (tmp-end-of-line-point tmp-ret-val)
      (end-of-line)
      (setq tmp-end-of-line-point (point))
      (beginning-of-line)
      (while (< (point) tmp-end-of-line-point)
        (when (jcs-current-char-equal-p '("-" "+")) (setq tmp-ret-val t))
        (forward-char 1))
      tmp-ret-val)))

(defun jcs-org--is-good-row-p ()
  "Check if is a good row to move the cursor up or down."
  (and (not (jcs-current-line-empty-p))
       (not (jcs-org--is-row-a-dividers-p))))

(defun jcs-org--count-current-column ()
  "Count the current cursor in which column in the table."
  (save-excursion
    (let ((tmp-column-count 0) tmp-end-of-line-point)
      ;; If is a good row to check
      (when (jcs-org--is-good-row-p)
        (end-of-line)
        (setq tmp-end-of-line-point (point))

        (beginning-of-line)

        (while (< (point) tmp-end-of-line-point)
          (when (jcs-current-char-equal-p "|")
            (setq tmp-column-count (1+ tmp-column-count)))
          (forward-char 1)))
      tmp-column-count)))

;;;###autoload
(defun jcs-org-table-up ()
  "Move cursor up one row if in the table."
  (interactive)
  (let ((tmp-column-count (jcs-org--count-current-column))
        (cycle-counter 0))
    (while (< cycle-counter tmp-column-count)
      (jcs-org-table-left)
      (setq cycle-counter (1+ cycle-counter)))))

;;;###autoload
(defun jcs-org-table-down ()
  "Move cursor down one row if in the table."
  (interactive)
  (let ((tmp-column-count (jcs-org--count-current-column))
        (cycle-counter 0))
    (while (< cycle-counter tmp-column-count)
      (jcs-org-table-right)
      (setq cycle-counter (1+ cycle-counter)))))

;;;###autoload
(defun jcs-org-table-left ()
  "Move cursor left one column if in the table."
  (interactive)
  (org-shifttab))

;;;###autoload
(defun jcs-org-table-right ()
  "Move cursor right one column if in the table."
  (interactive)
  (org-cycle))

;;;###autoload
(defun jcs-org-smart-cycle ()
  "Try current cycle at point if available."
  (interactive)
  (cond
   ((jcs-is-contain-list-symbol (jcs-flatten-list org-todo-keywords)
                                (thing-at-point 'word))
    (org-todo)
    (forward-char 1)
    (unless (jcs-is-contain-list-symbol (jcs-flatten-list org-todo-keywords)
                                        (thing-at-point 'word))
      (org-todo)
      (forward-word -1)))
   (t (org-cycle))))

(provide 'jcs-org)
;;; jcs-org.el ends here

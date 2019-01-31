;; ========================================================================
;; $File: jcs-python-func.el $
;; $Date: 2017-08-05 10:21:39 $
;; $Revision: $
;; $Creator: Jen-Chieh Shen $
;; $Notice: See LICENSE.txt for modification and distribution information
;;                   Copyright © 2017 by Shen, Jen-Chieh $
;; ========================================================================


;;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;; When editing the Python file.
;;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

;;----------------------------------------------
;; Python Doc-String Face
;;----------------------------------------------

(defvar jcs-python-type-doc-string-missing-modes '(python-mode)
  "Highlight three double quotes in a row.")


(mapc (lambda (mode)
        (font-lock-add-keywords
         mode
         '(("\\(\"\"\"[^\"]*\"\"\"\\)" 1 'jcs-font-lock-comment-face t)
           )'end))
      jcs-python-type-doc-string-missing-modes)

;;-----------------------------------------------------------
;;-----------------------------------------------------------

;;;###autoload
(defun jcs-py-indent-region ()
  "Indent region for `python-mode'."
  (interactive)
  (save-excursion
    (save-window-excursion
      (setq endLineNum (string-to-number (format-mode-line "%l")))

      (goto-char (region-beginning))
      (setq startLineNum (string-to-number (format-mode-line "%l")))

      (exchange-point-and-mark)

      (goto-char (region-end))
      (setq endLineNum2 (string-to-number (format-mode-line "%l")))

      (goto-char (region-beginning))
      (setq startLineNum2 (string-to-number (format-mode-line "%l")))

      (deactivate-mark)

      (goto-line startLineNum)
      (previous-line 1)

      (while (and (<= (string-to-number (format-mode-line "%l")) endLineNum))
        (jcs-py-indent-down)
        (end-of-line))

      (goto-line endLineNum2)
      (next-line 1)

      (while (and (>= (string-to-number (format-mode-line "%l")) startLineNum2))
        (jcs-py-indent-up)
        (end-of-line)))))

;;;###autoload
(defun jcs-py-format-document ()
  "Indent the whoe document line by line instead of indent it
once to the whole document. For `python-mode'."
  (interactive)
  (save-excursion
    (save-window-excursion
      (end-of-buffer)
      (setq endLineNum (string-to-number (format-mode-line "%l")))

      (beginning-of-buffer)
      (setq startLineNum (string-to-number (format-mode-line "%l")))

      (while (and (<= (string-to-number (format-mode-line "%l")) endLineNum))
        (jcs-py-indent-down)))))

;;;###autoload
(defun jcs-py-format-region-or-document ()
  "Format the document if there are no region apply. For
`python-mode' we specificlly indent through the file line by
line instead of indent the whole file at once."
  (interactive)
  (if (use-region-p)
      (call-interactively 'jcs-py-indent-region)
    (call-interactively 'jcs-py-format-document)))

;;;###autoload
(defun jcs-py-indent-up ()
  "Move to previous line and indent for `python-mode'."
  (interactive)
  (previous-line 1)
  (if (jcs-current-line-empty-p)
      (when (not (jcs-is-mark-active-or-region-selected-p))
        (py-indent-line-outmost))
    (when (jcs-is-infront-first-char-at-line-p)
      (back-to-indentation))))

;;;###autoload
(defun jcs-py-indent-down ()
  "Move to next line and indent for `python-mode'."
  (interactive)
  (next-line 1)
  (if (jcs-current-line-empty-p)
      (when (not (jcs-is-mark-active-or-region-selected-p))
        (py-indent-line-outmost))
    (when (jcs-is-infront-first-char-at-line-p)
      (back-to-indentation))))

;;;###autoload
(defun jcs-py-return ()
  "Return key for `python-mode'."
  (interactive)
  (call-interactively #'newline)
  (py-indent-line-outmost))

;;;###autoload
(defun jcs-py-real-space ()
  "Just insert a space!"
  (interactive)
  (insert " "))

;;;###autoload
(defun jcs-py-space ()
  "Space key for `python-mode'. If the current cursor position is
infront of the first character we indent the line instead of insert
the space."
  (interactive)

  (if (or (jcs-is-infront-first-char-at-line-p)
          (jcs-is-beginning-of-line-p))
      (progn
        (jcs-insert-spaces-by-tab-width))
    (insert " ")))

;;;###autoload
(defun jcs-py-real-backspace ()
  "Just delete a char."
  (interactive)
  (backward-delete-char 1))

;;;###autoload
(defun jcs-py-backspace ()
  "Backspace key for `python-mode'. If the current cursor position
is infront of the first character in the line we delete fource
spaces instead of `py-electric-backspace'."
  (interactive)

  (if (jcs-is-infront-first-char-at-line-p)
      (progn
        (if (use-region-p)
            (progn
              (delete-region (region-beginning) (region-end)))
          (progn
            (if (jcs-py-check-backward-delete-space)
                (progn
                  ;; delete four spaces
                  (jcs-py-safe-backward-delete-char)
                  (jcs-py-safe-backward-delete-char)
                  (jcs-py-safe-backward-delete-char)
                  (jcs-py-safe-backward-delete-char))
              (progn
                (backward-delete-char 1))))))
    (progn
      ;; OPTION(jenchieh): Default is the `py' version.
      ;;(py-electric-backspace)
      ;; OPTION(jenchieh): `jcs' version.
      (jcs-electric-backspace))))

;;;###autoload
(defun jcs-py-safe-backward-delete-char ()
  (when (jcs-py-check-backward-delete-space)
    (backward-delete-char 1)))

;;;###autoload
(defun jcs-py-check-backward-delete-space ()
  (and (not (jcs-is-beginning-of-line-p))
       ;; Make sure is not a tab.
       (jcs-current-char-equal-p " ")))

;;;###autoload
(defun jcs-py-check-first-char-of-line-is-keyword-p ()
  "Check the first character of the current line the keyword line."
  (interactive)
  (let ((isKeyword nil))
    (save-excursion
      (back-to-indentation)
      (forward-char 1)
      (when (jcs-current-char-equal-p "@")
        (forward-char 1))
      (when (jcs-py-is-python-keyword (jcs-get-word-at-point))
        (setq isKeyword t)))
    isKeyword))

;;;###autoload
(defun jcs-py-is-python-keyword (inKeyword)
  "Check if the current word is in the `python-keyword-list'.
vector list."
  (interactive)
  (let ((isKeyword nil)
        (index 0)
        (python-keyword-list '()))
    (setq python-keyword-list
          ["class"
           "classmethod"
           "def"
           "from"
           "import"
           "staticmethod"
           ])

    (while (< index (length python-keyword-list))
      (when (string= inKeyword (elt python-keyword-list index))
        (setq isKeyword t))
      (setq index (1+ index)))

    isKeyword))


(defun jcs-py-do-doc-string ()
  "Check if should insert the doc string by checking only \
comment character on the same line."
  (let ((do-doc-string t))
    (jcs-goto-first-char-in-line)

    (while (not (jcs-is-end-of-line-p))
      (forward-char 1)

      (when (and (not (jcs-current-whitespace-or-tab-p))
                 (not (jcs-current-char-equal-p "\"")))
        ;; return false.
        (setq do-doc-string nil)))

    ;; return true.
    do-doc-string))

(defun jcs-py-maybe-insert-codedoc ()
  "Insert common Python document/comment string."
  (interactive)
  ;; -- Officual
  ;; URL(jenchieh): https://www.python.org/dev/peps/pep-0008/
  ;; -- Google
  ;; URL(jenchieh): https://google.github.io/styleguide/pyguide.html
  ;; -- Hitchhiker's
  ;; URL(jenchieh): http://docs.python-guide.org/en/latest/writing/style/
  (let ((active-comment nil)
        (previous-line-not-empty nil)
        ;; Flag, if second situation. Check below.
        (between-dq nil))

    (insert "\"")

    (save-excursion
      ;; OPTION(jenchieh): First situation.
      ;; Check if two double-quote infront of this double-quote.
      (save-excursion
        (backward-char 1)
        (when (jcs-current-char-equal-p "\"")
          (backward-char 1)
          (when (jcs-current-char-equal-p "\"")
            (backward-char 1)
            (unless (jcs-current-char-equal-p "\"")
              (when (jcs-py-do-doc-string)
                (setq active-comment t))))))

      ;; OPTION(jenchieh): Second situation.
      ;; Check if between the double-quote.
      (save-excursion
        (backward-char 1)
        (when (jcs-current-char-equal-p "\"")
          (backward-char 1)
          (unless (jcs-current-char-equal-p "\"")
            (forward-char 3)
            (when (jcs-current-char-equal-p "\"")
              (forward-char 1)
              (unless (jcs-current-char-equal-p "\"")
                (backward-char 4)
                (when (jcs-py-do-doc-string)
                  (setq active-comment t)
                  (setq between-dq t)))))))

      (when active-comment
        ;; check if previous line empty.
        (jcs-previous-line)
        (when (not (jcs-current-line-empty-p))
          (setq previous-line-not-empty t))))

    (unless active-comment
      (insert "\"")
      (backward-char 1))

    (when between-dq
      (forward-char 1))

    (when (and active-comment
               previous-line-not-empty)
      (when (= jcs-py-doc-string-version 1)
        ;; OPTION(jenchieh): docstring option..
        (insert "\n"))
      (insert "Description here..\n")
      (insert "\"\"\"")

      (jcs-smart-indent-up)
      (jcs-smart-indent-down)
      (jcs-smart-indent-up)
      (end-of-line)

      ;; Check other comment type.
      ;; ex: param, returns, etc.
      (save-excursion
        ;; Move to `def' keyword in order to search all
        ;; the necessary info before inserting doc string.
        (jcs-move-to-backward-a-word "def")

        ;; insert comment doc comment string.
        (jcs-insert-comment-style-by-current-line 1)))))


;;;###autoload
(defun jcs-ask-python-template (type)
  (interactive
   (list (completing-read
          "Type of the Python template: " '("Class"
                                            "Plain"))))

  (cond ((string= type "Class")
         (progn
           (jcs-insert-python-class-template)))
        ((string= type "Plain")
         (progn
           (jcs-insert-python-template)))))

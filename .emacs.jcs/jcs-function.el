;;; jcs-function.el --- Self defines function.  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


;;----------------------------------------------
;; Buffer
;;----------------------------------------------

;;;###autoload
(defun jcs-is-buffer-open-in-two-or-more-window ()
  "Check if one buffer/file open in two window at a time."
  (interactive)

  (ignore-errors
    (setq BaseFileNameWithExtension (file-name-nondirectory buffer-file-name))
    (setq current-file-buffer (get-buffer BaseFileNameWithExtension)))

  (let ((displayed-frame-count 0))
    (dolist (buf  (jcs-buffer-in-window-list))
      (ignore-errors
        (if (eq buf current-file-buffer)
            ;; increment plus 1
            (setq displayed-frame-count (+ displayed-frame-count 1))
          )))

    ;; return this statement.
    (>= displayed-frame-count 2)))


(defvar jcs-top-level-active nil
  "Check if top level active.")

;;;###autoload
(defun jcs-top-level ()
  "Teminate the current command. - Canceling Action."
  (interactive)
  ;; Set flag.
  (setq jcs-top-level-active t)

  (top-level)

  ;; ATTENTION(jenchieh): This will never be triggered,
  ;; because top level terminate the command including
  ;; this command itself. Turn off the flag see, `jcs-hook.el'
  ;; file, in the `minibuffer-exit-hook'.
  )


;;----------------------------------------------
;; Speedbar
;;----------------------------------------------

(defvar jcs-speedbar-opening-buffer-file-name nil
  "Record down the current speedbar is opening which buffer.")

;;;###autoload
(defun jcs-speedbar-edit-line ()
  "Customize `speedbar-edit-line' function."
  (interactive)
  (let ((is-opening-a-file t))
    (save-excursion
      (beginning-of-line)

      ;; Weird character infront, ignore them by moving forward.
      (forward-char 1)  ;; 0
      (forward-char 1)  ;; :
      (forward-char 1)  ;; < or [, < stand for directory and [ stand for file.

      (when (jcs-current-char-equal-p "<")
        (setq is-opening-a-file nil)))

    ;; Call it normally.
    (call-interactively #'speedbar-edit-line)

    (call-interactively #'sr-speedbar-select-window)

    ;; If is file..
    (when is-opening-a-file
      (let (;; Preserve the previous selected window.
            (record-selected-window jcs-sr-speedbar-record-selected-window))
        ;; Back to previous select window.
        ;;
        ;; NOTE(jenchieh): This will change the previous selected window value.
        (jcs-other-window-prev)

        ;; Record the opening buffer/file down.
        (setq jcs-speedbar-opening-buffer-file-name (buffer-file-name))

        ;; Maybe kill it, because we are going to open it in originally
        ;; selected window instead of the default window after close we
        ;; the `speedbar' window.
        ;;
        ;; NOTE(jenchieh): This seems like it will change the
        ;; `jcs-sr-speedbar-record-selected-window', value by calling
        ;; `jcs-other-window-next' or `jcs-other-window-prev' functions.
        ;; So we also need to wrap this function inside the `let' operation.
        (jcs-maybe-kill-this-buffer)

        ;; Restore previous selected window.
        (setq jcs-sr-speedbar-record-selected-window record-selected-window))

      ;; Close the speedbar window.
      (jcs-sr-speedbar-toggle))))

(defvar jcs-sr-speedbar-window-all-on-right t
  "Make speedbar open on the right of all window.")

(defvar jcs-sr-speedbar-record-selected-window nil
  "Record down the current selected window before toggle.")

;;;###autoload
(defun jcs-sr-speedbar-toggle ()
  "Toggle the speedbar window."
  (interactive)
  (if (sr-speedbar-exist-p)
      (progn
        ;; Close it.
        (call-interactively #'sr-speedbar-toggle)

        ;; Go back to previous selected/editing window.
        (select-window jcs-sr-speedbar-record-selected-window)

        ;; Try to open a recorded opening file.
        (when jcs-speedbar-opening-buffer-file-name
          (find-file jcs-speedbar-opening-buffer-file-name)))
    (progn
      (setq jcs-sr-speedbar-record-selected-window (selected-window))

      (let ((default-directory default-directory)
            (pro-dir (cdr (project-current))))
        ;; NOTE(jenchieh): Use current buffer directory as default.
        (when (buffer-file-name)
          (setq default-directory (f-dirname (buffer-file-name))))

        ;; NOTE(jenchieh): If found project directory, use project directory.
        (when pro-dir
          (setq default-directory pro-dir))

        ;; Esure speedbar is active.
        (call-interactively #'sr-speedbar-toggle)
        (call-interactively #'sr-speedbar-toggle)

        ;; Refresh the speedbar object after the `default-directory'
        ;; has been set.
        (call-interactively #'speedbar-refresh)

        (ignore-errors
          ;; Goto very right/left of the window.
          ;;
          ;; Just set to something very high, so it will ensure we go to
          ;; either the most right and the most left of the window.
          ;; Here we set it to `100' as default.
          (if jcs-sr-speedbar-window-all-on-right
              (windmove-right 100)
            (windmove-left 100)))

        ;; Open it.
        (call-interactively #'sr-speedbar-toggle))

      ;; Select the speedbar window.
      (call-interactively #'sr-speedbar-select-window))))

;;----------------------------------------------
;; Sublimity Mode
;;----------------------------------------------

;;;###autoload
(defun jcs-toggle-sublimity-mode ()
  "Toggle sublimity mode and reactive line number."
  (interactive)
  (call-interactively #'sublimity-mode)
  (jcs-update-line-number-each-window))

;;----------------------------------------------
;; Tabbar Mode
;;----------------------------------------------

;;;###autoload
(defun jcs-toggle-tabbar-mode ()
  "Toggle `tabbar-mode'."
  (interactive)
  (if (jcs-is-minor-mode-enabled-p tabbar-mode)
      (tabbar-mode 0)
    (tabbar-mode 1))

  ;; Loop through all window so all windows take effect.
  (jcs-buffer-visible-list))

;;----------------------------------------------
;; wgrep
;;----------------------------------------------

;;;###autoload
(defun jcs-ag-project-regexp ()
  "Use `wgrep' to replace the word in the entire project."
  ;; TOPIC: Is there a way to use query-replace from grep/ack/ag output modes?
  ;; URL: https://emacs.stackexchange.com/questions/212/is-there-a-way-to-use-query-replace-from-grep-ack-ag-output-modes
  (interactive)

  ;; open search result menu.
  (call-interactively #'ag-project-regexp)

  (other-window 1)

  ;; make result menu editable.
  (call-interactively #'wgrep-change-to-wgrep-mode))

;;---------------------------------------------
;; Truncate Lines
;;---------------------------------------------

;;;###autoload
(defun jcs-enable-truncate-lines ()
  "Enable truncate lines."
  (interactive)
  (unless truncate-lines
    (toggle-truncate-lines)))

;;;###autoload
(defun jcs-disable-truncate-lines ()
  "Disable truncate lines."
  (interactive)
  (when truncate-lines
    (toggle-truncate-lines)))

;;---------------------------------------------
;; Text Scale
;;---------------------------------------------

;;;###autoload
(defun jcs-text-scale-increase ()
  "Scale the text up."
  (interactive)
  (call-interactively #'text-scale-increase)

  ;; Renable line number.
  (jcs-active-line-number-by-mode))

;;;###autoload
(defun jcs-text-scale-decrease ()
  "Scale the text down."
  (interactive)
  (call-interactively #'text-scale-decrease)

  ;; Renable line number.
  (jcs-active-line-number-by-mode))

;;---------------------------------------------
;; Line Numbers
;;---------------------------------------------

;;;###autoload
(defun jcs-update-line-number-each-window ()
  "Update each window's line number mode."
  (interactive)
  (jcs-walk-through-all-windows-once
   (lambda ()
     (jcs-active-line-number-by-mode))))

;;;###autoload
(defun jcs-active-line-number-by-version (&optional act g)
  "Active line number by Emacs version.
Basically decide between `linum-mode' and `display-line-numbers-mode'.
If one is activated, the other one will be deactivated.

If non-nil, active by `display-line-numbers-mode'.
If nil, active by `linum-mode'.

ACT : active or not active?
G : Active line number globally."
  (interactive)
  (let ((dln-ava nil))
    (when (version<= "26.0.50" emacs-version)
      (if g
          (if act (global-display-line-numbers-mode 1) (global-display-line-numbers-mode -1))
        (if act  (display-line-numbers-mode 1) (display-line-numbers-mode -1)))
      ;; Flag confirm line number activated.
      (setq dln-ava t))
    ;; If `display-line-numbers-mode' is active, we have
    ;; to deactive the `linum-mode'.
    (if g
        (if act (global-linum-mode -1) (global-linum-mode 1))
      (if act (linum-mode -1) (linum-mode 1)))
    dln-ava))

;;;###autoload
(defun jcs-active-line-number-by-mode (&optional g)
  "Active line number by mode.
G : Active line number globally."
  (interactive)
  (when (and (not (minibufferp))
             (not (jcs-is-contain-list-string jcs-line-number-ignore-buffers (buffer-name))))
    (if (line-reminder-is-valid-line-reminder-situation)
        (linum-mode 1)
      (jcs-active-line-number-by-version 1 g))))

;;---------------------------------------------
;; Iedit
;;---------------------------------------------

;;;###autoload
(defun jcs-iedit-mode ()
  "Enable Iedit mode in the safe way."
  (interactive)
  (when (and (not (jcs-current-whitespace-or-tab-p))
             (not (jcs-is-beginning-of-line-p)))
    (call-interactively #'iedit-mode)))


;;---------------------------------------------
;; Return
;;---------------------------------------------

;;;###autoload
(defun jcs-ctrl-return-key ()
  "JayCeS default return key."
  (interactive)
  ;;;
  ;; Priority
  ;;
  ;; ATTENTION(jenchieh): all the function in the priority
  ;; function list must all have error handling. Or else this
  ;; the priority chain will break.
  ;;
  ;; 1. `project-abbrev-complete-word'
  ;; 2. `yas-expand'
  ;; 3. `goto-address-at-point'
  ;;
  (unless (ignore-errors (call-interactively #'project-abbrev-complete-word))
    (unless (ignore-errors (call-interactively #'yas-expand))
      (call-interactively #'goto-address-at-point))))


;;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;; Load files.
;;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

;; Utilities
(require 'jcs-math)
(require 'jcs-util)
(require 'jcs-frame)
(require 'jcs-window)
(require 'jcs-shell)
(require 'jcs-minimap)
(require 'jcs-helm-func)
(require 'jcs-message-func)

;; Editing
(require 'jcs-buffer-menu)
(require 'jcs-edit)
(require 'jcs-comment)
(require 'jcs-vs-func)

;; Navigation
(require 'jcs-nav)

;; For Specific Mode
(require 'jcs-txt-func)
(require 'jcs-preproc-func)
(require 'jcs-cc-func)
(require 'jcs-cs-func)
(require 'jcs-cmake-func)
(require 'jcs-java-func)
(require 'jcs-lua-func)
(require 'jcs-nasm-func)
(require 'jcs-python-func)
(require 'jcs-sh-func)
(require 'jcs-web-func)
(require 'jcs-re-builder-func)
(require 'jcs-yaml-func)
(require 'jcs-oop-func)


(provide 'jcs-function)
;;; jcs-function.el ends here

;;; jcs-nasm-mode.el --- Assembly Language Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(require 'nasm-mode)

(require 'jcs-python-func)


(defun jcs-asm-format ()
  "Format the given file as a ASM code."
  (when (jcs-is-current-file-empty-p)
    (jcs-insert-asm-template)))


(defun jcs-nasm-mode-hook ()
  "NASM mode hook."
  (electric-pair-mode nil)
  (abbrev-mode 1)
  (goto-address-mode 1)
  (auto-highlight-symbol-mode t)

  ;; TOPIC: Treat underscore as word.
  ;; URL: https://emacs.stackexchange.com/questions/9583/how-to-treat-underscore-as-part-of-the-word
  (modify-syntax-entry ?_ "w")


  (when buffer-file-name
    (cond ((file-exists-p buffer-file-name) t)
          ((string-match "[.]asm" buffer-file-name) (jcs-asm-format))
          ((string-match "[.]inc" buffer-file-name) (jcs-asm-format))
          ))

  ;; Normal
  (define-key nasm-mode-map (kbd "C-d") #'jcs-kill-whole-line)
  (define-key nasm-mode-map (kbd "C-c C-c") #'kill-ring-save)
  (define-key nasm-mode-map (kbd "<up>") #'jcs-py-indent-up)
  (define-key nasm-mode-map (kbd "<down>") #'jcs-py-indent-down)

  ;; Comment
  (define-key nasm-mode-map (kbd "RET") #'jcs-nasm-return)
  (define-key nasm-mode-map (kbd ";") #'jcs-nasm-comment)

  ;; Edit
  (define-key nasm-mode-map (kbd "SPC") #'jcs-py-space)
  (define-key nasm-mode-map (kbd "S-SPC") #'jcs-py-real-space)
  (define-key nasm-mode-map (kbd "<backspace>") #'jcs-py-backspace)
  (define-key nasm-mode-map (kbd "S-<backspace>") #'jcs-py-real-backspace)
  )
(add-hook 'nasm-mode-hook 'jcs-nasm-mode-hook)


(provide 'jcs-nasm-mode)
;;; jcs-nasm-mode.el ends here

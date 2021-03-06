;;; jcs-cmake-mode.el --- CMake mode. -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'cmake-mode)
(require 'cmake-font-lock)

(require 'jcs-make-func)

(defun jcs-cmake-mode-hook ()
  "CMake mode hook."

  ;; File Header
  (jcs-insert-header-if-valid '("CMakeLists[.]txt")
                              'jcs-insert-cmake-template)

  ;; Normal
  (define-key cmake-mode-map (kbd "<up>") (jcs-get-prev/next-key-type 'previous))
  (define-key cmake-mode-map (kbd "<down>") (jcs-get-prev/next-key-type 'next))
  (define-key cmake-mode-map (kbd "RET") #'jcs-makefile-newline))

(add-hook 'cmake-mode-hook 'jcs-cmake-mode-hook)

(provide 'jcs-cmake-mode)
;;; jcs-cmake-mode.el ends here

;; This is the start of jcs-lua-func.el file
;;------------------------------------------------------------------------------------------------------

;; jcs-lua-func.el             -*- Emacs-Lisp -*-

;; Mode for editing JayCeS code

;; Created:    <Tue Nov 29 13:51:49 EST 2017>
;; Time-stamp: <2017-11-29 10:21:39>
;; Author:     Jen-Chieh Shen <jcs090218@gmail.com>
;; Version:    0.1
;; Keywords:   JayCeS, languages, os, operating system

;; Copyright (C) 2017 Jen-Chieh Shen

;; jcs-lua-func is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; jcs-lua-func is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


;;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;; When editing the Lua related file.
;;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

;;; Code:

(defun jcs-lua-maybe-insert-codedoc ()
  "Insert common Lua document/comment string.

URL(jenchieh): http://lua-users.org/wiki/LuaStyleGuide"
  (interactive)

  (insert "-")

  (let ((active-comment nil)
        (next-line-not-empty nil))
    (save-excursion
      (backward-char 1)
      (if (current-char-equal-p "-")
          (progn
            (backward-char 1)
            (if (current-char-equal-p "-")
                (progn
                  (backward-char 1)
                  (if (not (current-char-equal-p "-"))
                      (setq active-comment t)
                      ))
              )))

      ;; check if next line empty.
      (jcs-next-line)
      (if (not (current-line-empty-p))
          (setq next-line-not-empty t))
      )


    (if (and (equal active-comment t)
             (equal next-line-not-empty t))
        (progn
          (insert "-------------------------------------------------------------\n")
          (insert "-- \n")
          (insert "----------------------------------------------------------------\n")
          (insert "----------------------------------------------------------------")

          (jcs-smart-indent-up)
          (jcs-smart-indent-down)
          (jcs-smart-indent-down)
          (jcs-smart-indent-up)
          (jcs-smart-indent-up)
          (jcs-smart-indent-up)
          (end-of-line)

          ;; Check other comment type.
          ;; ex: param, returns, etc.
          (save-excursion
            ;; Goto the function line before insert doc string.
            (jcs-next-line)
            (jcs-next-line)
            (jcs-next-line)

            ;; insert comment doc comment string.
            (jcs-insert-comment-style-by-current-line)
            )
          ))

    ))

;;------------------------------------------------------------------------------------------------------
;; This is the end of jcs-lua-func.el file

REM @echo off

echo "Moving core files..."

set CONFIG_PATH=%UserProfile%\AppData\Roaming

move "./build.el" "%CONFIG_PATH%\build.el"
move "./.emacs" "%CONFIG_PATH%\.emacs"
xcopy /s "./.emacs.d" "%CONFIG_PATH%/.emacs.d"
xcopy /s "./.emacs.jcs" "%CONFIG_PATH%/.emacs.jcs"

echo "Attempting startup..."

emacs -nw --batch \
      --eval '(let ((debug-on-error (>=  emacs-major-version 26))
                    (url-show-status nil)
                    (user-emacs-directory default-directory)
                    (user-init-file (expand-file-name "~/build.el"))
                    (load-path (delq default-directory load-path)))
                      (load-file user-init-file)
                      (run-hooks (quote after-init-hook))
                      (run-hooks (quote emacs-startup-hook)))'

echo "Startup successful"
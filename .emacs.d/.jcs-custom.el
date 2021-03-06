(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(actionscript-mode adaptive-wrap alt-codes apache-mode atl-markup auto-highlight-symbol auto-read-only auto-rename-tag basic-mode better-scroll browse-kill-ring buffer-move buffer-wrap centaur-tabs clojure-mode cmake-font-lock cobol-mode com-css-sort command-log-mode company-emoji company-fuzzy company-quickhelp-terminal counsel-projectile csharp-mode csproj-mode dart-mode dashboard-ls define-it diminish diminish-buffer dockerfile-mode dumb-jump elisp-def elisp-demos elixir-mode emmet-mode emoji-github erlang eshell-syntax-highlighting ess esup exec-path-from-shell feebleline ffmpeg-player file-header flx flycheck-grammarly flycheck-popup-tip flycheck-pos-tip fountain-mode gdscript-mode gitattributes-mode gitconfig-mode github-browse-file gitignore-mode gitignore-templates glsl-mode go-mode google-this goto-char-preview goto-line-preview groovy-mode haskell-mode haxe-mode helpful highlight-indent-guides hl-todo htmltagwrap ialign iedit impatient-showdown ini-mode isearch-project ivy-file-preview ivy-searcher javadoc-lookup jayces-mode json-mode keypression kotlin-mode license-templates line-reminder lsp-java lsp-origami lsp-ui lua-mode magit manage-minor-mode-table markdown-toc masm-mode most-used-words move-text multi-shell multiple-cursors nasm-mode neotree nhexl-mode nix-mode org-bullets organize-imports-java package-build package-lint parse-it powershell preproc-font-lock processing-mode project-abbrev python-mode quelpa rainbow-mode region-occurrences-highlighter reload-emacs restart-emacs reveal-in-folder right-click-context rjsx-mode rust-mode scala-mode scss-mode shader-mode show-eol smex sql-indent swift-mode test-sha togetherly transwin typescript-mode undo-tree use-package use-ttf vimrc-mode visual-regexp vs-dark-theme vs-light-theme vue-mode web-mode which-key yaml-mode yascroll yasnippet-snippets)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-preview ((t (:foreground "dark gray" :underline t))))
 '(company-preview-common ((t (:inherit company-preview))))
 '(company-scrollbar-bg ((t (:background "dark gray"))))
 '(company-scrollbar-fg ((t (:background "black"))))
 '(company-tooltip ((t (:background "light gray" :foreground "black"))))
 '(company-tooltip-common ((((type x)) (:inherit company-tooltip :weight bold)) (t (:background "light gray" :foreground "#C00000"))))
 '(company-tooltip-common-selection ((((type x)) (:inherit company-tooltip-selection :weight bold)) (t (:background "steel blue" :foreground "#C00000"))))
 '(company-tooltip-selection ((t (:background "steel blue" :foreground "white")))))

(put 'erase-buffer 'disabled nil)
(put 'downcase-region 'disabled nil)  ; Enable downcase-region
(put 'upcase-region 'disabled nil)    ; Enable upcase-region

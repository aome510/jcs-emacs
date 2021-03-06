;;; jcs-package.el --- Package archive related.  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; ==================
;; [IMPORTANT] This should be ontop of all require packages!!!

;; start package.el with emacs
(require 'package)

;; NOTE: Add `GNU', `MELPA', `Marmalade', `ELPA' to repository list
(progn
  ;;(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
  ;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
  ;;(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
  )

;; To avoid initializing twice
(setq package-enable-at-startup nil)

;; Disable check signature while installing packages.
(setq package-check-signature nil)

;; initialize package.el
(when (or (version< emacs-version "27.1") (featurep 'esup-child))
  (package-initialize))

;;----------------------------------------------------------------------------

;; List of package you want to installed.
(defconst jcs-package-install-list
  '(ace-window
    actionscript-mode
    adaptive-wrap
    alt-codes
    apache-mode
    atl-markup
    auto-highlight-symbol
    auto-read-only
    auto-rename-tag
    basic-mode
    better-scroll
    buffer-move
    buffer-wrap
    browse-kill-ring
    centaur-tabs
    clojure-mode
    cmake-font-lock
    cmake-mode
    cobol-mode
    com-css-sort
    command-log-mode
    company
    company-emoji
    company-fuzzy
    company-quickhelp
    company-quickhelp-terminal
    counsel
    counsel-projectile
    csharp-mode
    csproj-mode
    dap-mode
    dart-mode
    dash
    dashboard
    dashboard-ls
    define-it
    diminish
    diminish-buffer
    dockerfile-mode
    dumb-jump
    elisp-def
    elisp-demos
    elixir-mode
    emmet-mode
    emoji-github
    emojify
    erlang
    eshell-syntax-highlighting
    ess
    esup
    exec-path-from-shell
    feebleline
    ffmpeg-player
    flx
    flycheck-grammarly
    flycheck-popup-tip
    flycheck-pos-tip
    fountain-mode
    gdscript-mode
    gitattributes-mode
    gitconfig-mode
    github-browse-file
    gitignore-mode
    gitignore-templates
    glsl-mode
    go-mode
    google-this
    google-translate
    goto-char-preview
    goto-line-preview
    groovy-mode
    haskell-mode
    haxe-mode
    helpful
    highlight-indent-guides
    hl-todo
    htmltagwrap
    ialign
    iedit
    indicators
    ini-mode
    isearch-project
    ivy
    ivy-searcher
    javadoc-lookup
    js2-mode
    json-mode
    keypression
    kotlin-mode
    license-templates
    line-reminder
    lsp-java
    lsp-mode
    lsp-origami
    lsp-ui
    lua-mode
    magit
    manage-minor-mode
    manage-minor-mode-table
    markdown-mode
    markdown-toc
    masm-mode
    most-used-words
    move-text
    multiple-cursors
    nasm-mode
    neotree
    nhexl-mode
    nix-mode
    org-bullets
    organize-imports-java
    origami
    package-build
    package-lint
    parse-it
    powerline
    powershell
    preproc-font-lock
    processing-mode
    project-abbrev
    projectile
    python-mode
    quelpa
    rainbow-mode
    region-occurrences-highlighter
    request
    restart-emacs
    reveal-in-folder
    right-click-context
    rjsx-mode
    rust-mode
    scala-mode
    shader-mode
    show-eol
    ssass-mode
    scss-mode
    smex
    sql-indent
    swift-mode
    swiper
    togetherly
    transwin
    typescript-mode
    undo-tree
    use-package
    use-ttf
    vimrc-mode
    visual-regexp
    vs-dark-theme
    vs-light-theme
    vue-mode
    impatient-mode
    web-mode
    which-key
    wiki-summary
    yaml-mode
    yascroll
    yasnippet
    yasnippet-snippets)
  "List of packages this config needs.")

;;----------------------------------------------------------------------------
;; Util

(defun jcs-package--add-selected-packages (pkg-name)
  "Add PKG-NAME to the selected package list."
  (unless (memq pkg-name package-selected-packages)
    (jcs-mute-apply
      (package--save-selected-packages (cons pkg-name package-selected-packages)))))

(defun jcs-package--remove-selected-packages (pkg-name)
  "Remove PKG-NAME from the selected package list."
  (when (memq pkg-name package-selected-packages)
    (jcs-mute-apply
      (package--save-selected-packages (remove pkg-name package-selected-packages)))))

(defun jcs-package--build-desc (pkg-name)
  "Build package description by PKG-NAME."
  (cadr (assq pkg-name package-alist)))

(defun jcs-package--package-status (pkg-name)
  "Get package status by PKG-NAME."
  (let* ((desc (jcs-package--build-desc pkg-name))
         (status (ignore-errors (package-desc-status desc))))
    (or status "")))

(defun jcs-package--used-elsewhere-p (pkg-name)
  "Return non-nil if PKG-NAME is used elsewhere."
  (let ((desc (jcs-package--build-desc pkg-name)))
    (ignore-errors (package--used-elsewhere-p desc nil 'all))))

(defun jcs-package--package-status-p (pkg-name status)
  "Check if PKG-NAME status the same as STATUS."
  (string= (jcs-package--package-status pkg-name) status))

(defun jcs-package--package-obsolete-p (pkg-name)
  "Return non-nil if PKG-NAME is obsolete package."
  (jcs-package--package-status-p pkg-name "obsolete"))

(defun jcs-package-incompatible-p (pkg-name)
  "Return non-nil if PKG-NAME is incompatible package."
  (jcs-package--package-status-p pkg-name "incompatible"))

(defun jcs-package--package-do-rebuild (pkg-name)
  "Return non-nil if PKG-NAME suppose to be rebuild."
  (and (not (jcs-package--package-obsolete-p pkg-name))
       (not (package-built-in-p pkg-name))
       (not (jcs-package-incompatible-p pkg-name))))

;;----------------------------------------------------------------------------
;; Dependency

(defvar jcs-package-rebuild-dependency-p t
  "Flag to see if able to rebuild dependency graph at the moment.")

(defvar jcs-package--need-rebuild-p nil
  "Flag to see if we need to rebuild for the next command.")

(defvar jcs-package--save-selected-packages '()
  "Record of `package-selected-packages' for calculation of certain commands.")

(defun jcs-package--get-selected-packages ()
  "Return selected packages base on the execution's condition."
  (or jcs-package--save-selected-packages package-selected-packages))

;;;###autoload
(defun jcs-package-rebuild-dependency-list ()
  "Rebuild dependency graph and save to list."
  (interactive)
  (if (not jcs-package-rebuild-dependency-p)
      (setq jcs-package--need-rebuild-p t)
    (jcs-process-reporter-start "Building dependency graph...")
    (let ((new-selected-pkg (jcs-package--get-selected-packages)))
      (dolist (pkg-name package-activated-list)
        (if (not (package-installed-p pkg-name))
            (setq new-selected-pkg (remove pkg-name new-selected-pkg))
          (when (jcs-package--package-do-rebuild pkg-name)
            (jcs-process-reporter-update (format "Build for package `%s`" pkg-name))
            (if (jcs-package--used-elsewhere-p pkg-name)
                (setq new-selected-pkg (remove pkg-name new-selected-pkg))
              (push pkg-name new-selected-pkg)))))
      (delete-dups new-selected-pkg)
      (setq new-selected-pkg (sort new-selected-pkg #'string-lessp))
      (if (equal new-selected-pkg (jcs-package--get-selected-packages))
          (jcs-process-reporter-done "No need to update dependency graph")
        (package--save-selected-packages new-selected-pkg)
        (jcs-process-reporter-done "Done rebuild dependency graph")))))

(defun jcs-package--menu-execute--advice-around (fnc &rest args)
  "Advice execute around `package-menu-execute' function."
  (let ((jcs-package--save-selected-packages package-selected-packages))
    (when (apply fnc args) (jcs-package-rebuild-dependency-list))))

(advice-add 'package-menu-execute :around #'jcs-package--menu-execute--advice-around)

;;----------------------------------------------------------------------------
;; Core Installation

(defvar jcs-package-installing-p nil
  "Is currently upgrading the package.")

(defun jcs--package-install--advice-around (ori-func &rest args)
  "Advice around execute `package-install' command."
  (setq jcs-package-installing-p t)
  (apply ori-func args)
  (setq jcs-package-installing-p nil))
(advice-add 'package-install :around #'jcs--package-install--advice-around)

(defun jcs-package-install (pkg)
  "Install PKG package."
  (unless (get 'jcs-package-install 'state)
    (put 'jcs-package-install 'state t))
  ;; Don't run `package-refresh-contents' if you don't need to install
  ;; packages on startup.
  (package-refresh-contents)
  ;; Else we just install the package regularly.
  (package-install pkg))

(defun jcs-ensure-package-installed (packages &optional without-asking)
  "Assure every PACKAGES is installed, ask WITHOUT-ASKING."
  (dolist (package packages)
    (unless (package-installed-p package)
      (if (or without-asking
              (y-or-n-p (format "[ELPA] Package %s is missing. Install it? " package)))
          (jcs-package-install package)
        package)))
  ;; STUDY: Not sure if you need this?
  (when (get 'jcs-package-install 'state)
    (jcs-package-rebuild-dependency-list)
    (package-initialize)))

(defun jcs-get-package-version (name where)
  "Get version of the package."
  (let ((pkg (cadr (assq name where)))) (when pkg (package-desc-version pkg))))

(defun jcs-package-get-package-by-name (pkg-name)
  "Return the package by PKG-NAME."
  (let (target-pkg)
    (dolist (pkg (mapcar #'car package-alist))
      (when (string= pkg-name pkg) (setq target-pkg pkg)))
    (if (not target-pkg)
        nil
      (cadr (assq (package-desc-name
                   (cadr (assq target-pkg package-alist)))
                  package-alist)))))

(defun jcs-package--upgrade-all-elpa ()
  "Upgrade for archive packages."
  (let (upgrades)
    (dolist (package (mapcar #'car package-alist))
      (let ((in-archive (jcs-get-package-version package package-archive-contents)))
        (when (and in-archive
                   (version-list-< (jcs-get-package-version package package-alist)
                                   in-archive))
          (push (cadr (assq package package-archive-contents)) upgrades))))
    (if upgrades
        (when (yes-or-no-p
               (message "[ELPA] Upgrade %d package%s (%s)? "
                        (length upgrades)
                        (if (= (length upgrades) 1) "" "s")
                        (mapconcat #'package-desc-full-name upgrades ", ")))
          (save-window-excursion
            (dolist (package-desc upgrades)
              (let ((old-package (cadr (assq (package-desc-name package-desc)
                                             package-alist))))
                (jcs-package-install package-desc)
                (package-delete old-package))))
          (jcs-package-rebuild-dependency-list)
          (message "[ELPA] Done upgrading all packages"))
      (message "[ELPA] All packages are up to date"))))

(defun jcs-package--upgrade-all-quelpa ()
  "Upgrade for manually installed packages."
  (let ((upgrades (jcs--upgrade-list-manually)) desc)
    (if upgrades
        (when (yes-or-no-p
               (message "[QUELPA] Upgrade %d package%s (%s)? "
                        (length upgrades)
                        (if (= (length upgrades) 1) "" "s")
                        (mapconcat (lambda (rcp)
                                     (symbol-name (jcs--recipe-get-info rcp :name)))
                                   upgrades ", ")))
          ;; Delete all upgrading packages before installation.
          (dolist (rcp upgrades)
            (setq desc (jcs-package-get-package-by-name (jcs--recipe-get-info rcp :name)))
            (when desc (package-delete desc)))
          (jcs-ensure-manual-package-installed upgrades t)
          (message "[QUELPA] Done upgrading all packages"))
      (message "[QUELPA] All packages are up to date"))))

;;;###autoload
(defun jcs-package-install-all ()
  "Install all needed packages from this configuration."
  (interactive)
  (let ((install-it (or (boundp 'jcs-build-test) jcs-auto-install-pkgs))
        jcs-package-rebuild-dependency-p jcs-package--need-rebuild-p)
    (jcs-ensure-package-installed jcs-package-install-list install-it)
    (jcs-ensure-manual-package-installed jcs-package-manually-install-list install-it)
    (when jcs-package--need-rebuild-p
      (setq jcs-package-rebuild-dependency-p t)
      (jcs-package-rebuild-dependency-list))))

;;;###autoload
(defun jcs-package-upgrade-all ()
  "Upgrade all packages automatically without showing *Packages* buffer."
  (interactive)
  (package-refresh-contents)
  (let (jcs-package-rebuild-dependency-p jcs-package--need-rebuild-p)
    (jcs-package--upgrade-all-elpa)
    (jcs-package--upgrade-all-quelpa)
    (if (not jcs-package--need-rebuild-p)
        (jcs-sit-for)
      (setq jcs-package-rebuild-dependency-p t)
      (jcs-package-rebuild-dependency-list))))

;;;###autoload
(defun jcs-package-menu-filter-by-status (status)
  "Filter the *Packages* buffer by status."
  (interactive
   (list (completing-read
          "Status: " '(".."
                       "available"
                       "built-in"
                       "dependency"
                       "incompat"
                       "installed"
                       "new"
                       "obsolete"))))
  (if (string= status "..")
      (package-list-packages)
    (package-menu-filter (concat "status:" status))))

;;----------------------------------------------------------------------------
;; Manually Installation

(defconst jcs-quelpa-recipes-path (expand-file-name "~/.emacs.jcs/recipes/")
  "Manually installed recipes path.")

(defun jcs--quelpa-recipes ()
  "Return all `quelpa' recipes."
  (require 'jcs-file) (require 'jcs-util) (require 'thingatpt)
  (let ((rcps-ff (jcs-dir-to-filename jcs-quelpa-recipes-path nil t))
        (rcps '()) rcp)
    (dolist (rcp-file rcps-ff)
      (setq rcp
            (eval (read-from-whole-string
                   (concat "'" (jcs-get-string-from-file rcp-file)))))
      (push rcp rcps))
    (reverse rcps)))

(defvar jcs-package-manually-install-list (jcs--quelpa-recipes)
  "List of package that you want to manually installed.")

(defun jcs--form-version-recipe (rcp)
  "Create the RCP for `quelpa' version check."
  (let ((name (symbol-name (pop rcp)))) (push (make-symbol name) rcp) rcp))

(defun jcs--recipe-get-info (rcp prop)
  "Get the PROP information from RCP."
  (let ((plst rcp)) (push :name plst) (plist-get plst prop)))

(defun jcs--package-version-by-recipe (rcp)
  "Return the package version by PKG.
PKG is a list of recipe components."
  (let* ((pkg-repo (jcs--recipe-get-info rcp :repo))
         (pkg-fetcher (jcs--recipe-get-info rcp :fetcher))
         (rcp (jcs--form-version-recipe rcp))
         (name (car rcp))
         (build-dir (expand-file-name (symbol-name name) quelpa-build-dir))
         (quelpa-build-verbose nil))
    (jcs-no-log-apply
      (message "Contacting host: '%s' from '%s'" pkg-repo pkg-fetcher))
    (jcs-mute-apply (quelpa-checkout rcp build-dir))))

(defun jcs--ver-string-to-ver-list (ver)
  "Convert VER string to version recognized list."
  (let ((ver-lst '()) (str-lst (split-string (format "%s" ver) "[.]")))
    (dolist (ver-str str-lst) (push (string-to-number ver-str) ver-lst))
    (reverse ver-lst)))

(defun jcs--upgrade-list-manually ()
  "List of need to upgrade package from manually installed packages."
  (require 'quelpa)
  (let ((upgrade-list '()) new-version current-version pkg-name)
    (dolist (rcp jcs-package-manually-install-list)
      (setq pkg-name (jcs--recipe-get-info rcp :name))
      (setq new-version (jcs--package-version-by-recipe rcp))
      (setq current-version (jcs-get-package-version pkg-name package-alist))
      (setq new-version (jcs--ver-string-to-ver-list new-version))
      (when (version-list-< current-version new-version) (push rcp upgrade-list)))
    (reverse upgrade-list)))

(defun jcs-ensure-manual-package-installed (packages &optional without-asking)
  "Ensure all manually installed PACKAGES are installed, ask WITHOUT-ASKING."
  (unless (jcs-reload-emacs-reloading-p)
    (let ((jcs-package-installing-p t) pkg-name pkg-repo pkg-fetcher
          (quelpa-build-verbose nil)
          pkg-installed-p)
      (dolist (rcp packages)
        (setq pkg-name (jcs--recipe-get-info rcp :name)
              pkg-repo (jcs--recipe-get-info rcp :repo)
              pkg-fetcher (jcs--recipe-get-info rcp :fetcher))
        (unless (package-installed-p pkg-name)
          (when (or without-asking
                    (y-or-n-p (format "[QUELPA] Package %s is missing. Install it? " pkg-name)))
            (require 'quelpa) (require 'jcs-util)
            (jcs-no-log-apply
              (message "Installing '%s' from '%s'" pkg-repo pkg-fetcher))
            (quelpa rcp)
            (setq pkg-installed-p t))))
      (when pkg-installed-p (jcs-package-rebuild-dependency-list)))))

(provide 'jcs-package)
;;; jcs-package.el ends here

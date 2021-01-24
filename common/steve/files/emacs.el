;; -----------------------------------------------------------------------------
;; Package System Initialization
;; -----------------------------------------------------------------------------
(require 'package)
(setq package-archives nil) ;; makes unpure packages archives unavailable
(setq package-enable-at-startup nil)
(package-initialize)

;; -----------------------------------------------------------------------------
;; Splash screen
;; -----------------------------------------------------------------------------
(setq inhibit-splash-screen t
      inhibit-startup-screen t
      initial-scratch-message nil)

;; -----------------------------------------------------------------------------
;; Scroll bar, Tool bar, Menu bar
;; -----------------------------------------------------------------------------
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(tool-bar-mode -1)
(menu-bar-mode -1)

;; -----------------------------------------------------------------------------
;; Marking text and clipboard
;; -----------------------------------------------------------------------------
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

(defun pbcopy ()
  (interactive)
  (let ((deactivate-mark t))
    (call-process-region (point) (mark) "pbcopy")))
(global-set-key (kbd "M-W") 'pbcopy)

;; -----------------------------------------------------------------------------
;; Trailing newline
;; -----------------------------------------------------------------------------
(setq require-final-newline t)

;; -----------------------------------------------------------------------------
;; Font
;; -----------------------------------------------------------------------------
;; (when window-system
;;   (when (functionp 'set-fontset-font)
;;     (set-fontset-font "fontset-default"
;;                       'unicode
;;                       (font-spec :family "DejaVu Sans Mono"
;;                                  :width 'normal
;;                                  :size 12.4
;;                                  :weight 'normal))))

;; -----------------------------------------------------------------------------
;; ace-jump
;; -----------------------------------------------------------------------------
(use-package ace-jump-mode)
(require 'ace-jump-mode)
(global-set-key (kbd "M-SPC") 'ace-jump-mode)

;; -----------------------------------------------------------------------------
;; ace-window
;; -----------------------------------------------------------------------------
(use-package ace-window)
(require 'ace-window)
(global-set-key (kbd "M-p") 'ace-window)

;; -----------------------------------------------------------------------------
;; Buffer management
;; -----------------------------------------------------------------------------
;(global-set-key (kbd "M-]") 'next-buffer)
;(global-set-key (kbd "M-[") 'previous-buffer)

(defun kill-current-buffer ()
  "Kills the current buffer"
  (interactive)
  (kill-buffer (buffer-name)))
(global-set-key (kbd "C-x C-k") 'kill-current-buffer)

(defun nuke-all-buffers ()
  "Kill all buffers, leaving *scratch* only"
  (interactive)
  (mapcar (lambda (x) (kill-buffer x))
          (buffer-list))
  (delete-other-windows))
(global-set-key (kbd "C-x C-S-k") 'nuke-all-buffers)

(global-set-key (kbd "C-c r") 'revert-buffer)

;; -----------------------------------------------------------------------------
;; Whitespace
;; -----------------------------------------------------------------------------
(require 'whitespace)

(unless (member 'whitespace-mode prog-mode-hook)
  (add-hook 'prog-mode-hook 'whitespace-mode))
(global-set-key (kbd "C-c w") 'whitespace-cleanup)
(setq-default indicate-empty-lines t)
(setq-default indent-tabs-mode nil)
(setq-default show-trailing-whitespace t)
(setq-default tab-width 2 indent-tabs-mode nil)

(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)
(defvaralias 'erlang-indent-level 'tab-width)
(defvaralias 'js-indent-level 'tab-width)

(setq whitespace-style '(face trailing tabs))

(defun srstrong/untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun srstrong/indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun srstrong/cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (srstrong/indent-buffer)
  (srstrong/untabify-buffer)
  (delete-trailing-whitespace))

(defun srstrong/cleanup-region (beg end)
  "Remove tmux artifacts from region."
  (interactive "r")
  (dolist (re '("\\\\│\·*\n" "\W*│\·*"))
    (replace-regexp re "" nil beg end)))

(defun srstrong/save-buffer()
    "Cleanup on save"
    (interactive)
    (delete-trailing-whitespace)
    (save-buffer))
(global-set-key (kbd "C-x C-s") 'srstrong/save-buffer)


(global-set-key (kbd "C-x M-t") 'srstrong/cleanup-region)
(global-set-key (kbd "C-c n") 'srstrong/cleanup-buffer)

;; -----------------------------------------------------------------------------
;; Default modeline stuff
;; -----------------------------------------------------------------------------
(line-number-mode 1)
(column-number-mode 1)

(use-package rich-minority)
(require 'rich-minority)

(rich-minority-mode 1)

(setq rm-blacklist
      (format "^ \\(%s\\)$"
              (mapconcat #'identity
                         ;;'("Fly.*" "Projectile.*" "PgLn" "yas" "WK" "company" "Ind" "EditorConfig" "h-i-g" "ARev" "ws" "ElDoc" "$")
                         '( "Projectile.*" "PgLn" "yas" "WK" "company" "Ind" "EditorConfig" "h-i-g" "ARev" "ws" "ElDoc" "$")
                         "\\|")))

;; -----------------------------------------------------------------------------
;; Backup files
;; -----------------------------------------------------------------------------
(setq make-backup-files nil)

;; -----------------------------------------------------------------------------
;; Yes and No
;; -----------------------------------------------------------------------------
(defalias 'yes-or-no-p 'y-or-n-p)

;; -----------------------------------------------------------------------------
;; Magit
;; -----------------------------------------------------------------------------
(use-package magit)

;; -----------------------------------------------------------------------------
;; Key bindings
;; -----------------------------------------------------------------------------
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x t") 'neotree-toggle)

;; -----------------------------------------------------------------------------
;; Highlights
;; -----------------------------------------------------------------------------
(defun srstrong/turn-on-hl-line-mode ()
  (when (> (display-color-cells) 8)
    (hl-line-mode t)))

(defun srstrong/add-watchwords ()
  (font-lock-add-keywords
   nil '(("\\<\\(FIX\\(ME\\)?\\|TODO\\|HACK\\|REFACTOR\\|NOCOMMIT\\)"
          1 font-lock-warning-face t))))

(use-package highlight-indent-guides)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character)
;;(add-hook 'prog-mode-hook 'srstrong/turn-on-hl-line-mode)
(add-hook 'prog-mode-hook 'srstrong/add-watchwords)

(defun aj-toggle-fold ()
  "Toggle fold all lines larger than indentation on current line"
  (interactive)
  (let ((col 1))
    (save-excursion
      (back-to-indentation)
      (setq col (+ 1 (current-column)))
      (set-selective-display
       (if selective-display nil (or col 1))))))
(global-set-key [(M C i)] 'aj-toggle-fold)

;; -----------------------------------------------------------------------------
;; Complete Anything
;; -----------------------------------------------------------------------------
(use-package company)

;; -----------------------------------------------------------------------------
;; Programming modes
;; -----------------------------------------------------------------------------
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

;;(global-set-key (kbd "M-/") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "M-\\") 'dabbrev-expand)

;; -----------------------------------------------------------------------------
;; Flymake
;; -----------------------------------------------------------------------------
(defun srstrong/flymake-keys ()
  "Adds keys for navigating between errors found by Flymake."
  (local-set-key (kbd "C-c C-n") 'flymake-goto-next-error)
  (local-set-key (kbd "C-c C-p") 'flymake-goto-prev-error))

(add-hook 'flymake-mode-hook 'srstrong/flymake-keys)

;; -----------------------------------------------------------------------------
;; Flycheck
;; -----------------------------------------------------------------------------
(use-package flycheck
  :ensure t
;;  :init (global-flycheck-mode)
)

(defun srstrong/flycheck-keys ()
  "Adds keys for navigating between errors found by Flycheck."
  (local-set-key (kbd "C-c C-n") 'flycheck-next-error)
  (local-set-key (kbd "C-c C-p") 'flycheck-previous-error))

(add-hook 'flycheck-mode-hook 'srstrong/flycheck-keys)

;; -----------------------------------------------------------------------------
;; Misc
;; -----------------------------------------------------------------------------
(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)
(setq confirm-nonexistent-file-or-buffer 1)

;; TODO review
;;(setq
;;  backup-by-copying t      ; don't clobber symlinks
;;  backup-directory-alist '(("." . "~/.tmp/emacs-saves"))    ; don't litter my fs tree
;;  delete-old-versions t
;;  kept-new-versions 6
;;  kept-old-versions 2
;;  version-control t) ; use versioned backups

;; -----------------------------------------------------------------------------
;; ag
;; -----------------------------------------------------------------------------
(use-package ag)
(use-package helm-ag)
(defalias 'ack 'helm-ag)
(require 'helm-ag)

;; -----------------------------------------------------------------------------
;; ripgrep
;; -----------------------------------------------------------------------------
(use-package ripgrep)

;; -----------------------------------------------------------------------------
;; Smex
;; -----------------------------------------------------------------------------
(use-package smex)
(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
;; (global-set-key (kbd "M-x") 'smex)
;; (global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; -----------------------------------------------------------------------------
;; yasnippet
;; -----------------------------------------------------------------------------
(use-package yasnippet)
(yas-global-mode 1)

;; -----------------------------------------------------------------------------
;; Projectile
;; -----------------------------------------------------------------------------
(use-package
  projectile
  :init
  (setq projectile-enable-caching t)
  (setq projectile-project-root-files '(".projectile"))
        ;;projectile-project-root-files #'( ".projectile" )
  (setq projectile-project-root-files-functions #'(projectile-root-top-down
                                                   projectile-root-top-down-recurring
                                                   projectile-root-bottom-up
                                                   projectile-root-local))
;;        projectile-project-root-files-bottom-up '(".projectile" ".hg" ".fslckout" "_FOSSIL_" ".bzr" "_darcs")
        ;;projectile-project-root-files-top-down-recurring '(".svn" "CVS" "Makefile" ".git")
  :config
  (projectile-global-mode)
  )


(defun my-projectile-project-find-function (dir)
  (let ((root (projectile-project-root dir)))
    (and root (cons 'transient root))))

(projectile-mode t)

(with-eval-after-load 'project
  (add-to-list 'project-find-functions 'my-projectile-project-find-function))

;; -----------------------------------------------------------------------------
;; Ivy / Counsel
;; -----------------------------------------------------------------------------
(use-package ivy)
(use-package ivy-hydra)
(use-package counsel)
(use-package counsel-projectile)

(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")

(setq projectile-completion-system 'ivy)
(setq ivy-magic-tilde nil)

(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "M-y") 'counsel-yank-pop)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "<f2> j") 'counsel-set-variable)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-c v") 'ivy-push-view)
(global-set-key (kbd "C-c V") 'ivy-pop-view)

(global-set-key (kbd "C-c c s a") 'counsel-ag)
(global-set-key (kbd "C-c c s r") 'counsel-rg)

(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(counsel-projectile-mode 1)

;; Make sure RET navigates into folders rather than opening dired
(define-key ivy-minibuffer-map (kbd "C-j") #'ivy-immediate-done)
(define-key ivy-minibuffer-map (kbd "RET") #'ivy-alt-done)

;; -----------------------------------------------------------------------------
;; Or Helm, but think we prefer ivy
;; -----------------------------------------------------------------------------
;;(use-package helm)
;;(global-set-key (kbd "M-x") 'helm-M-x)
;;(global-set-key (kbd "C-x b") 'helm-mini)
;;(global-set-key (kbd "C-x C-f") 'helm-find-files)
;;(global-set-key (kbd "C-x a g") 'helm-ag)

;; -----------------------------------------------------------------------------
;; Textmate - marked as broken in nix
;; -----------------------------------------------------------------------------
;;(use-package textmate)
;;(defvar *textmate-gf-exclude*
;;  "(/|^)(\\.+[^/]+|vendor|fixtures|tmp|log|classes|build|deps)($|/)|(\\.xcodeproj|\\.nib|\\.framework|\\.pbproj|\\.pbxproj|\\.xcode|\\.xcodeproj|\\.bundle|\\.pyc|\\.beam|\\.d)(/|$)"
;;  "Regexp of files to exclude from `textmate-goto-file'.")

;; -----------------------------------------------------------------------------
;; IDO
;; -----------------------------------------------------------------------------
;;(ido-mode t)
;;(setq ido-enable-flex-matching t
;;      ido-use-virtual-buffers t)
;;(setq ido-decorations (quote ("\n-> "     "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))

;; -----------------------------------------------------------------------------
;; Column number mode
;; -----------------------------------------------------------------------------
(setq column-number-mode t)

;; -----------------------------------------------------------------------------
;; Temporary file management
;; -----------------------------------------------------------------------------
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; -----------------------------------------------------------------------------
;; Erlang
;; -----------------------------------------------------------------------------
(use-package erlang)
(use-package company-erlang)
(setq erlang-electric-commands nil)
(require 'erlang-start)

(add-hook 'erlang-mode-hook 'srstrong/add-watchwords)
;;(add-hook 'erlang-mode-hook 'srstrong/turn-on-hl-line-mode)
(add-hook 'erlang-mode-hook 'whitespace-mode)
(add-hook 'erlang-mode-hook 'company-mode)
(add-hook 'erlang-mode-hook (lambda() (setq indent-tabs-mode nil)))
(add-hook 'erlang-mode-hook (lambda() (setq erlang-indent-level tab-width)))
;;(add-hook 'erlang-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
;;-(add-hook 'erlang-mode-hook #'company-erlang-init)

(add-to-list 'auto-mode-alist '("\\.erlang$"      . erlang-mode)) ;; User customizations file
(add-to-list 'auto-mode-alist '(".*\\.app\\'"     . erlang-mode))
(add-to-list 'auto-mode-alist '(".*app\\.src\\'"  . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.config\\'"  . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.rel\\'"     . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.script\\'"  . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.escript\\'" . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.es\\'"      . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.xrl\\'"     . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.yrl\\'"     . erlang-mode))

(eval-after-load 'erlang
  '(define-key erlang-mode-map (kbd "C-M-i") #'company-lsp))

;; (if (locate-file "erl" exec-path) (setq ivy-erlang-complete-erlang-root (concat (file-name-directory (directory-file-name (file-name-directory (locate-file "erl" exec-path)))) "lib/erlang")) nil)

;; (setq ivy-erlang-complete-ignore-dirs '(".git"))

;; (add-to-list 'load-path "~/.emacs.d/site-lisp/flycheck-rebar3/")
;; (require 'flycheck-rebar3)
;; (flycheck-rebar3-setup)

;; (add-hook 'after-init-hook 'my-after-init-hook)
;; (defun my-after-init-hook ()
;; ;;  (require 'edts-start)
;;   (textmate-mode)
;;   )

;; (defun erlang-flymake-only-on-save ()
;;  "Trigger flymake only when the buffer is saved (disables syntax
;; check on newline and when there are no changes)."
;;  (interactive)
;;  ;; There doesn't seem to be a way of disabling this; set to the
;;  ;; largest int available as a workaround (most-positive-fixnum
;;  ;; equates to 8.5 years on my machine, so it ought to be enough ;-) )
;;  (setq flymake-no-changes-timeout most-positive-fixnum)
;;  (setq flymake-start-syntax-check-on-newline nil))

;; (erlang-flymake-only-on-save)

;;-----------------------------------------------------------------------------
;;eglot - note that elsewhere we set projectile to find project roots by searching for .projectile files...
;;-----------------------------------------------------------------------------
;; (use-package eglot)
;; (add-to-list 'eglot-server-programs '(purescript-mode . ("purescript-language-server" "--stdio")))

;; (setq-default eglot-workspace-configuration
;;               '((:purescript . (:addSpagoSources t
;;                                 :codegenTargets ["corefn"]
;;                                )
;;                 )
;;                )
;; )

;; (add-hook 'purescript-mode-hook 'eglot-ensure)
;; (add-hook 'erlang-mode-hook 'eglot-ensure)

;; -----------------------------------------------------------------------------
;; LSP
;; -----------------------------------------------------------------------------
(setq lsp-keymap-prefix "C-c l")

(use-package lsp-mode
   :hook (
          (erlang-mode . lsp)
          (purescript-mode . lsp)
          (lsp-mode . lsp-enable-which-key-integration)
          )
   :commands lsp
   :config
   (lsp-register-custom-settings
    '(("purescript.codegenTargets" ["corefn"])
      ("purescript.addPscPackageSources" t)
      ;;("purescript.pscIdelogLevel" "all")
      ("purescript.addSpagoSources" t)))
   (setq lsp-prefer-flymake nil ;; Prefer using lsp-ui (flycheck) over flymake.
         lsp-modeline-code-actions-segments '(count icon)
         lsp-modeline-diagnostics-mode 1
         lsp-enable-xref t
         lsp-log-io t ;; nil
         lsp-diagnostic-clean-after-change nil
         ;; lsp-purescript-server-args '("--stdio" "--log" "/tmp/pls.log")'
         )
)

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(use-package lsp-ui
  :commands (lsp-ui-mode lsp-ui-imenu)
  :after (lsp-mode)
  :bind (:map lsp-ui-mode-map
         ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
         ([remap xref-find-references] . lsp-ui-peek-find-references)
         ("C-c u" . lsp-ui-imenu))
  :config
  (setq lsp-ui-sideline-diagnostic-max-lines 20
        lsp-ui-sideline-delay 2
        lsp-ui-sideline-show-diagnostics nil
        lsp-ui-sideline-show-code-actions nil
        lsp-ui-doc-delay 2
;;        lsp-ui-doc-enable nil
        lsp-ui-imenu-window-width 40
  )
)

(use-package lsp-treemacs
  :commands (lsp-treemacs-errors-list lsp-treemacs-symbols)
  :after (lsp-mode)
  :init (define-key lsp-mode-map [remap xref-find-apropos] #'ivy-lsp-workspace-symbol)
  :config
  (setq lsp-treemacs-sync-mode 1
        )
)

;;(use-package helm-lsp :commands helm-lsp-workspace-symbol)
(use-package lsp-ivy :commands ivy-lsp-workspace-symbol)

;; -----------------------------------------------------------------------------
;; which-key
;; -----------------------------------------------------------------------------
(use-package which-key)
(require 'which-key)
(which-key-mode)

;; -----------------------------------------------------------------------------
;; powerline
;; -----------------------------------------------------------------------------
;;(use-package powerline)
;;(require 'powerline)
;;(powerline-default-theme)

;; -----------------------------------------------------------------------------
;; shell-script-mode
;; -----------------------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))

;; -----------------------------------------------------------------------------
;; Web Mode
;; -----------------------------------------------------------------------------
(use-package web-mode)
(setq web-mode-style-padding 2)
(setq web-mode-script-padding 2)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

(add-to-list 'auto-mode-alist '("\\.hbs$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html$" . web-mode))

;; -----------------------------------------------------------------------------
;; YAML
;; -----------------------------------------------------------------------------
(use-package yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; -----------------------------------------------------------------------------
;; Dhall
;; -----------------------------------------------------------------------------
(use-package dhall-mode)
(add-hook 'dhall-mode-hook '(lambda() (setq indent-tabs-mode nil)))

;; -----------------------------------------------------------------------------
;; JavaScript Mode
;; -----------------------------------------------------------------------------
(use-package js2-mode)
(defun js-custom ()
  "js-mode-hook"
  (setq js-indent-level 2))

(add-hook 'js-mode-hook 'js-custom)

;; -----------------------------------------------------------------------------
;; Elm
;; -----------------------------------------------------------------------------
(use-package elm-mode)
(add-to-list 'company-backends 'company-elm)
(setq elm-format-on-save t)

;; -----------------------------------------------------------------------------
;; Typescript
;; -----------------------------------------------------------------------------
(use-package typescript-mode)

;; -----------------------------------------------------------------------------
;; Rust
;; -----------------------------------------------------------------------------
(use-package rust-mode)
(use-package toml-mode)
(use-package flycheck-rust)
(use-package cargo)
(use-package racer)
(add-hook 'rust-mode-hook
  (lambda ()
    (racer-mode)
    (company-mode)
    (flycheck-rust-setup)
    (flycheck-mode)
    ))

(add-hook 'racer-mode-hook #'eldoc-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)

;; -----------------------------------------------------------------------------
;; Purescript
;; -----------------------------------------------------------------------------
(use-package purescript-mode)

(add-hook 'purescript-mode-hook (lambda() (turn-on-purescript-indentation)))

(add-hook 'purescript-mode-hook
   (lambda ()
     (company-mode)
     (turn-on-purescript-indentation)))

;; -----------------------------------------------------------------------------
;; Markdown Mode
;; -----------------------------------------------------------------------------
(use-package markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
(add-hook 'markdown-mode-hook
          (lambda ()
            (visual-line-mode t)
            (writegood-mode t)
            (flyspell-mode t)))
(setq markdown-command "pandoc --smart -f markdown -t html")
;;(setq markdown-css-paths `(,(expand-file-name "markdown.css" srstrong/vendor-dir)))

;; -----------------------------------------------------------------------------
;; Themes
;; -----------------------------------------------------------------------------
(if window-system
    (load-theme 'solarized-light t)
  (load-theme 'wombat t))

;; -----------------------------------------------------------------------------
;; Color Codes
;; -----------------------------------------------------------------------------
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; -----------------------------------------------------------------------------
;; Neotree
;; -----------------------------------------------------------------------------
(use-package
  neotree
  :init
  ;; Fixed width window is an utterly horrendous idea
  (setq neo-window-fixed-size nil)
  (setq neo-window-width 35)
  ;; When neotree is opened, find the active file and
  ;; highlight it
  (setq neo-smart-open t)
  )

(defun neotree-project-dir ()
  (interactive)
  (let ((project-dir (projectile-project-root))
	(file-name (buffer-file-name)))
    (if project-dir
      (progn
	(neotree-dir project-dir)
(neotree-find file-name))
      (message "Could not find git project root."))))

(add-hook 'neotree-mode-hook
	  (lambda ()
      ;; Line numbers are pointless in neotree
      (linum-mode 0)))

;; -----------------------------------------------------------------------------
;; General
;; -----------------------------------------------------------------------------

;; Multiple Major Modes for web content

(use-package terraform-mode)

(use-package
  rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  )

(use-package
  editorconfig
  :config
  (editorconfig-mode 1)
  )

(global-display-line-numbers-mode)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(line-number ((t (:inherit (powerline-inactive2 shadow default)))))
)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values '((psc-ide-codegen "corefn"))))

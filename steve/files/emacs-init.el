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
;;      initial-major-mode 'org-mode)

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
(require 'ace-jump-mode)
(global-set-key (kbd "M-SPC") 'ace-jump-mode)

;; -----------------------------------------------------------------------------
;; ace-window
;; -----------------------------------------------------------------------------
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
;;  (add-hook 'before-save-hook 'delete-trailing-whitespace)
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

;; -----------------------------------------------------------------------------
;; Configure spaceline
;; -----------------------------------------------------------------------------
;; TODO - commented out since it's really slow...
;; (require 'spaceline-config)
;; (spaceline-emacs-theme)
;; (spaceline-helm-mode)
;; (setq powerline-default-separator 'rounded)
;; (setq powerline-height 17)
;; (spaceline-compile)

;; -----------------------------------------------------------------------------
;; Backup files
;; -----------------------------------------------------------------------------
(setq make-backup-files nil)

;; -----------------------------------------------------------------------------
;; Yes and No
;; -----------------------------------------------------------------------------
(defalias 'yes-or-no-p 'y-or-n-p)

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
;; Flycheck
;; -----------------------------------------------------------------------------
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
(defalias 'ack 'helm-ag)
(require 'helm-ag)

;; -----------------------------------------------------------------------------
;; Smex
;; -----------------------------------------------------------------------------
(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; -----------------------------------------------------------------------------
;; Textmate
;; -----------------------------------------------------------------------------
(defvar *textmate-gf-exclude*
  "(/|^)(\\.+[^/]+|vendor|fixtures|tmp|log|classes|build|deps)($|/)|(\\.xcodeproj|\\.nib|\\.framework|\\.pbproj|\\.pbxproj|\\.xcode|\\.xcodeproj|\\.bundle|\\.pyc|\\.beam|\\.d)(/|$)"
  "Regexp of files to exclude from `textmate-goto-file'.")

;; -----------------------------------------------------------------------------
;; IDO
;; -----------------------------------------------------------------------------
(ido-mode t)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)
(setq ido-decorations (quote ("\n-> "     "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))

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
(setq erlang-electric-commands nil)
(require 'erlang-start)

;;(add-hook 'erlang-mode-hook #'lsp)

(add-hook 'erlang-mode-hook 'srstrong/add-watchwords)
;;(add-hook 'erlang-mode-hook 'srstrong/turn-on-hl-line-mode)
(add-hook 'erlang-mode-hook 'whitespace-mode)
;;-(add-hook 'erlang-mode-hook 'company-mode)
(add-hook 'erlang-mode-hook (lambda() (setq indent-tabs-mode nil)))
(add-hook 'erlang-mode-hook (lambda () (setq erlang-indent-level tab-width)))
;;(add-hook 'erlang-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
;;-(add-hook 'erlang-mode-hook #'company-erlang-init)
;;-(add-hook 'erlang-mode-hook #'ivy-erlang-complete-init)
;;-(add-hook 'erlang-mode-hook #'flycheck-mode)
;;-(add-hook 'after-save-hook #'ivy-erlang-complete-reparse)

(add-to-list 'auto-mode-alist '("\\.erlang$" . erlang-mode)) ;; User customizations file
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

;; -----------------------------------------------------------------------------
;; which-key
;; -----------------------------------------------------------------------------
(require 'which-key)
(which-key-mode)

;; -----------------------------------------------------------------------------
;; powerline
;; -----------------------------------------------------------------------------
(require 'powerline)
(powerline-default-theme)

;; -----------------------------------------------------------------------------
;; shell-script-mode
;; -----------------------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))

;; -----------------------------------------------------------------------------
;; Web Mode
;; -----------------------------------------------------------------------------
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
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; -----------------------------------------------------------------------------
;; Dhall
;; -----------------------------------------------------------------------------
(add-hook 'dhall-mode-hook '(lambda() (setq indent-tabs-mode nil)))

;; -----------------------------------------------------------------------------
;; JavaScript Mode
;; -----------------------------------------------------------------------------
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
(use-package flycheck-rust)
(use-package cargo)
(use-package toml-mode)
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
;; LSP
;; -----------------------------------------------------------------------------
(setq lsp-keymap-prefix "C-c l")

(use-package lsp-mode
    :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
           (erlang-mode . lsp)
           (purescript-mode . lsp)
           ;; if you want which-key integration
           (lsp-mode . lsp-enable-which-key-integration))

    :commands lsp)
(defun lsp-set-cfg ()
  (let ((lsp-cfg `(:purescript (:codegenTargets ("corefn"))
                   :addSpagoSources t)))
    ;; TODO: check lsp--cur-workspace here to decide per server / project?
    (lsp--set-configuration lsp-cfg)))

(add-hook 'lsp-after-initialize-hook 'lsp-set-cfg)


;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;;(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;;(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
    :config
    (which-key-mode))

;; (setq lsp-ui-sideline-enable t)
;; (setq lsp-ui-doc-enable t)
;; (setq lsp-ui-doc-position 'bottom)

;; (use-package lsp-mode
;;   :config
;;   (setq lsp-prefer-flymake nil ;; Prefer using lsp-ui (flycheck) over flymake.
;;         lsp-enable-xref t)

;; ;;  (setq lsp-purescript-server-args '("--config {'purescript': {'codegenTargets': ['corefn'], 'addSpagoSources': true}}" "--stdio"))
;;   (add-hook 'erlang-mode-hook #'lsp)
;;   (add-hook 'purescript-mode-hook #'lsp)

;;   (defun lsp-set-cfg ()
;;     (let ((lsp-cfg `(:purescript (:codegenTargets ("corefn"))
;;                      :addSpagoSources t)))
;;       ;; TODO: check lsp--cur-workspace here to decide per server / project?
;;       (lsp--set-configuration lsp-cfg)))

;;   (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg)
;; )

;; (use-package lsp-ui :commands lsp-ui-mode)
;; (use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; (push 'company-lsp company-backends)

;; (with-eval-after-load 'lsp-mode
;;   (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

;; -----------------------------------------------------------------------------
;; Purescript
;; -----------------------------------------------------------------------------
(use-package purescript-mode)
;;(use-package psc-ide)

;;(add-to-list 'load-path "~/dev/purescript/purty/")
;;(require 'purty)

;;(add-hook 'purescript-mode-hook #'lsp)
(add-hook 'purescript-mode-hook (lambda() (turn-on-purescript-indentation)))

;; (add-hook 'purescript-mode-hook
;;   (lambda ()
;;     (psc-ide-mode)
;;     (company-mode)
;;     (flycheck-mode)
;;     (local-set-key (kbd "C-c C-n") 'flycheck-next-error)
;;     (local-set-key (kbd "C-c C-p") 'flycheck-previous-error)
;;     (turn-on-purescript-indentation)))

;; -----------------------------------------------------------------------------
;; Markdown Mode
;; -----------------------------------------------------------------------------
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
;; Projectile
;; -----------------------------------------------------------------------------
(use-package
  projectile
  :init
  (setq projectile-enable-caching t)
  :config
  (projectile-global-mode)
  )

;; -----------------------------------------------------------------------------
;; General
;; -----------------------------------------------------------------------------

;; Multiple Major Modes for web content
(use-package web-mode)

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

(use-package ag)

;; (use-package
;;   linum-relative
;;   :config
;;   (setq linum-relative-format "%3s ")
;;   (linum-relative-global-mode)
;;   )

(global-display-line-numbers-mode)
(custom-set-faces
 '(line-number ((t (:inherit (powerline-inactive2 shadow default))))))

;; -----------------------------------------------------------------------------
;; Emacs-maintained Stuff
;; -----------------------------------------------------------------------------
;;(custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(custom-safe-themes
;;     (quote
;;       ("a566448baba25f48e1833d86807b77876a899fc0c3d33394094cf267c970749f" "9d9fda57c476672acd8c6efeb9dc801abea906634575ad2c7688d055878e69d6" "3a3de615f80a0e8706208f0a71bbcc7cc3816988f971b6d237223b6731f91605;;;;;;" "8891c81848a6cf203c7ac816436ea1a859c34038c39e3cf9f48292d8b1c86528" "f78de13274781fbb6b01afd43327a4535438ebaeec91d93ebdbba1e3fba34d3c" "9d4787fa4d9e06acb0e5c51499bff7ea827983b8bcc7d7545ca41db521bd9261" "f81a9aabc6a70441e4a742dfd6d10b2bae1088830dc7aba9c9922f4b1bd2ba50" "715fdcd387af7e963abca6765bd7c2b37e76154e65401cd8d86104f22dd88404" "3b0a350918ee819dca209cec62d867678d7dac74f6195f5e3799aa206358a983" "1012cf33e0152751078e9529a915da52ec742dabf22143530e86451ae8378c1a" default)))
;;  '(package-selected-packages
;;     (quote
;;       (zoom-frm yoshi-theme yaml-mode web-mode use-package typescript-mode toml-mode textmate terraform-mode smex scion rainbow-delimiters railscasts-theme purescript-mode psc-ide projectile pastelmac-theme;;;; neotree multi-web-mode monokai-theme magit linum-relative lfe-mode kerl intero helm-swoop hamburg-theme flx-ido evil eproject elm-mode edts editorconfig doom-themes cider cargo ag)))
;;  '(safe-local-variable-values (quote ((allout-layout . t)))))
;;(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
;;  )

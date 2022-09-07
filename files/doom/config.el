;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(general-auto-unbind-keys :off)
(remove-hook 'doom-after-init-modules-hook #'general-auto-unbind-keys)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Steve Strong"
      user-mail-address "steve@srstrong.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dark+ ;; 'doom-opera doom-sourcerer
      )

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;; (use-package! company-quickhelp
;;    :hook (global-company-mode . company-quickhelp-mode)
;;    :after company
;;    :init (setq company-quickhelp-delay company-idle-delay))

;; (add-hook 'psc-ide-mode-hook
;;           (lambda ()
;;             (when (psc-ide-mode) (psc-ide-mode -1))
;;             )
;;           )

(add-hook 'lsp-mode-hook
          (lambda ()
            (psc-ide-mode -1)
            (setq-local company-format-margin-function
                        #'company-vscode-light-icons-margin)))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
    '(".*\\.purs$" . "purescript"))
  )

(use-package! lsp-mode
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
      ("purescript.addSpagoSources" t)
      ("purescript.censorWarnings" ["ShadowedName" "WildcardInferredType"])
      ("purescript.formatter" "purs-tidy")
      ("purescript.autocompleteLimit" 50)
      ))
   (setq lsp-prefer-flymake nil ;; Prefer using lsp-ui (flycheck) over flymake.
         ;;lsp-modeline-code-actions-segments '(count icon)
         lsp-lens-mode nil
         lsp-lens-enable nil
         lsp-modeline-code-actions-mode nil
         lsp-modeline-code-actions-enable nil
         lsp-modeline-diagnostics-mode 1
         lsp-enable-xref t
         lsp-log-io t
         lsp-diagnostic-clean-after-change nil
         lsp-keymap-prefix "C-c l"
         lsp-purescript-server-args '("--stdio" "--log" "/tmp/pls.log")
         )
)

(use-package! lsp-ui
  :commands (lsp-ui-mode lsp-ui-imenu)
  :after (lsp-mode)
  :bind (:map lsp-ui-mode-map
         ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
         ([remap xref-find-references] . lsp-ui-peek-find-references)
         ("C-c u" . lsp-ui-imenu))
  :config
  (setq lsp-ui-sideline-diagnostic-max-lines 50
        lsp-ui-sideline-delay 2
        lsp-ui-sideline-show-diagnostics nil
        lsp-ui-sideline-show-code-actions nil
        lsp-ui-doc-delay 2
        lsp-ui-doc-max-height 50
        ;;lsp-ui-doc-enable nil
        lsp-ui-imenu-window-width 40
  )
)

(setq +format-with-lsp t)

(setq-hook! 'erlang-mode-hook +format-with-lsp nil)

(after! lsp-ui
  (setq lsp-ui-doc-enable t))

(after! rustic
  (setq rustic-format-on-save t))

(after! psc-ide (remove-hook 'purescript-mode-hook 'psc-ide-mode ))

(use-package! flycheck
  :config
  (setq flycheck-display-errors-delay 2.0)
  (map! :map flycheck-mode-map
        "C-c C-n" #'flycheck-next-error
        "C-c C-p" #'flycheck-previous-error
  )
)

(defun pbcopy ()
  (interactive)
  (let ((deactivate-mark t))
    (call-process-region (point) (mark) "pbcopy")))

(map! "C-s" #'counsel-grep-or-swiper ;; #'+default/search-buffer
      "C-r" #'counsel-grep-or-swiper-backward
      "M-W" #'pbcopy
      )

(map! :map psc-ide-mode-map
      "M-." nil
)

(map! :map lsp-mode-map
      "M-." #'lsp-find-definition
)

(map! :map ivy-minibuffer-map
      "C-j" #'ivy-immediate-done
      "RET" #'ivy-alt-done
)

(map! :map company-mode-map
      "C-x c" #'company-complete
)

(setq company-idle-delay 1)
(setq lsp-use-plists t)
(setq tab-always-indent t)
(setq confirm-nonexistent-file-or-buffer t)
(setq ivy-magic-tilde nil)
(setq doom-font-increment 1)
(setq flycheck-check-syntax-automatically '(save mode-enabled))
(setq flycheck-display-errors-delay 100000)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 4 (* 1024 1024)))

(setq mac-command-modifier      'super
      ns-command-modifier       'super
      mac-option-modifier       'meta
      ns-option-modifier        'meta
      mac-right-option-modifier 'meta
      ns-right-option-modifier  'meta)

(setq which-key-show-early-on-C-h t)
(setq which-key-idle-delay 10000)
(setq which-key-idle-secondary-delay 0.05)

(custom-set-faces
 '(mode-line ((t (:background "light slate gray" :foreground "black"))))
 '(mode-line-inactive ((t (:background "dim gray")))))


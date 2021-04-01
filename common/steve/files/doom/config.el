;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


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
(after! psc-ide-mode
  (psc-ide-mode -1))

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
      ("purescript.censorWarnings" ["ShadowedName"])
      ))
   (setq lsp-prefer-flymake nil ;; Prefer using lsp-ui (flycheck) over flymake.
         ;;lsp-modeline-code-actions-segments '(count icon)
         lsp-modeline-diagnostics-mode 1
         lsp-enable-xref t
         lsp-log-io nil ;; t
         lsp-diagnostic-clean-after-change nil
         lsp-keymap-prefix "C-c l"
         ;; lsp-purescript-server-args '("--stdio" "--log" "/tmp/pls.log")'
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
        ;; lsp-ui-doc-enable nil
        lsp-ui-imenu-window-width 40
  )
)

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

(map! "C-s" #'+default/search-buffer
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

(setq tab-always-indent t)
(setq confirm-nonexistent-file-or-buffer 1)
(setq ivy-magic-tilde nil)

(custom-set-faces
 '(mode-line ((t (:background "light slate gray" :foreground "black"))))
 '(mode-line-inactive ((t (:background "dim gray")))))

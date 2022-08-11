;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "scalychimp"
      user-mail-address "scalychimp@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrains Mono" :size 18 :weight 'regular))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 't)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; dired/dirvish keybindings
(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "dirvish dispatch" "s" #'dirvish-dispatch
       :desc "dirvish in ranger style" "r" #'dirvish
       :desc "Dired jump to current" "j" #'dired-jump))

(setq dirvish-override-dired-mode 't)

(map! :desc "yank from kill ring" "M-y" #'yank-from-kill-ring)

;; emacs and vim fusion.
(map! :nvi "M-h" #'back-to-indentation
      :nvi "M-j" #'forward-paragraph
      :nvi "M-k" #'backward-paragraph
      :nvi "M-l" #'end-of-line)

(map! :leader
      :desc "hydra window macro" "W" #'+hydra/window-nav/body)

;; ranger show hidden files
(setq ranger-show-hidden t)

(define-globalized-minor-mode global-rainbow-mode rainbow-mode
  (lambda () (rainbow-mode 1)))
(global-rainbow-mode 1)

(setq org-hide-emphasis-markers t)

(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.4))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.3))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.0)))))


(setq evil-move-cursor-back nil)

(set-frame-parameter (selected-frame) 'alpha '(100 . 80))

(unless IS-WINDOWS #'exec-path-from-shell-initialize)

(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-autolinks nil)
  ;; for proper first-time setup, `org-appear--set-elements'
  ;; needs to be run after other hooks have acted.
  (run-at-time nil nil #'org-appear--set-elements))

(after! evil-snipe
  (evil-snipe-override-mode 1)
  (add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode)
  (setq
   evil-snipe-scope 'whole-line
   evil-snipe-repeat-scope 'whole-line))

(add-hook! 'org-mode-hook #'global-org-modern-mode)

(add-hook 'c-mode-common-hook
          (lambda () (modify-syntax-entry ?_ "w")))

(define-key evil-outer-text-objects-map "w" 'evil-a-symbol)
(define-key evil-inner-text-objects-map "w" 'evil-inner-symbol)
(define-key evil-outer-text-objects-map "o" 'evil-a-word)
(define-key evil-inner-text-objects-map "o" 'evil-inner-word)

(defalias 'forward-evil-word 'forward-evil-symbol)

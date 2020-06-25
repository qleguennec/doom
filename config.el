;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Quentin Le Guennec"
      user-mail-address "quentin.leguennec1@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; test
(setq doom-font (font-spec :family "mononoki" :size 15)
      doom-big-font (font-spec :family "mononoki" :size 36)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 12))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-material)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type nil)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
;;
;;
;;
;;

(remove-hook! prog-mode vi-tilde-fringe-mode)

(after! evil-collection
  (setq evil-collection-mode-list
        (delete 'lispy evil-collection-mode-list)))

(use-package super-save
  :hook (prog-mode . super-save-mode))

(use-package hungry-delete
  :hook (prog-mode . global-hungry-delete-mode))

(use-package aggressive-indent
  :hook ((clojure-mode clojurescript-mode emacs-lisp-mode) . aggressive-indent-mode))

(use-package git-auto-commit-mode
  :config
  (setq gac-automatically-push-p t
        gac-automatically-add-new-files-p t))

;; Disable flycheck for emacs-lisp
(add-hook! emacs-lisp-mode
  (after! flycheck
    (flycheck-mode -1)))

(after! centaur-tabs
  (setq centaur-tabs-cycle-scope 'tabs)
  (map! :map centaur-tabs-mode-map
        :n "M-h" #'centaur-tabs-backward
        :n "M-l" #'centaur-tabs-forward)
  (centaur-tabs-group-by-projectile-project))

(after! neotree
  (setq neo-autorefresh t))

(add-hook! window-setup #'doom/quickload-session)
(add-hook! kill-emacs #'doom/quicksave-session)

(after! ivy
  (map! :vn "?" #'+ivy/project-search
        :vn "/" #'swiper
        :vn "*" #'swiper-thing-at-point))


(s-split " " "hello hello")
(format ":%s %s" "hello" "hello")

(after! window-select
  (setq aw-keys '(?a ?s ?d ?f ?h ?j ?k ?l)
        aw-dispatch-always t)
  (map! :leader :n "ww" #'ace-window))

(after! eshell
  (map!
   :map 'eshell-mode-map
   :nvi "<up>" #'eshell-previous-input
   :nvi "<down>" #'eshell-next-input))

(after! magit
  (map! :leader :n "ag" #'magit-status))

(after! mu4e
  (setq +mu4e-backend 'offlineimap)

  (set-email-account! "perso"
                      '((mu4e-sent-folder       . "/perso/sent")
                        (mu4e-drafts-folder     . "/perso/dragts")
                        (mu4e-trash-folder      . "/perso/trash")
                        (mu4e-refile-folder     . "/perso/inbox")
                        (smtpmail-smtp-user     . "quentin.leguennec1@gmail.com")
                        (user-mail-address      . "quentin.leguennec1@gmail.com")
                        (mu4e-compose-signature . "---\nQuentin Le Guennec"))
                      t))

(after! treemacs
  (treemacs-follow-mode))

(setq evil-vsplit-window-right t
      evil-split-window-below t)

(map! :leader :n "h." #'helpful-at-point)

(setq scroll-conservatively 0
      scroll-preserve-screen-position t)

(setq evil-escape-key-sequence nil)

(defun recenter-and-blink (&rest _ignore)
  (doom-recenter-a)
  (+nav-flash-blink-cursor))

(advice-add #'+lookup/definition :after #'recenter-and-blink)

(defun join-lines-after-delete (&rest _ignore)
  (interactive)
  (delete-blank-lines))

(after! lispy
  :config
  (advice-add #'lispy-up :after #'doom-recenter-a)
  (advice-add #'lispy-down :after #'doom-recenter-a)
  (advice-add #'lispy-move-down :after #'doom-recenter-a)
  (advice-add #'lispy-move-up :after #'doom-recenter-a)

  (setq lispy-eval-display-style 'overlay)
  (map! :map lispy-mode-map
        :i "[" #'lispy-brackets
        :i "{" #'lispy-braces))

;; (after! lispyville
;;   :config
;;   (add-hook 'lispyville-delete #'join-lines-after-delete)
;;   (add-hook 'lispyville-delete-whole-line #'join-lines-after-delete)
;;   (add-hook 'lispyville-delete-line #'join-lines-after-delete))

(after! magit
  :config
  (magit-auto-revert-mode))

(smartparens-global-mode -1)
(remove-hook 'prog-mode-hook #'git-gutter-mode)
(remove-hook 'prog-mode-hook #'electric-layout-mode)
(remove-hook 'prog-mode-hook #'electric-indent-mode)
(remove-hook 'prog-mode-hook #'hl-todo-mode)
(remove-hook 'prog-mode-hook #'highlight-numbers-mode)
(remove-hook 'prog-mode-hook #'hl-line-mode)
(remove-hook 'prog-mode-hook #'electric-pair-mode)
(remove-hook 'prog-mode-hook #'display-line-numbers-mode)
(remove-hook 'prog-mode-hook #'electric-quote-mode)
(remove-hook 'prog-mode-hook #'goto-address-prog-mode)

(after! projectile
  (setq projectile-project-root-files-functions #'(projectile-root-top-down
                                                   projectile-root-top-down-recurring
                                                   projectile-root-bottom-up
                                                   projectile-root-local)))

(advice-add 'evil-window-up
            :after
            (lambda (arg)
              (when (string-equal " *NeoTree*" (buffer-name (current-buffer)))
                (evil-window-right 1))))

(setq-hook! typescript-mode
  typescript-indent-level 2)

(use-package prettier-js
  :commands prettier-js-mode
  :init
  (add-hook! (typescript-mode web-mode scss-mode) #'prettier-js-mode)
  :config
  (setq prettier-js-command "prettier_d"))

(after! prettier-js
  (add-hook 'before-save-hook
            (cmd!
             (when prettier-js-mode
               (prettier-js)))))

(setq-hook! web-mode
  web-mode-markup-indent-offset 2)

(after! company
  (setq company-echo-delay 1
        company-idle-delay 5
        company-tooltip-idle-delay 0))

(after! evil
  (advice-add 'evil-scroll-line-to-center :after #'recenter-and-blink)
  (advice-add 'evil-backward-paragraph :after #'recenter-and-blink)
  (advice-add 'evil-forward-paragraph :after #'recenter-and-blink)
  (advice-add 'evil-ex-search-next :after #'recenter-and-blink)
  (advice-add 'evil-ex-search-previous :after #'recenter-and-blink)
  (advice-add 'evil-goto-line :after #'recenter-and-blink)

  (map!
   :map company-mode-map
   "<tab>" #'+company/complete
   :map evil-inner-text-objects-map
   "b" #'evil-textobj-anyblock-inner-block
   "B" #'evil-inner-paren
   :map evil-outer-text-objects-map
   "b" #'evil-textobj-anyblock-a-block
   "B" #'evil-a-paren))

(setq-hook! 'cider-mode-hook
    read-process-output-max (* 128 1024)
    gcmh-high-cons-threshold (* 2 gcmh-high-cons-threshold))

(after! cider
  (add-hook 'company-completion-started-hook 'ans/set-company-maps)
  (add-hook 'company-completion-finished-hook 'ans/unset-company-maps)
  (add-hook 'company-completion-cancelled-hook 'ans/unset-company-maps)

  (remove-hook 'cider-mode-hook #'rainbow-delimiters-mode)
  (remove-hook 'clojure-mode-hook #'rainbow-delimiters-mode)

  (add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
  (add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)

  (defun ans/unset-company-maps (&rest unused)
    "Set default mappings (outside of company).
    Arguments (UNUSED) are ignored."
    (general-def
      :states 'insert
      :keymaps 'override
      "<up>" nil
      "<down>" nil
      "C-j" nil
      "C-k" nil
      "RET" nil
      "*" nil
      [return] nil))

  (defun ans/set-company-maps (&rest unused)
    "Set maps for when you're inside company completion.
    Arguments (UNUSED) are ignored."
    (general-def
      :states 'insert
      :keymaps 'override
      "<down>" 'company-select-next
      "<up>" 'company-select-previous
      "C-j" 'company-select-next
      "C-k" 'company-select-previous
      "RET" 'company-complete
      "*" 'counsel-company
      [return] 'company-complete))

  (setq nrepl-log-messages t)
  (map! :map cider-repl-mode-map
        :ni "<down>" #'cider-repl-forward-input
        :ni "<up>" #'cider-repl-backward-input)
  (remove-hook 'cider-connected-hook #'+clojure--cider-dump-nrepl-server-log-h)
  (add-hook 'cider-repl-mode-hook '(lambda () (setq scroll-conservatively 101))))

(set-frame-parameter (selected-frame) 'alpha '(100 100))
(add-to-list 'default-frame-alist '(alpha 100 100))

(map! :n "C-l" #'+workspace/switch-right
      :n "C-h" #'+workspace/switch-left)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((eval progn
           (defun alix-client/send-to-repl
               (exp ns)
             (nrepl-sync-request:eval exp
                                      (or
                                       (cider-current-connection)
                                       (car
                                        (cider-connections)))
                                      ns))
           (defun alix-client/reload nil
             (interactive)
             (alix-client/send-to-repl "(mount-root)" "analis-desktop.core"))
           (defun alix-client/show-app-db nil
             (interactive)
             (alix-client/send-to-repl "(.log js/console @re-frame.db/app-db)" "analis-desktop.core"))
           (defun alix-client/init nil
             (interactive)
             (alix-client/send-to-repl "(init)" "analis-desktop.core"))
           (defun alix-client/clear nil
             (interactive)
             (alix-client/send-to-repl "(re-frame/clear-subscription-cache!)" "analis-desktop.core"))
           (defun alix-client/send-to-core
               (msg)
             (interactive)
             (alix-client/send-to-repl msg "analis-desktop.core"))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

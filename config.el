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
(setq doom-font (font-spec :family "Fira Code" :size 20)
      doom-big-font (font-spec :family "Fira Code" :size 36)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 22))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-horizon)

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

(setq tramp-copy-size-limit (* 1024 1024 1024 1024)
      tramp-inline-compress-start-size (* 1024 1024 1024 1024))

(remove-hook! prog-mode vi-tilde-fringe-mode)

(after! evil-collection
  (setq evil-collection-mode-list
        (delete 'lispy evil-collection-mode-list)))

(use-package super-save
  :hook (prog-mode . super-save-mode))

(use-package hungry-delete
  :hook (prog-mode . global-hungry-delete-mode))

(add-hook! prog-mode
           #'electric-pair-mode
           #'electric-indent-mode
           #'electric-layout-mode
           #'electric-quote-mode)

(use-package aggressive-indent
  :hook (prog-mode . global-aggressive-indent-mode))

(use-package git-auto-commit-mode
  :config
  (setq gac-automatically-push-p t
        gac-automatically-add-new-files-p t))

;; Disable flycheck for emacs-lisp
(add-hook! emacs-lisp-mode
  (after! flycheck
    (flycheck-mode -1)))

(after! lispy
  (lispyville-set-key-theme '(slurp/barf-lispy
                              text-objects
                              lispyville-prettify
                              escape
                              additional-movement
                              commentary
                              mark-toggle)))

(after! centaur-tabs
  (map! (:map centaur-tabs-mode-map
          "C-h" #'centaur-tabs-backward
          "C-l" #'centaur-tabs-forward)))

(after! neotree
  (setq neo-autorefresh t))

(after! org
  (defun org-journal-find-location ()
    ;; Open today's journal, but specify a non-nil prefix argument in order to
    ;; inhibit inserting the heading; org-capture will insert the heading.
    (org-journal-new-entry t)
    ;; Position point on the journal's top-level heading so that org-capture
    ;; will add the new entry as a child entry.
    (goto-char (point-min)))

  (setq org-journal-file-type 'daily
        org-journal-enable-agenda-integration t)

  (setq org-default-notes-file
        (expand-file-name +org-capture-notes-file org-directory)
        org-capture-templates
        '(("t" "Personal todo" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* [ ] %?\n%i\n" :prepend t)
          ("n" "Personal notes" entry
           (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n%i\n%a" :prepend t)
          ("j" "Journal entry" entry #'org-journal-find-location
           "* %(format-time-string org-journal-time-format)\n%i%?")

          ;; Will use {project-root}/{todo,notes,changelog}.org, unless a
          ;; {todo,notes,changelog}.org file is found in a parent directory.
          ;; Uses the basename from `+org-capture-todo-file',
          ;; `+org-capture-changelog-file' and `+org-capture-notes-file'.
          ("p" "Templates for projects")
          ("pt" "Project-local todo" entry ; {project-root}/todo.org
           (file+headline +org-capture-project-todo-file "Inbox")
           "* TODO %?\n%i\n%a" :prepend t)
          ("pn" "Project-local notes" entry ; {project-root}/notes.org
           (file+headline +org-capture-project-notes-file "Inbox")
           "* %U %?\n%i\n%a" :prepend t)
          ("pc" "Project-local changelog" entry ; {project-root}/changelog.org
           (file+headline +org-capture-project-changelog-file "Unreleased")
           "* %U %?\n%i\n%a" :prepend t)

          ;; Will use {org-directory}/{+org-capture-projects-file} and store
          ;; these under {ProjectName}/{Tasks,Notes,Changelog} headings. They
          ;; support `:parents' to specify what headings to put them under, e.g.
          ;; :parents ("Projects")
          ("o" "Centralized templates for projects")
          ("ot" "Project todo" entry
           #'+org-capture-central-project-todo-file
           "* TODO %?\n %i\n %a"
           :heading "Tasks"
           :prepend nil)
          ("on" "Project notes" entry
           #'+org-capture-central-project-notes-file
           "* %U %?\n %i\n %a"
           :heading "Notes"
           :prepend t)
          ("oc" "Project changelog" entry
           #'+org-capture-central-project-changelog-file
           "* %U %?\n %i\n %a"
           :heading "Changelog"
           :prepend t)))

  (setq org-agenda-span 14
        org-agenda-start-on-weekday nil
        org-agenda-start-day "0d")

  (setq org-ellipsis " ▾ "
        org-bullets-bullet-list '("◉" "○" "✸" "✿" "✤"))

  (appendq! +pretty-code-symbols
            '(:checkbox   "☐"
                          :pending    "◼"
                          :checkedbox "☑"
                          :results "🠶"
                          :begin_quote "❮"
                          :end_quote "❯"
                          :em_dash "—"))

  (set-pretty-symbols! 'org-mode
    :merge t
    :checkbox   "[ ]"
    :pending    "[-]"
    :checkedbox "[X]"
    :results "#+RESULTS:"
    :begin_quote "#+BEGIN_QUOTE"
    :end_quote "#+END_QUOTE"
    :em_dash "---"))

;; (add-hook! window-setup #'doom-load-session)
;; (add-hook! kill-emacs #'doom-save-session)

(defun window-quarter-height ()
  (max 1 (/ (1- (window-height (selected-window))) 4)))

(after! ivy
  (map! :n "?" #'+ivy/project-search
        :n "/" #'counsel-grep-or-swiper))

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

(use-package lispy
  :hook ((common-lisp-mode . lispy-mode)
         (emacs-lisp-mode . lispy-mode)
         (scheme-mode . lispy-mode)
         (racket-mode . lispy-mode)
         (hy-mode . lispy-mode)
         (lfe-mode . lispy-mode)
         (dune-mode . lispy-mode)
         (clojure-mode . lispy-mode))
  :config
  (setq lispy-close-quotes-at-end-p t)
  (add-hook 'lispy-mode-hook #'turn-off-smartparens-mode))

(use-package! lispyville
  :when (featurep! :editor evil)
  :hook (lispy-mode . lispyville-mode)
  :config
  (lispyville-set-key-theme
   '((operators normal)
     c-w
     (prettify insert)
     (atom-movement normal visual)
     slurp/barf-lispy
     additional
     additional-insert)))

(after! projectile
  (pushnew! projectile-project-root-files "project.clj" "build.boot" "deps.edn")
  (add-to-list 'projectile-globally-ignored-directories "webapp/src/styles")
  (add-to-list 'projectile-globally-ignored-directories "src/styles")
  (add-to-list 'projectile-globally-ignored-directories "webapp/node_modules")
  (add-to-list 'projectile-globally-ignored-directories "src/dist")
  (add-to-list 'projectile-globally-ignored-directories "dist"))

(advice-add 'evil-window-up
            :after
            (lambda (arg)
              (when (string-equal " *NeoTree*" (buffer-name (current-buffer)))
                (evil-window-right 1))))

(after! aggressive-indent
  (add-to-list 'aggressive-indent-excluded-modes 'typescript-mode))

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
            (lambda!
             (when prettier-js-mode
               (prettier-js)))))

(setq-hook! web-mode
  web-mode-markup-indent-offset 2)

(advice-remove 'evil-delete-backward-char-and-join #'+evil-delete-region-if-mark-a)

(after! company
  (setq company-idle-delay 0
        company-echo-delay 0
        company-tooltip-idle-delay 0)

  (define-key! company-active-map
    "RET"       #'company-complete-selection
    [return]    #'company-complete-selection))

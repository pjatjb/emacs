;;

(setq
 package-check-signature nil
 package-archive-priorities '(("gnu" . 10)
			      ("nongnu" . 8)
                              ("melpa" . 5))
 package-archives  '(("melpa" . "https://melpa.org/packages/")
                     ("gnu" . "https://elpa.gnu.org/packages/")
                     ("nongnu" . "https://elpa.nongnu.org/nongnu/"))
 package-install-upgrade-built-in t) ;; For Magit on Linux

(require 'package)
(package-initialize)
(unless package-archive-contents (package-refresh-contents))

(package-install 'use-package)
(use-package use-package-ensure-system-package
  :init
  (setq system-packages-package-manager 'brew
        system-packages-no-confirm t))
(require 'use-package-ensure)
(setq use-package-always-ensure t)
(use-package system-packages)

(use-package exec-path-from-shell
  :init
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-envs '("LIBRARY_PATH" "INFOPATH" "CPATH" "MANPATH")))

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (setq auto-package-update-interval 30)
  (auto-package-update-maybe))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Theme

(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :height 150))

(use-package auto-dark ;; https://github.com/LionyxML/auto-dark-emacs
  :init
  (setq auto-dark-allow-osascript t)
  (auto-dark-mode)
  :config
  :custom
  (auto-dark-themes '((leuven-dark) (leuven))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Multimedia

(use-package bongo
  :disabled
  :ensure-system-package (vlc))

(use-package eradio ;; https://github.com/olavfosse/eradio
  :ensure-system-package (vlc)
  :config
  (setq  eradio-channels
         '(("Underground 80s" . "https://somafm.com/u80s256.pls")
           ("Left Coast 70s" . "https://somafm.com/seventies320.pls")
           ("Abacus British Comedy" . "http://www.abacusradio.com/british_comedy_radio.html")
           ("Solar" . "http://msmn4.co/proxy/mp3high33?mp=/"))))

;;(use-package volume)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Editing

(use-package move-dup
  :bind
  ("C-M-n" . move-dup-duplicate-down)
  ("C-M-p" . move-dup-duplicate-up))

(use-package multiple-cursors
  :bind
  ("C-<"           . mc/mark-previous-like-this)
  ("C->"           . mc/mark-next-like-this)
  ("C-S-<mouse-1>" . mc/add-cursor-on-click)
  ("C-S-c C-S-c"   . mc/edit-lines)
  ("C-c C-<"       . mc/mark-all-like-this)
  :config
  (mc/always-repeat-command t)
  (mc/always-run-for-all t))

(use-package unfill)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Views

(use-package adaptive-wrap
  :hook
  (markdown-mode . adaptive-wrap-prefix-mode))

(use-package look-mode)                ;; Browse all files in a list

(use-package olivetti ;; https://github.com/rnkn/olivetti
  :init
  (setq olivetti-body-width nil)
  :bind
  ("C-c o" . olivetti-mode))

(use-package writeroom-mode ;; Distraction-free https://github.com/joostkremers/writeroom-mode
  :config
   (setq writeroom-width 120))

(use-package yafolding
  :hook
  (prog-mode . yafolding-mode))

(use-package csv-mode
  :disabled
;;  :config
;;  (csv-align-max-width . 80)
;;  (csv-align-style . 'left)
;;  (csv-separators . (":"))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Writing Tools

(use-package flycheck)

(use-package flyspell)

(use-package langtool
  :config
  (setq langtool-default-language 'auto
        langtool-language-tool-jar "/opt/homebrew/opt/languagetool/libexec/languagetool-commandline.jar") ;; macOS
  :ensure-system-package
  ((java) (languagetool)))

(use-package flycheck-languagetool)

(use-package smog ;; Style stats https://github.com/zzkt/smog
  :ensure-system-package style)

(use-package writegood-mode) ;; Style checker https://github.com/bnbeckwith/writegood-mode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Markdown

(use-package flymake-markdownlint
  :ensure-system-package markdownlint)

(use-package markdown-mode ;; needs multimarkdown
  :ensure flymake-markdownlint
  :hook
  (markdown-mode . adaptive-wrap-prefix-mode)
  (markdown-mode . flymake-markdownlint-setup)
  (markdown-mode . flymake-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Programming

(use-package jsonnet-mode ;; https://github.com/tminor/jsonnet-mode
  :init
  (setq jsonnet-fmt-command "jsonnetfmt"
;;        jsonnet-library-search-directories '("path/to")
        ))

(use-package yaml-mode
  :hook
  (yaml-mode . yafolding-mode))

(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;;(use-package realgud :config (setq realgud:pdb-command-name "python3 -m pdb")) ;; https://github.com/realgud/realgud
;;(use-package slime) ;; lisp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Terminals

(use-package multi-term
  :config
  (setq multi-term-buffer-name "TERM")
  :bind
  ("C-c t" . multi-term))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Git & GitHub

(use-package magit)

(use-package ox-gfm) ;; GFM Markdown can be copied/pasted into Confluence

(use-package lorem-ipsum)

(use-package htmlize) ;; Prevent emacs theme affecting org exports

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LaTeX

(use-package latex
;; parented by auctex, needs pdflatex (mactex-no-gui or texlive-full)
  :ensure auctex
  :custom
   (org-latex-classes
    '(("letter" "\\documentclass{letter}"
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
      ("article" "\\documentclass[11pt]{article}"
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
       ("\\paragraph{%s}" . "\\paragraph*{%s}")
       ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
      ("report" "\\documentclass[11pt]{report}"
       ("\\part{%s}" . "\\part*{%s}")
       ("\\chapter{%s}" . "\\chapter*{%s}")
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
      ("book" "\\documentclass[11pt]{book}"
       ("\\part{%s}" . "\\part*{%s}")
       ("\\chapter{%s}" . "\\chapter*{%s}")
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
   (org-latex-minted-options
    '(("fontsize" "\\scriptsize")
      ("framesep" "10pt")
      ("bgcolor" "AliceBlue")))
   (org-latex-packages-alist '(("" "minted" nil nil)))
   (org-latex-pdf-process
    '("%latex -interaction nonstopmode -output-directory %o %f" "%latex -interaction nonstopmode -output-directory %o %f")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Graphics

(use-package graphviz-dot-mode ;; https://github.com/ppareit/graphviz-dot-mode
  :ensure-system-package (dot . graphviz))

(use-package plantuml-mode
  :ensure-system-package plantuml
  :init
  (setq org-plantuml-jar-path "/opt/homebrew/Cellar/plantuml/1.2025.0/libexec/plantuml.jar")) ;; macOS - Path changes regularly

(use-package ob-mermaid
  :init
  (setq ob-mermaid-cli-path "/opt/homebrew/bin/mmdc")) ;; macOS
;; npm install -g @mermaid-js/mermaid-cli

(use-package org-contrib)

(use-package org-preview-html) ;; https://github.com/jakebox/org-preview-html

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Task management

(use-package org-journal
  :bind
  ("C-c j j" . org-journal-open-current-journal-file)
  ("C-c j n" . org-journal-new-entry)
  :init
   (setq org-journal-carryover-delete-empty-journal 'never
         org-journal-date-format "%A, %d %B %Y"
         org-journal-dir "~/org/journal/"
         org-journal-file-type 'yearly
         org-journal-file-format "%Y.org"
         org-journal-follow-mode t
         org-journal-file-header "#+BEGIN: clocktable :link t :scope agenda :fileskip0 t :stepskip0 t :hidefiles t :tags t :indent nil :narrow 200 :tcolumns 2 :step day :block %Y\n#+END:"
         ))

(use-package org-journal-list)

(use-package org-jira ;; https://github.com/ahungry/org-jira
  :custom
  (org-jira-deadline-duedate-sync-p nil)
  (org-jira-default-jql "assignee = currentUser() AND status != Closed ORDER BY key")
  (org-jira-done-states '("CLOSED" "RESOLVED" "DONE"))
  (org-jira-download-ask-override nil)
  (org-jira-download-comments nil)
  (org-jira-priority-to-org-priority-alist '(("Critial" . 65) ("Minor" . 67)))
  (org-jira-priority-to-org-priority-omit-default-priority t)
  (org-jira-progress-issue-flow
   '(("To Do" . "Start Progress")
     ("In Progress" . "Completed Pending Merge")
     ("Pending Merge" . "Close")))
  (org-jira-reverse-comment-order t)
  (org-jira-use-status-as-todo t)
  (org-jira-working-dir "~/org/"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; File management

(use-package deadgrep ;; https://github.com/Wilfred/deadgrep Requires ripgrep
  :bind ("C-c g" . deadgrep)
  :ensure-system-package rg)

(use-package deft ;; https://github.com/jrblevin/deft
  :bind
  ("C-c d d" . deft)
  ("C-c d m" . deft-new-file-named)
  ("C-c d n" . deft-new-file)
  :commands (deft)
  :config
   (setq deft-directory "~/org/notes"
         deft-extensions '("org" "text" "md" "markdown" "txt")
         deft-default-extension "org"
         deft-new-file-format "%Y%m%d%H%M"
         deft-recursive t
         deft-use-filename-as-title t))

;;(require 'wc-mode)
;; (setq wc-modeline-format "[Wd: %tw, Ch: %tc]") (wc-mode t)
;; :bind ("\C-cc" . wc-mode))

;;(use-package ox-reveal :config (setq org-reveal-title-slide nil)) ;;(setq org-reveal-root "file:///path/to/reveal.js") ;; Or use REVEAL_ROOT in org file
;;(use-package projectile :disabled :init (projectile-mode +1) :config (setq projectile-project-search-path '("~/Documents/projects/" ("~/gh" . 1))) :bind (:map projectile-mode-map ("s-p" . projectile-command-map) ("C-c p" . projectile-command-map))) ;; https://docs.projectile.mx/projectile/

;; Publish an org-based static website
;; (require 'ox-publish)
;; (setq org-publish-project-alist
;;       '(("org-notes"
;;          :base-directory "~/path/to/docs/"
;;          :base-extension "org"
;;          :publishing-directory "~/Downloads/public_html/"
;;          :recursive t
;;          :publishing-function org-html-publish-to-html
;;          :headline-levels 4             ; Just the default for this project.
;;          :auto-preamble t)
;;         ("org-static"
;;          :base-directory "~/path/to/docs/"
;;          :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
;;          :publishing-directory "~/Downloads/public_html/"
;;          :recursive t
;;          :publishing-function org-publish-attachment)
;;         ("my-docs" :components ("org-notes" "org-static"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Custom functions

(defun sort-symbols (reverse beg end)
  "Sort symbols in region alphabetically, in REVERSE if negative. See `sort-words'."
  (interactive "*P\nr")
  (sort-regexp-fields reverse "\\(\\sw\\|\\s_\\)+" "\\&" beg end))

(defun sort-words (reverse beg end)
  "Sort words in region alphabetically, in REVERSE if negative. Prefixed with negative \\[universal-argument], sorts in reverse. The variable `sort-fold-case' determines whether alphabetic case affects the sort order. See `sort-regexp-fields'."
  (interactive "*P\nr")
  (sort-regexp-fields reverse "\\w+" "\\&" beg end))

;; Don't confirm these when evaluating org babel
;;(defun my-org-confirm-babel-evaluate (lang body) (not (or (string= lang "plantuml") (string= lang "mermaid") (string= lang "shell") (string= lang "sh") (string= lang "zsh") (string= lang "bash") (string= lang "ditaa") (string= lang "emacs-lisp"))))
;;(setq org-confirm-babel-evaluate #'my-org-confirm-babel-evaluate)

;; (defun farynaio/org-link-copy (&optional arg)
;;   "Extract URL from org-mode link and add it to kill ring."
;;   (interactive "P")
;;   (let* ((link (org-element-lineage (org-element-context) '(link) t))
;;           (type (org-element-property :type link))
;;           (url (org-element-property :path link))
;;           (url (concat type ":" url)))
;;     (kill-new url)
;;     (message (concat "Copied URL: " url))))
;;(define-key org-mode-map (kbd "C-x C-l") 'farynaio/org-link-copy)

(defun copy-org-link-to-killring ()
   "Extract the link location at point and put it on the killring."
   (interactive)
   (when (org-in-regexp org-bracket-link-regexp 1)
     (kill-new (org-link-unescape (org-match-string-no-properties 1)))))

(defun pj/org-capture-template-post()
  (let
      ((fpath
        (concat
         (read-file-name "File name: "
                         (concat
                          (file-name-as-directory org-directory)
                          "notes"
                          (format-time-string "%Y%m%dT%H%M%S")
                          "-")
                         nil nil nil)
         ".org")))
        (find-file fpath)
        (goto-char
         (point-min))))

;; https://emacs.stackexchange.com/questions/62376/slow-markdown-mode-as-emacs-spends-lots-of-time-fontifying
(defconst markdown-regex-italic
    "\\(?:^\\|[^\\]\\)\\(?1:\\(?2:[_]\\)\\(?3:[^ \n\t\\]\\|[^ \n\t]\\(?:.\\|\n[^\n]\\)[^\\ ]\\)\\(?4:\\2\\)\\)")
;; and/or
(defconst markdown-regex-gfm-italic
    "\\(?:^\\|[^\\]\\)\\(?1:\\(?2:[_]\\)\\(?3:[^ \\]\\2\\|[^ ]\\(?:.\\|\n[^\n]\\)\\)\\(?4:\\2\\)\\)")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Keymaps

(when (eq system-type 'darwin)
  ;; when using Windows keyboard on Mac, the insert key is mapped to <help>
  ;; copy ctrl-insert, paste shift-insert on windows keyboard
  (global-set-key [C-help] #'clipboard-kill-ring-save)
  (global-set-key [S-help] #'clipboard-yank)
  (global-set-key [help] #'overwrite-mode) ;; Press insert to toggle `overwrite-mode'
  (setq dired-use-ls-dired nil)) ;; macOS complains

;; Allow spaces in minibuffer (for org-roam)
(define-key minibuffer-local-completion-map (kbd "SPC") 'self-insert-command)

(global-unset-key (kbd "C-z"))
(when (fboundp 'windmove-default-keybindings) (windmove-default-keybindings)) ;; Use WindMove : S-<up>, S-<down>, S-<left>, S-<right>

(keymap-global-set "<f12>"         'calendar)
(keymap-global-set "C-c a"         'org-agenda)
(keymap-global-set "C-c c"         'org-capture)
(keymap-global-set "C-c h c"       'highlight-changes-mode)
(keymap-global-set "C-c l"         'org-store-link)
(keymap-global-set "C-c C"         'copy-org-link-to-killring)
(keymap-global-set "C-c m"         'calendar)
(keymap-global-set "C-c n"         'org-num-mode)
(keymap-global-set "C-x C-b"       'buffer-menu) ;; Go directly to buffer list
(keymap-global-set "M-Q"           'unfill-paragraph)
(keymap-global-set "M-n"           'move-dup-move-lines-down)
(keymap-global-set "M-p"           'move-dup-move-lines-up)

(with-eval-after-load 'magit-mode (define-key magit-mode-map (kbd "<C-tab>") nil)) ;; Keep C-Tab for Tab navigation

(add-hook 'text-mode-hook     'flyspell-mode)
(add-hook 'write-file-hooks   'delete-trailing-whitespace) ;; Delete trailing spaces on save
(add-hook 'org-mode           'org-indent-mode) ;; Indents section headings in place of multiple '*'

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-PDF-mode nil)
 '(TeX-save-query nil)
 '(async-shell-command-buffer 'new-buffer)
 '(auto-package-update-delete-old-versions t)
 '(auto-package-update-hide-results t)
 '(auto-package-update-interval 30)
 '(auto-save-file-name-transforms '((".*" "~/.emacs_saves/" t)))
 '(backup-directory-alist '(("." . "~/.emacs_saves")))
 '(blink-cursor-blinks 0)
 '(calendar-date-style 'iso)
 '(calendar-week-start-day 1)
 '(case-fold-search t)
 '(column-number-mode t)
 '(cursor-flash-interval 0.5)
 '(cursor-type t)
 '(delete-active-region nil)
 '(delete-by-moving-to-trash t)
 '(diary-file "~/org/diary")
 '(dired-dwim-target t)
 '(dired-listing-switches "-alh")
 '(display-line-numbers-type nil)
 '(electric-indent-mode t)
 '(epg-pinentry-mode 'loopback)
 '(flycheck-checker-error-threshold nil)
 '(global-flycheck-mode nil)
 '(global-highlight-changes-mode nil)
 '(global-visual-line-mode t)
 '(gnutls-algorithm-priority "normal:-vers-tls1.3")
 '(highlight-changes-global-changes-existing-buffers t)
 '(image-dired-main-image-directory "~/Pictures")
 '(image-dired-slideshow-delay 2.0)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(jiralib-update-issue-fields-exclude-list nil)
 '(jiralib-url "https://jitterbit.atlassian.net")
 '(jiralib-worklog-import--filters-alist
   '((nil "WorklogUpdatedByCurrentUser"
          (lambda
            (wl)
            (let-alist wl
              (when
                  (and wl
                       (string-equal
                        (downcase
                         (or jiralib-user-login-name user-login-name ""))
                        (downcase
                         (or \.updateAuthor.name
                             (car
                              (split-string
                               (or \.updateAuthor.emailAddress "")
                               "@"))
                             ""))))
                wl))))
     (nil "WorklogAuthoredByCurrentUser"
          (lambda
            (wl)
            (let-alist wl
              (when
                  (and wl
                       (string-equal
                        (downcase
                         (or jiralib-user-login-name user-login-name))
                        (downcase
                         (or \.author.name
                             (car
                              (split-string
                               (or \.author.emailAddress "")
                               "@"))))))
                wl))))))
 '(langtool-default-language 'auto)
 '(legacy-style-world-list nil)
 '(line-move-visual nil)
 '(magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1)
 '(magit-git-executable "/usr/bin/git")
 '(markdown-asymmetric-header t)
 '(markdown-command "multimarkdown")
 '(markdown-enable-highlighting-syntax t)
 '(markdown-enable-math t)
 '(markdown-preview-auto-open 'file)
 '(ns-antialias-text t)
 '(org-adapt-indentation t)
 '(org-agenda-cmp-user-defined
   '\(cond\ \(\(string-collate-lessp\ a\ b\)\ +1\)\ \(\(string-collate-lessp\ b\ a\)\ -1\)\ \(t\ nil\)\))
 '(org-agenda-file-regexp "\\`[^.].*\\.org\\'\\|[0-9]+$")
 '(org-agenda-files '("~/org/DOCS.org" "~/org/todo.org"))
 '(org-agenda-restore-windows-after-quit t)
 '(org-agenda-skip-unavailable-files t)
 '(org-agenda-tags-column -120)
 '(org-agenda-window-setup 'other-tab)
 '(org-babel-load-languages
   '((latex . t)
     (emacs-lisp . t)
     (ditaa . t)
     (shell . t)
     (plantuml . t)))
 '(org-capture-templates
   '(("o" "New ORG file" plain #'pj/org-capture-template-post "#+TITLE: %^{Title}")
     ("t" "Instant TODO" entry
      (file "~/org/todo.org")
      "** TODO %^{What?}")))
 '(org-clock-idle-time 10)
 '(org-clock-mode-line-total 'today)
 '(org-clock-persist t)
 '(org-clock-report-include-clocking-task t)
 '(org-clock-rounding-minutes 0)
 '(org-default-notes-file "~/org/capture.org")
 '(org-ditaa-jar-path
   "/opt/homebrew/Cellar/ditaa/0.11.0_1/libexec/ditaa-0.11.0-standalone.jar")
 '(org-export-backends '(ascii html latex md odt confluence))
 '(org-export-with-entities nil)
 '(org-export-with-properties nil)
 '(org-export-with-toc nil)
 '(org-extend-today-until 2)
 '(org-fold-catch-invisible-edits 'error)
 '(org-indirect-buffer-display 'current-window)
 '(org-link-descriptive t)
 '(org-outline-path-complete-in-steps t)
 '(org-preview-html-viewer 'xwidget)
 '(org-refile-targets '((org-agenda-files :maxlevel . 9)))
 '(org-refile-use-outline-path 'file)
 '(org-src-lang-modes
   '(("C" . c)
     ("C++" . c++)
     ("asymptote" . asy)
     ("bash" . sh)
     ("beamer" . latex)
     ("calc" . fundamental)
     ("cpp" . c++)
     ("ditaa" . artist)
     ("desktop" . conf-desktop)
     ("dot" . graphviz-dot)
     ("elisp" . emacs-lisp)
     ("ocaml" . tuareg)
     ("screen" . shell-script)
     ("shell" . sh)
     ("sqlite" . sql)
     ("toml" . conf-toml)
     ("plantuml" . plantuml)))
 '(org-startup-folded t)
 '(org-tags-column 0)
 '(org-timestamp-custom-formats '("%A %d %B %Y" . "%m/%d/%y %a %H:%M"))
 '(org-todo-keyword-faces
   '(("OPEN" . org-todo)
     ("IN-PROGRESS" . org-dispatcher-highlight)
     ("BLOCKED" . org-warning)
     ("MORE-INFO-REQUIRED" . org-warning)
     ("IN-PROGRESS" . org-special-keyword)
     ("PENDING-MERGE" . org-done)))
 '(org-todo-keywords
   '((sequence "TODO" "BUSY" "OPEN" "IN-PROGRESS" "PENDING-MERGE" "HOLD" "BLOCKED" "MORE-INFO-REQUIRED" "|" "DONE" "CLOSED")))
 '(package-selected-packages
   '(writegood-mode smog use-package-ensure-system-package use-package eradio yaml-mode yafolding writeroom-mode verilog-mode unfill tramp svg soap-client so-long python plantuml-mode ox-gfm outline-indent org-preview-html org-mind-map org-journal-list org-journal org-jira org-contrib olivetti ob-mermaid ntlm nadvice multiple-cursors multi-term move-dup markdown-mode map magit lorem-ipsum look-mode let-alist langtool jsonnet-mode idlwave htmlize graphviz-dot-mode flymake-markdownlint flycheck-languagetool faceup exec-path-from-shell erc eglot deadgrep csv-mode cl-generic auto-package-update auto-dark auctex adaptive-wrap))
 '(safe-local-variable-values '((org-jira-mode . t) org-jira-mode t))
 '(sentence-end-double-space nil)
 '(size-indication-mode t)
 '(split-height-threshold nil)
 '(split-width-threshold nil)
 '(tab-bar-close-button-show nil)
 '(tab-bar-format
   '(tab-bar-format-history tab-bar-format-tabs tab-bar-separator tab-bar-format-add-tab))
 '(tab-bar-mode t)
 '(tab-bar-new-tab-choice t)
 '(tab-bar-select-tab-modifiers '(super))
 '(tab-bar-tab-hints nil)
 '(tab-line-new-tab-choice 'selected-window)
 '(text-mode-hook '(flyspell-mode text-mode-hook-identify))
 '(tool-bar-mode nil)
 '(tramp-default-method "ssh")
 '(tramp-encoding-shell "/bin/bash")
 '(visible-bell t)
 '(world-clock-list
   '(("Australia/Melbourne" "Melbourne")
     ("America/Los_Angeles" "Los Angeles")
     ("America/New_York" "New York")
     ("America/Sao_Paulo" "Sao Paulo")
     ("Europe/Istanbul" "Istanbul")))
 '(world-clock-time-format "%a, %d %b %I:%M %p %Z"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "red1"))))
 '(highlight-changes-delete ((t (:foreground "red1" :underline t))))
 '(markdown-code-face ((t (:inherit nil))))
 '(tab-bar ((t (:background "grey85" :foreground "black"))))
 '(tab-bar-tab ((t (:background "red1" :foreground "white" :weight bold))))
 '(tab-bar-tab-group-current ((t nil)))
 '(tab-bar-tab-inactive ((t nil)))
 '(tab-line ((t (:background "grey85" :foreground "black")))))
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'scroll-left 'disabled nil)
(put 'magit-edit-line-commit 'disabled nil)

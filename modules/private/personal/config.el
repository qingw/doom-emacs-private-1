;;; config.el -*- lexical-binding: t; -*-

;; (after! evil (load! +bindings))
(load! "+bindings")

(setq
 which-key-idle-delay 0.3
 which-key-sort-order #'which-key-key-order-alpha
 minibuffer-message-timeout 3
 counsel-projectile-ag-initial-input '(projectile-symbol-or-selection-at-point)

 projectile-ignored-projects '("~/" "/tmp")
 counsel-find-file-at-point t
 ivy-extra-directories '("./")

 delete-by-moving-to-trash t
 counsel-evil-registers-height 20
 counsel-yank-pop-height 20
 visual-fill-column-center-text t
 ;; evil-escape-key-sequence nil
 line-spacing nil
 frame-resize-pixelwise t
 electric-pair-inhibit-predicate 'ignore

 persp-interactive-init-frame-behaviour-override -1
 +rss-elfeed-files '("elfeed.org")
 ;; browse-url-browser-function 'xwidget-webkit-browse-url
 mac-frame-tabbing nil
 counsel-org-goto-face-style 'org
 counsel-org-headline-display-style 'title
 counsel-org-headline-display-tags t
 counsel-org-headline-display-todo t
 +ivy-buffer-icons nil
 ivy-use-virtual-buffers t
 ;; tramp
 tramp-default-method "ssh"
 tramp-ssh-controlmaster-options "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=600"
 ;; tramp-remote-process-environment (quote ("TMOUT=0" "LC_CTYPE=''" "TRAMP='yes'" "CDPATH=" "HISTORY=" "MAIL=" "MAILCHECK=" "MAILPATH=" "PAGER=cat" "autocorrect=" "correct=" "http_proxy=http://proxy.cse.cuhk.edu.hk:8000" "https_proxy=http://proxy.cse.cuhk.edu.hk:8000" "ftp_proxy=http://proxy.cse.cuhk.edu.hk:8000"))

 ;; plantuml and dot
 plantuml-jar-path (concat "~/.doom.d/local/" "plantuml.jar")
 org-plantuml-jar-path plantuml-jar-path


 alert-default-style 'notifier

 )

(after! projectile
  (setq projectile-ignored-project-function
        (lambda (root)
          (or (file-remote-p root)
              (string-match "/tmp/.*" root)
              (string-match ".*Trash.*" root)
              (string-match ".*Cellar.*" root)))))

;; *** Company
(after! company
  (setq company-tooltip-limit 10
        company-minimum-prefix-length 2
        company-idle-delay 0.2
        company-tooltip-minimum-width 60
        company-tooltip-margin 0
        company-show-numbers t
        company-tooltip-offset-display nil
        company-dabbrev-downcase nil
        company-dabbrev-ignore-case nil
        company-dabbrev-code-other-buffers t
        company-tooltip-align-annotations t
        company-require-match 'never
        ;; company-frontends '(company-childframe-frontend company-echo-metadata-frontend)
        company-global-modes '(not comint-mode erc-mode message-mode help-mode gud-mode)
        company-childframe-child-frame nil))
(set-company-backend! '(emacs-lisp-mode) '(company-elisp company-files company-yasnippet company-dabbrev-code))
(set-company-backend! '(python-mode) '(company-anaconda company-files company-yasnippet company-dabbrev-code))
(set-company-backend! '(inferior-python-mode) '(company-capf company-files company-yasnippet company-dabbrev-code))
(set-company-backend! '(inferior-ess-mode) '(company-capf company-files company-yasnippet company-dabbrev-code))
(set-company-backend! '(org-mode) '(company-capf company-files company-yasnippet company-dabbrev))
(set-lookup-handlers! 'emacs-lisp-mode :documentation #'helpful-at-point)

;; ** Help
(after! helpful
  (set-lookup-handlers! 'helpful-mode :documentation #'helpful-at-point)
  (set-popup-rule! "^\\*helpful.*"
    '((size . 80) (side . right))
    '((select . t) (quit . t))))

(def-package! tldr
  :commands (tldr)
  :config
  (setq tldr-directory-path (concat doom-etc-dir "tldr/"))
  (set-popup-rule! "^\\*tldr\\*"
    '((size . 80) (side . right))
    '((transient . nil)  (modeline . nil) (select . t) (quit . t))))

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . 'dark))

;; ** Tramp
(after! tramp-sh
  (add-to-list 'tramp-remote-path ""))
(def-package! counsel-tramp
  :commands (counsel-tramp)
  )
;; (def-package! docker-tramp
;;   :after tramp)

(after! recentf
  (setq recentf-auto-cleanup 60)
  (add-to-list 'recentf-exclude 'file-remote-p)
  (add-to-list 'recentf-exclude ".*\\.gz$")
  (add-to-list 'recentf-exclude ".*\\.gpg$")
  (add-to-list 'recentf-exclude ".*\\.gif$")
  (add-to-list 'recentf-exclude ".*\\.pdf$")
  (add-to-list 'recentf-exclude ".*\\.svg$")
  (add-to-list 'recentf-exclude "/sudo:")
  (add-to-list 'recentf-exclude "/GTAGS$")
  (add-to-list 'recentf-exclude "/GRAGS$")
  (add-to-list 'recentf-exclude "/GPATH$")
  (add-to-list 'recentf-exclude "\\.mkv$")
  (add-to-list 'recentf-exclude "\\.mp[34]$")
  (add-to-list 'recentf-exclude "\\.avi$")
  (add-to-list 'recentf-exclude "\\.sub$")
  (add-to-list 'recentf-exclude "\\.srt$")
  (add-to-list 'recentf-exclude "\\.ass$")
  (add-to-list 'recentf-exclude ".*_archive$")
  (add-to-list 'recentf-exclude "COMMIT_MSG")
  (add-to-list 'recentf-exclude "COMMIT_EDITMSG")
  (add-to-list 'recentf-exclude ".*Cellar.*"))

(after! smartparens
  (add-hook 'minibuffer-setup-hook #'smartparens-mode)
  (add-hook 'eshell-mode-hook #'smartparens-mode)
  ;; Auto-close more conservatively and expand braces on RET
  (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)
  (let ((unless-list '(sp-point-before-word-p
                       sp-point-after-word-p
                       sp-point-before-same-p)))
    (sp-pair "'" nil :unless unless-list)
    (sp-pair "\"" nil :unless unless-list))
  (sp-pair "{" nil :post-handlers '(("||\n[i]" "RET") ("| " " "))
           :unless '(sp-point-before-word-p sp-point-before-same-p))
  (sp-pair "(" nil :post-handlers '(("||\n[i]" "RET") ("| " " "))
           :unless '(sp-point-before-word-p sp-point-before-same-p))
  (sp-pair "[" nil :post-handlers '(("| " " "))
           :unless '(sp-point-before-word-p sp-point-before-same-p)))

(set-window-fringes (minibuffer-window) 0 0 nil)

(after! avy
  (setq avy-keys '(?a ?s ?d ?f ?j ?k ?l ?\;)))
(after! ace-window
  (setq aw-keys '(?f ?d ?s ?r ?e ?w)
        aw-scope 'visible
        ;; aw-scope 'frame
        aw-ignore-current t
        aw-background nil))

;; (def-package-hook! ace-window
;;   :post-config
;;   (setq aw-scope 'visible
;;         aw-background nil)
;;   nil)

;; ** Magit
(def-package! orgit :after magit)
;; (def-package! magit-todos :after magit)

(after! magithub
  (require 'parse-time)
  (defmacro magithub--time-number-of-days-since-string (iso8601)
    `(time-to-number-of-days
      (time-since
       (parse-iso8601-time-string
        (concat ,iso8601 "+00:00")))))

  (defun issue-filter-to-days (days type)
    `(lambda (issue)
       (let ((created_at (magithub--time-number-of-days-since-string
                          (alist-get 'created_at issue)))
             (updated_at (magithub--time-number-of-days-since-string
                          (alist-get 'updated_at issue))))
         (or (< created_at ,days) (< updated_at ,days)))))

  (defun magithub-filter-maybe (&optional limit)
    "Add filters to magithub only if number of issues is greter than LIMIT."
    (let ((max-issues (length (ignore-errors (magithub-issues))))
          (max-pull-requests (length (ignore-errors (magithub-pull-requests))))
          (limit (or limit 1)))
      (when (> max-issues limit)
        (add-to-list (make-local-variable 'magithub-issue-issue-filter-functions)
                     (issue-filter-to-days limit "issues")))
      (when (> max-pull-requests limit)
        (add-to-list (make-local-variable 'magithub-issue-pull-request-filter-functions)
                     (issue-filter-to-days limit "pull-requests")))))

  (add-to-list 'magit-status-mode-hook #'magithub-filter-maybe)
  (setq magithub-clone-default-directory "~/workspace/sources/"))

(after! magit
  ;; (magit-wip-after-save-mode 1)
  ;; (magit-wip-after-apply-mode 1)
  ;; (magithub-feature-autoinject t)
  (setq magit-repository-directories '("~/workspace/"))
  ;; (set-evil-initial-state! 'magit-repolist-mode 'normal)
  ;; (map! (:map with-editor-mode-map
  ;;         (:localleader
  ;;           :desc "Finish" :n "," #'with-editor-finish
  ;;           :desc "Abort"  :n "k" #'with-editor-cancel)))
  ;; (set-popup-rule! "^.*magit" '((slot . -1) (side . right) (size . 80)) '((modeline . nil) (select . t)))
  ;; (set-popup-rule! "^\\*magit.*popup\\*" '((slot . 0) (side . right)) '((modeline . nil) (select . t)))
  ;; (set-popup-rule! "^.*magit-revision:.*" '((slot . 2) (side . right) (window-height . 0.6)) '((modeline . nil) (select . t)))
  ;; (set-popup-rule! "^.*magit-diff:.*" '((slot . 2) (side . right) (window-height . 0.6)) '((modeline . nil) (select . nil)))
  )


;; * Ivy Actions
(after! ivy
  (setq ivy-use-selectable-prompt t
        ivy-auto-select-single-candidate t
        ivy-rich-parse-remote-buffer nil
        +ivy-buffer-icons nil
        ivy-use-virtual-buffers nil
        ivy-magic-slash-non-match-action 'ivy-magic-slash-non-match-cd-selected
        ivy-height 20
        ivy-rich-switch-buffer-name-max-length 50))

(after! counsel
  ;; ** counsel-M-x
  (defun +ivy/helpful-function (prompt)
    (helpful-function (intern prompt)))
  (defun +ivy/find-function (prompt)
    (find-function (intern prompt)))
  (ivy-add-actions
   'counsel-M-x
   `(("h" +ivy/helpful-function "Helpful")
     ("f" +ivy/find-function "Find"))))
(after! counsel-projectile
  (ivy-add-actions
   'counsel-projectile-switch-project
   `(("f" counsel-projectile-switch-project-action-find-file
      "jump to a project file")
     ("d" counsel-projectile-switch-project-action-find-dir
      "jump to a project directory")
     ("b" counsel-projectile-switch-project-action-switch-to-buffer
      "jump to a project buffer")
     ("m" counsel-projectile-switch-project-action-find-file-manually
      "find file manually from project root")
     ("S" counsel-projectile-switch-project-action-save-all-buffers
      "save all project buffers")
     ("k" counsel-projectile-switch-project-action-kill-buffers
      "kill all project buffers")
     ("K" counsel-projectile-switch-project-action-remove-known-project
      "remove project from known projects")
     ("c" counsel-projectile-switch-project-action-compile
      "run project compilation command")
     ("C" counsel-projectile-switch-project-action-configure
      "run project configure command")
     ("E" counsel-projectile-switch-project-action-edit-dir-locals
      "edit project dir-locals")
     ("v" counsel-projectile-switch-project-action-vc
      "open project in vc-dir / magit / monky")
     ("sr" counsel-projectile-switch-project-action-rg
      "search project with rg")
     ("xs" counsel-projectile-switch-project-action-run-shell
      "invoke shell from project root")
     ("xe" counsel-projectile-switch-project-action-run-eshell
      "invoke eshell from project root")
     ("xt" counsel-projectile-switch-project-action-run-term
      "invoke term from project root")
     ("O" counsel-projectile-switch-project-action-org-capture
      "org-capture into project"))))

;; https://en.wikipedia.org/wiki/list_of_tz_database_time_zones
(setq display-time-world-list
      '(("America/New_York" "New York")
        ("America/Los_Angeles" "Seattle")
        ("Asia/Shanghai" "Shanghai")
        ("Asia/Tokyo" "Tokyo")
        ("Australia/Sydney" "Sydney")
        ("Europe/London" "London")
        ("Europe/Berlin" "Germany")
        ("Europe/Rome" "Italy")
        ("Europe/Paris" "Paris")))

;; quick way to dispaly world time clock
(defalias 'wc 'display-time-world)

(def-package! keyfreq
  :config
  (setq keyfreq-excluded-commands '(evil-next-line
                                    evil-previous-line
                                    evil-next-visual-line
                                    self-insert-command
                                    evil-previous-visual-line
                                    evil-forward-char
                                    forward-char
                                    org-self-insert-command
                                    ivy-next-line
                                    evil-forward-word-end
                                    doom/deflate-space-maybe
                                    doom/escape
                                    evil-backward-word-begin
                                    ivy-previous-line
                                    evil-backward-char
                                    backward-char
                                    ivy-backward-delete-char
                                    mwheel-scroll
                                    company-ignore
                                    evil-ex-search-next
                                    evil-normal-state
                                    evil-scroll-down
                                    evil-scroll-up
                                    ivy-done
                                    right-char
                                    keyboard-escape-quit
                                    left-char
                                    doom/inflate-space-maybe
                                    evil-visual-char
                                    term-send-raw
                                    save-buffer
                                    company-select-next-or-abort
                                    term-send-left
                                    +org/toggle-fold
                                    evil-delete
                                    neotree-next-line
                                    neotree-previous-line
                                    term-send-backspace
                                    undo-tree-undo
                                    xwidget-webkit-scroll-down-line
                                    evil-force-normal-state
                                    xwidget-webkit-scroll-up-line))
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

;; maximize emacs upon startup
(add-hook! 'doom-post-init-hook 'toggle-frame-maximized)

(after! yasnippet
  (push "~/.doom.d/snippets" yas-snippet-dirs)
  )

;; *** evil
(after! evil-mc
  ;; Make evil-mc resume its cursors when I switch to insert mode
  (add-hook! 'evil-mc-before-cursors-created
    (add-hook 'evil-insert-state-entry-hook #'evil-mc-resume-cursors nil t))
  (add-hook! 'evil-mc-after-cursors-deleted
    (remove-hook 'evil-insert-state-entry-hook #'evil-mc-resume-cursors t)))

(def-package! atomic-chrome
  :preface
  (defun atomic-chrome-server-running-p ()
    (cond ((executable-find "lsof")
           (zerop (call-process "lsof" nil nil nil "-i" ":64292")))
          ((executable-find "netstat") ; Windows
           (zerop (call-process-shell-command "netstat -aon | grep 64292")))))
  :hook (atomic-chrome-edit-mode . flyspell-mode)
  :init
  (if (atomic-chrome-server-running-p)
      (message "Can't start atomic-chrome server, because port 64292 is already used")
    (atomic-chrome-start-server))
  :config
  (setq atomic-chrome-default-major-mode 'markdown-mode)
  (setq atomic-chrome-url-major-mode-alist
        '(("github" . gfm-mode)
          ("gitlab" . gfm-mode)))
  (setq atomic-chrome-buffer-open-style 'frame)
  (add-hook 'atomic-chrome-edit-done-hook 'delete-frame))

;; lang python
;;
;; TODO: add fully lsp-mode
;; (def-package! lsp-python
;;   :commands (lsp-python-enable)
;;   :config
;;   (setq python-indent-guess-indent-offset-verbose nil)
;;   (set-company-backend! '(python-mode) '(company-lsp company-files company-yasnippet))
;;   (set-lookup-handlers! 'python-mode
;;     :definition #'lsp-ui-peek-find-definitions
;;     :references #'lsp-ui-peek-find-references))

(def-package! py-isort
  :after python
  :config
  (map! :map python-mode-map
        :localleader
        :n "s" #'py-isort-buffer
        :v "s" #'py-isort-region))

(def-package! yapfify
  :after python
  :hook (python-mode . yapf-mode)
  :config
  (map! :map python-mode-map
        :localleader
        :nv "=" #'yapfify-buffer))

(def-package! pipenv
  :hook (python-mode . pipenv-mode)
  :init
  (setq
   pipenv-projectile-after-switch-function
   #'pipenv-projectile-after-switch-extended)
  :config
  (map! :map python-mode-map
        :localleader
        :desc "pipenv" :prefix "p"
        :n "a" #'pipenv-activate
        :n "d" #'pipenv-deativate
        :n "s" #'pipenv-shell
        :n "o" #'pipenv-open
        :n "i" #'pipenv-install
        :n "u" #'pipenv-uninstall
        ))


;; *** electric
(def-package! electric-operator
  :hook ((sh-mode . electric-operator-mode)
         (ess-mode . electric-operator-mode)
         (python-mode . electric-operator-mode)))

;; search online , has no efficient instrument change variable in autoload module
(setq +lookup-provider-url-alist
      '(("Google"             . "https://google.com/search?q=%s")
        ("Google images"      . "https://google.com/images?q=%s")
        ("Google maps"        . "https://maps.google.com/maps?q=%s")
        ("Project Gutenberg"  . "http://www.gutenberg.org/ebooks/search/?query=%s")
        ("DuckDuckGo"         . "https://duckduckgo.com/?q=%s")
        ("DevDocs.io"         . "https://devdocs.io/#q=%s")
        ("StackOverflow"      . "https://stackoverflow.com/search?q=%s")
        ("Github"             . "https://github.com/search?ref=simplesearch&q=%s")
        ("Youtube"            . "https://youtube.com/results?aq=f&oq=&search_query=%s")
        ("Wolfram alpha"      . "https://wolframalpha.com/input/?i=%s")
        ("Wikipedia"          . "https://wikipedia.org/search-redirect.php?language=en&go=Go&search=%s")
        ("Zhihu"              . "https://www.zhihu.com/search?q=%s&type=content")
        ("Baidu"              . "http://www.baidu.com/s?wd=%s")
        ("Pinterest"          . "https://www.pinterest.com/search/pins/?q=%s")
        ("Amazon"             . "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%%3Daps&field-keywords=%s")
        ("Douban"             . "https://www.douban.com/search?q=%s")
        ("Bing"               . "http://www.bing.com/search?q=%s")
        ("Twitter"            . "https://twitter.com/search?q=%s")
        ("Weibo"              . "http://s.weibo.com/weibo/%s")
        ("RFC"                . "http://pretty-rfc.herokuapp.com/search?q=%s")
        ))

(after! undo-tree
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-visualizer-timestamps t)
  ;; FIXME windows not display stable
  ;; (setq undo-tree-visualizer-diff t)
  (set-popup-rule! "^ ?\\*undo-tree\*" :ignore))


;; for workspace problem
;; https://github.com/hlissner/doom-emacs/issues/447
(add-hook 'persp-before-switch-functions '+my-workspace/goto-main-window)

(def-package! drag-stuff
  :commands (drag-stuff-up
             drag-stuff-down))

(def-package! sx
  :config
  (bind-keys :prefix "C-c s"
             :prefix-map my-sx-map
             :prefix-docstring "Global keymap for SX."
             ("q" . sx-tab-all-questions)
             ("i" . sx-inbox)
             ("o" . sx-open-link)
             ("u" . sx-tab-unanswered-my-tags)
             ("a" . sx-ask)
             ("s" . sx-search)))

(def-package! restart-emacs
  :commands restart-emacs)


;; Discover key bindings and their meaning for the current Emacs major mode
(def-package! discover-my-major
  :bind (("C-c M-m" . discover-my-major)
         ("C-c M-M" . discover-my-mode)))


(def-package! list-environment)
(def-package! diffview)
(def-package! try)
(def-package! ztree)

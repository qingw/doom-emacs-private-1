;;; config.el -*- lexical-binding: t; -*-

;; (after! evil (load! +bindings))
(load! +bindings)

(setq
 which-key-idle-delay 0.3
 which-key-sort-order #'which-key-key-order-alpha
 minibuffer-message-timeout 3
 counsel-projectile-ag-initial-input '(projectile-symbol-or-selection-at-point)

 projectile-ignored-projects '("~/" "/tmp")
 counsel-find-file-at-point t
 ivy-extra-directories '("./")

 company-show-numbers t

 ;; tramp
 tramp-default-method "ssh"
 tramp-ssh-controlmaster-options "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=600"
 ;; tramp-remote-process-environment (quote ("TMOUT=0" "LC_CTYPE=''" "TRAMP='yes'" "CDPATH=" "HISTORY=" "MAIL=" "MAILCHECK=" "MAILPATH=" "PAGER=cat" "autocorrect=" "correct=" "http_proxy=http://proxy.cse.cuhk.edu.hk:8000" "https_proxy=http://proxy.cse.cuhk.edu.hk:8000" "ftp_proxy=http://proxy.cse.cuhk.edu.hk:8000"))
 )

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . 'dark))

;; TODO: add some replace
(after! which-key

  (push '((nil . "Switch to 1st workspace") .
          ("1..9" . "Switch to 1..9 workspace")) which-key-replacement-alist)
  )

;; ** Tramp
(after! tramp-sh
  (add-to-list 'tramp-remote-path "")
  (add-to-list 'tramp-remote-path ""))
(def-package! counsel-tramp
  :commands (counsel-tramp))
(def-package! docker-tramp
  :after tramp)

(after! recentf
  (add-to-list 'recentf-exclude 'file-remote-p)
  (add-to-list 'recentf-exclude ".*\\.gz")
  (add-to-list 'recentf-exclude ".*\\.gpg")
  (add-to-list 'recentf-exclude ".*\\.gif")
  (add-to-list 'recentf-exclude ".*\\.pdf")
  (add-to-list 'recentf-exclude ".*\\.svg")
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
  (add-to-list 'recentf-exclude "COMMIT_MSG")
  (add-to-list 'recentf-exclude "COMMIT_EDITMSG")
  (add-to-list 'recentf-exclude ".*Cellar.*"))

(add-hook 'minibuffer-setup-hook #'smartparens-mode)
(add-hook 'minibuffer-setup-hook #'doom|no-fringes-in-minibuffer)
(set-window-fringes (minibuffer-window) 0 0 nil)

(def-package-hook! ace-window
  :post-config
  (setq aw-scope 'visible
        aw-background nil)
  nil)

;; ** Magit
(def-package! orgit :after magit)
(def-package! magithub
  :commands (magithub-clone
             magithub-feature-autoinject)
  ;; :ensure t
  :config
  (autoload 'magithub-completion-enable "magithub-completion" "\
Enable completion of info from magithub in the current buffer.

\(fn)" nil nil)
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
         ;; FIXME keep first issue always show
         (or (< created_at ,days) (< updated_at ,days)))))

  (defun magithub-filter-maybe (&optional limit)
    "Add filters to magithub only if number of issues is greter than LIMIT."
    (let ((max-issues (length (ignore-errors (magithub-issues))))
          (max-pull-requests (length (ignore-errors (magithub-pull-requests))))
          (limit (or limit 15)))
      (when (> max-issues limit)
        (add-to-list (make-local-variable 'magithub-issue-issue-filter-functions)
                     (issue-filter-to-days limit "issues")))
      (when (> max-pull-requests limit)
        (add-to-list (make-local-variable 'magithub-issue-pull-request-filter-functions)
                     (issue-filter-to-days limit "pull-requests")))))

  (add-to-list 'magit-status-mode-hook #'magithub-filter-maybe)
  (setq
   magithub-clone-default-directory "~/workspace/sources/"
   magithub-dir (concat doom-etc-dir "magithub/")
   magithub-preferred-remote-method 'clone_url))
(def-package! evil-magit :after magit
  :init
  (setq evil-magit-state 'normal))
(after! magit
  (magithub-feature-autoinject t)
  (setq magit-repository-directories '("~/workspace/sources/"))
  (set! :evil-state 'magit-repolist-mode 'normal)
  (push 'magit-repolist-mode evil-snipe-disabled-modes)

  (map!
   (:map with-editor-mode-map
     (:localleader
       :desc "Finish" :n "," #'with-editor-finish
       :desc "Abort"  :n "k" #'with-editor-cancel))
   (:map magit-repolist-mode-map
     :n "j" #'next-line
     :n "k" #'previous-line
     :n "s" #'magit-repolist-status ))
  (set! :popup "^.*magit" '((slot . -1) (side . right) (size . 80)) '((modeline . nil) (select . t)))
  (set! :popup "^.*magit.*popup\\*" '((slot . 0) (side . right)) '((modeline . nil) (select . t)))
  (set! :popup "^.*magit-revision:.*" '((slot . 2) (side . right) (window-height . 0.6)) '((modeline . nil) (select . t)))
  (set! :popup "^.*magit-diff:.*" '((slot . 2) (side . right) (window-height . 0.6)) '((modeline . nil) (select . nil)))
  (add-hook! 'magit-popup-mode-hook #'doom-hide-modeline-mode))

;; ** Helpful
(after! helpful
  (set! :popup "^\\*helpful.*"
    '((size . 80) (side . right))
    '((transient . nil) (select . t) (quit . t))))

;; * Ivy Actions
(after! counsel
;; ** counsel-find-file
  (defun +ivy/reloading (cmd)
    (lambda (x)
      (funcall cmd x)
      (ivy--reset-state ivy-last)))
  (defun +ivy/given-file (cmd prompt) ; needs lexical-binding
    (lambda (source)
      (let ((target
             (let ((enable-recursive-minibuffers t))
               (read-file-name
                (format "%s %s to:" prompt source)))))
        (funcall cmd source target 1))))
  (defun +ivy/confirm-delete-file (x)
    (dired-delete-file x 'confirm-each-subdirectory))
  (ivy-add-actions
   'counsel-find-file
   `(("c" ,(+ivy/given-file #'copy-file "Copy file") "copy file")
     ("d" ,(+ivy/reloading #'+ivy/confirm-delete-file) "delete")
     ("m" ,(+ivy/reloading (+ivy/given-file #'rename-file "Move")) "move")
     ("f" find-file-other-window "other window")))
;; ** counsel-M-x
  (defun +ivy/helpful-function (prompt)
    (helpful-function (intern prompt)))
  (defun +ivy/find-function (prompt)
    (find-function (intern prompt)))
  (ivy-add-actions
   'counsel-M-x
   `(("h" +ivy/helpful-function "Helpful")
     ("f" +ivy/find-function "Find")))

  )


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
(toggle-frame-maximized)

(def-package! atomic-chrome
  :hook (doom-post-init . atomic-chrome-start-server)
  :config
  (setq atomic-chrome-default-major-mode 'markdown-mode)
  (setq atomic-chrome-url-major-mode-alist
        '(("github" . gfm-mode)
          ("gitlab" . gfm-mode)))
  (setq atomic-chrome-buffer-open-style 'frame)
  (add-hook 'atomic-chrome-edit-done-hook 'delete-frame))

;; Prog
;;
(def-package! prog-fill
  :commands prog-fill
  :hook
  (prog-mode . (lambda()(map! :map prog-mode-map
                          :nv "M-q" #'prog-fill))))
;; lang python
;;
;; TODO: add fully lsp-mode
;; (def-package! lsp-python
;;   :commands (lsp-python-enable)
;;   :config
;;   (setq python-indent-guess-indent-offset-verbose nil)
;;   (set! :company-backend '(python-mode) '(company-lsp company-files company-yasnippet))
;;   (set! :lookup 'python-mode
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
  (set! :popup "^ ?\\*undo-tree\*" :ignore))

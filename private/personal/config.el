;;; config.el -*- lexical-binding: t; -*-


(load! +bindings)


(setq
 which-key-idle-delay 0.3

 ;; tramp
 tramp-default-method "ssh"
 tramp-ssh-controlmaster-options "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=600"
 ;; tramp-remote-process-environment (quote ("TMOUT=0" "LC_CTYPE=''" "TRAMP='yes'" "CDPATH=" "HISTORY=" "MAIL=" "MAILCHECK=" "MAILPATH=" "PAGER=cat" "autocorrect=" "correct=" "http_proxy=http://proxy.cse.cuhk.edu.hk:8000" "https_proxy=http://proxy.cse.cuhk.edu.hk:8000" "ftp_proxy=http://proxy.cse.cuhk.edu.hk:8000"))
 )

;; ** Tramp
(after! tramp-sh
  (add-to-list 'tramp-remote-path "")
  (add-to-list 'tramp-remote-path ""))

(after! recentf
  (add-to-list 'recentf-exclude ".*\\.gz")
  (add-to-list 'recentf-exclude ".*\\.gif")
  (add-to-list 'recentf-exclude ".*\\.pdf")
  (add-to-list 'recentf-exclude ".*\\.svg")
  (add-to-list 'recentf-exclude ".*Cellar.*"))

(add-hook 'minibuffer-setup-hook #'smartparens-mode)
(add-hook 'minibuffer-setup-hook #'doom|no-fringes-in-minibuffer)
(set-window-fringes (minibuffer-window) 0 0 nil)

(def-package-hook! ace-window
  :pre-config
  (setq aw-keys '(?a ?s ?d ?f ?g ?j ?k ?l ?\;)
        aw-scope 'visible
        aw-background nil)
  nil)

(setq company-show-numbers t)

;; ** Magit
(def-package! orgit :after magit)
(def-package! magithub
  :commands (magithub-clone
             magithub-create)
  :after magit
  :demand
  :config
  (autoload 'magithub-completion-enable "magithub-completion")
  (magithub-feature-autoinject t)
  (setq
   magithub-clone-default-directory "~/workspace/sources/"
   magithub-dir (concat doom-etc-dir "magithub/")
   magithub-preferred-remote-method 'ssh_url))
(def-package! evil-magit :after magit
  :init
  ;; optional: this is the evil state that evil-magit will use
  (setq evil-magit-state 'normal))
(after! magit
  (set! :popup "^\\*Magit" '((slot . -1) (side . right) (size . 80)) '((modeline . nil) (select . t)))
  (set! :popup "^\\*magit.*popup\\*" '((slot . 0) (side . right)) '((modeline . nil) (select . t)))
  (set! :popup "^\\*magit-revision:.*" '((vslot . -1) (side . right) (window-height . 0.6)) '((modeline . nil) (select . t)))
  (set! :popup "^\\*magit-diff:.*" '((vslot . -1) (side . right) (window-height . 0.6)) '((modeline . nil) (select . nil)))
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

;; maximize emacs upon startup
(toggle-frame-maximized)

(def-package! atomic-chrome
  :config
  (atomic-chrome-start-server)
  (setq atomic-chrome-default-major-mode 'markdown-mode)
  (setq atomic-chrome-buffer-open-style 'frame)
  )

;; use daemon
(require 'server)
(add-hook 'after-init-hook (lambda ()
                             (unless (or (daemonp) (server-running-p))
                               (server-start)
                               (setq server-raise-frame t))))

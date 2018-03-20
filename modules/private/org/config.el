;;; config.el -*- lexical-binding: t; -*-

(load! +todo)
;; (load! +bindings)

;; (load! +todo)
;; (load! +babel)
;; (load! +latex)
;; (load! +capture)
;; (load! +export)

(after! org
  (setq
   org-default-journal-file (expand-file-name "journal.org.gpg" org-directory)
   org-default-notes-file (expand-file-name "inbox.org" org-directory)
   ledger-journal-file (expand-file-name "ledger.gpg" org-directory)
   org-default-works-file (expand-file-name "works.org" org-directory)
   org-modules (quote (org-bibtex org-habit org-info org-protocol org-mac-link org-notmuch))
   )
  ;; from https://emacs.stackexchange.com/questions/30520/org-mode-c-c-c-c-to-display-inline-image
  ;; TODO only redisplay affect source block
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

  (set! :popup "^CAPTURE.*\\.org$" '((side . bottom) (size . 0.4)) '((select . t)))
  (set! :popup "^\\*Org Src" '((size . 0.6) (side . right)) '((quit) (select . t)))

  (setq org-capture-templates
        `(("t" "Todo" entry (file+headline  org-default-notes-file "Daily Tasks")
           "* TODO %?\n  %i\n"
           :empty-lines 1)
          ("n" "Note" entry (file+headline  org-default-notes-file "Quick notes")
           "*  %? :NOTE:\n%U\n%a\n"
           :empty-lines 1)
          ("b" "Blog Ideas" entry (file+headline  org-default-notes-file "Blog Ideas")
           "* TODO %?\n  %i\n %U"
           :empty-lines 1)
          ("s" "Code Snippet" entry
           (file ,(expand-file-name  "snippets.org" org-directory))
           "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")

          ("w" "Works Entry")
          ("wt" "Works todo"
           entry (file+datetree+prompt org-default-works-file )
           "* TODO %?\n %i\n"
           :empty-lines 1)
          ("wl" "Works Log"
           entry (file+datetree+prompt org-default-works-file )
           "* %?\n\nEntered on %U\n"
           :empty-lines 1)
          ("wn" "Works notes"
           entry (file+datetree+prompt org-default-works-file )
           "* %?\n\nEntered on %U\n"
           :empty-lines 1)
          ("wm" "Works meeting"
           entry (file+datetree+prompt org-default-works-file )
           "* %? :meeting: \n\nEntered on %U\n"
           :empty-lines 1)

          ("h" "Habit" entry (file (expand-file-name "habit.org" org-directory))
           "* TODO %?\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+5d/7d>>\")\n:PROPERTIES:\n:STYLE: habit\n:END:\n\n%U\n%a\n")
          ("j" "Journal Entry"
           entry (file+datetree+prompt org-default-journal-file )
           "* %?\n\nEntered on %U\n"
           :empty-lines 1
           ;; :kill-buffer
           )
          ("p" "password" entry (file+headline org-passwords-file "Password")
           "* %^{Title}\n  %^{URL}p %^{USERNAME}p %^{PASSWORD}p"
           :kill-buffer)
          ))

  (defvar personal-account "Account||Paypal-Personal|Alipay-Personal" "Personal accounts")

  ;; Templates for Ledger
  ;; Thanks to Sacha Chua for the idea! http://sachachua.com
  (setq org-capture-templates
        (append '(("x" "Transfer Ledger Entry" plain
                   (file ledger-journal-file)
                   "%(org-read-date) * %^{Description|Transfer}
  Assets:%^{To Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings|ETRADE-Checking|Bitcoin|ETRADE-RothIRA-Personal|ETRADE-RothIRA-Ananda|ETRADE-Brokerage|Ameriprise-Life-Insurance} %^{Amount}
  Assets:%^{From Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings|ETRADE-Checking|Bitcoin|ETRADE-RothIRA-Personal|ETRADE-RothIRA-Ananda|ETRADE-Brokerage|Ameriprise-Life-Insurance} -%\\3
")
                  )
                org-capture-templates))

  (setq org-capture-templates
        (append '(("a" "Auto Loan Payment" plain
                   (file ledger-journal-file)
                   "%(org-read-date) * Auto Loan Payment
  Liabilities:Eastern-Bank-Subaru-Outback-Auto-Loan %^{Total Amount Paid (incl. fees)|459.93}
  Assets:PayPal-Personal -%^{Amount Applied to Loan|458.43}
  Expenses:Transaction-Fees -%^{Processing Fee|1.50}
")
                  )
                org-capture-templates))

  (setq org-capture-templates
        (append '(("i" "Income Ledger Entry")

                  ("ig" "Income:Gifts" plain
                   (file ledger-journal-file)
                   "%(org-read-date) * 收 %^{Received From} %^{For why} 礼金
  Assets:%^{Account|Personal|Home}  %^{Amount} %^{Currency|CNY|USD|JPY}
  Income:Gifts
")
                  )
                org-capture-templates))

  (setq org-capture-templates
        (append '(("e" "Expense Ledger Entry (Personal)")

                  ("eo" "Expense:Other" plain
                   (file ledger-journal-file)
                   "%(org-read-date) * %^{Description}
  Expenses:Other %^{Amount}
  Assets:%^{Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings}
")
                  ("eg" "Expense:Gifts" plain
                   (file ledger-journal-file)
                   "%(org-read-date) * 送 %^{Send to} %^{For why} 礼金
  Expense:Gifts  %^{Amount}  %^{Currency|CNY|USD|JPY}
  Assets:%^{Account||Personal|Home}
")
                  )
                org-capture-templates))
  )

(setq counsel-projectile-org-capture-templates
      '(("t" "TODO" entry (file+headline "${root}/TODO.org" "Tasks") "* TODO %?\n%u\n%a\n")
        ("f" "FIXME" entry (file+headline "${root}/TODO.org" "Tasks") "* FIXME %?\n%u\n%a\n")
        ("n" "NOTE" entry (file "${root}/note.org" ) "* %? :NOTE:\n%u\n%a\n")
        ))

;; TODO: create org-brain workspace for all brain files
;; create local brain lib
(def-package! org-brain
  :commands org-brain-visualize
  :init
  (setq org-brain-path "~/org/brain")
  (push 'org-agenda-mode evil-snipe-disabled-modes)
  ;; (add-hook 'org-agenda-mode-hook #'(lambda () (evil-vimish-fold-mode -1)))
  (set! :evil-state 'org-brain-visualize-mode 'normal)

  :config
  (require 'org)
  (defun org-brain-set-tags (entry)
    "Use `org-set-tags' on headline ENTRY.
If run interactively, get ENTRY from context."
    (interactive (list (org-brain-entry-at-pt)))
    (when (org-brain-filep entry)
      (error "Can only set tags on headline entries"))
    (org-with-point-at (org-brain-entry-marker entry)
      (counsel-org-tag)
      (save-buffer))
    (org-brain--revert-if-visualizing))

  (setq org-id-track-globally t)
  (setq org-id-locations-file "~/.emacs.d/.org-id-locations")
  (push '("b" "Brain" plain (function org-brain-goto-end)
          "* %i%?" :empty-lines 1)
        org-capture-templates)
  (setq org-brain-visualize-default-choices 'root
        org-brain-title-max-length 20)
  (set! :popup "^\\*org-brain\\*$" '((vslot . -1) (size . 0.3) (side . left)) '((select . t) (quit) (transient)))

  (map!
   (:map org-brain-visualize-mode-map
     :n "a"   #'org-brain-visualize-attach
     :n "b"   #'org-brain-visualize-back
     :n "c"   #'org-brain-add-child
     :n "C"   #'org-brain-remove-child
     :n "p"   #'org-brain-add-parent
     :n "P"   #'org-brain-remove-parent
     :n "f"   #'org-brain-add-friendship
     :n "F"   #'org-brain-remove-friendship
     :n "d"   #'org-brain-delete-entry
     :n "^"   #'revert-buffer
     :n "_"   #'org-brain-new-child
     :n ";"   #'org-brain-set-tags
     :n "j"   #'forward-button
     :n "k"   #'backward-button
     :n "l"   #'org-brain-add-resource
     :n "L"   #'doom/org-brain-add-resource
     :n "t"   #'org-brain-set-title
     :n "$"   #'org-brain-pin
     :n "o"   #'ace-link-woman
     :n "q"   #'org-brain-visualize-quit
     :n "r"   #'org-brain-visualize-random
     :n "R"   #'org-brain-visualize-wander
     :n "g"   #'org-brain-visualize
     :n "G"   #'org-brain-goto
     :n [tab] #'org-brain-goto-current
     :n "m"   #'org-brain-visualize-mind-map
     :n "["   #'org-brain-visualize-add-grandchild
     :n "]"   #'org-brain-visualize-remove-grandchild
     :n "{"   #'org-brain-visualize-add-grandparent
     :n "}"   #'org-brain-visualize-remove-grandparent
     )))

(def-package! org-web-tools
  :after org)

(after! org-bullets
  ;; The standard unicode characters are usually misaligned depending on the
  ;; font. This bugs me. Personally, markdown #-marks for headlines are more
  ;; elegant, so we use those.

  (setq org-bullets-bullet-list '("⊢" "⋮" "⋱" "-")))

(def-package! org-fancy-priorities
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("⚡" "⬆" "☕")))

;; Bootstrap
;;
(remove-hook! 'org-load-hook #'(+org|setup-evil))

(add-hook 'org-load-hook #'+org-private|setup-ui t)
(add-hook 'org-load-hook #'+org-private|setup-agenda t)
(add-hook 'org-load-hook #'+org-private|setup-keybinds t)
(add-hook 'org-load-hook #'+org-private|setup-overrides t)

(remove-hook! 'org-mode-hook #'(visual-line-mode))

(add-hook 'org-mode-hook #'+org-private|setup-editing t)

;; `org-load' hooks
;;

(defun +org-private|setup-agenda ()
  (setq org-agenda-block-separator ""
        org-agenda-clockreport-parameter-plist (quote (:link t :maxlevel 3 :fileskip0 t :stepskip0 t :tags "-COMMENT"))
        org-agenda-compact-blocks t
        org-agenda-dim-blocked-tasks nil
        org-agenda-files (append
                          ;; (list "/Users/xfu/Dropbox/org/cal/cal.org")
                          (ignore-errors (directory-files +org-dir t "\\.org$" t)))
        org-agenda-follow-indirect t
        org-agenda-ignore-properties '(effort appt category)
        org-agenda-inhibit-startup t
        org-agenda-inhibit-startup t
        org-agenda-log-mode-items '(closed clock)
        org-agenda-overriding-header ""
        org-agenda-restore-windows-after-quit t
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-unavailable-files t
        org-agenda-sorting-strategy '((agenda time-up priority-down category-keep)
                                      (todo   priority-down category-keep)
                                      (tags   priority-down category-keep)
                                      (search category-keep))
        org-agenda-span 'day
        org-agenda-start-with-log-mode t
        org-agenda-sticky nil
        org-agenda-tags-column 'auto
        org-agenda-use-tag-inheritance nil
        org-habit-following-days 0
        org-habit-graph-column 1
        org-habit-preceding-days 8
        org-habit-show-habits t
        ))

(defun +org-private|setup-ui ()
  "Configures the UI for `org-mode'."
  ;; (defface org-todo-keyword-todo '((t ())) "org-todo" :group 'org)
  ;; (defface org-todo-keyword-kill '((t ())) "org-kill" :group 'org)
  ;; (defface org-todo-keyword-outd '((t ())) "org-outd" :group 'org)
  ;; (defface org-todo-keyword-wait '((t ())) "org-wait" :group 'org)
  ;; (defface org-todo-keyword-done '((t ())) "org-done" :group 'org)
  ;; (defface org-todo-keyword-habt '((t ())) "org-habt" :group 'org)

  (set! :popup "^\\*Org Src" '((size . 0.4) (side . right)) '((quit) (select . t) (modeline)))
  (set! :popup "^CAPTURE.*\\.org$" '((side . bottom) (size . 0.4)) '((quit) (select . t)))

  (setq org-adapt-indentation nil
        org-export-babel-evaluate nil
        org-blank-before-new-entry nil
        org-clock-clocktable-default-properties (quote (:maxlevel 3 :scope agenda :tags "-COMMENT"))
        org-clock-persist t
        org-clock-persist-file (expand-file-name ".org-clock-persist-data.el" +org-dir)
        org-clocktable-defaults (quote (:maxlevel 3 :lang "en" :scope file :block nil :wstart 1 :mstart 1 :tstart nil :tend nil :step nil :stepskip0 t :fileskip0 t :tags "-COMMENT" :emphasize nil :link nil :narrow 40! :indent t :formula nil :timestamp nil :level nil :tcolumns nil :formatter nil))
        org-columns-default-format "%50ITEM(Task) %8CLOCKSUM %16TIMESTAMP_IA"
        org-complete-tags-always-offer-all-agenda-tags t
        org-cycle-include-plain-lists t
        org-cycle-separator-lines 1
        org-mac-Skim-highlight-selection-p t
        org-enforce-todo-dependencies t
        org-entities-user
        '(("flat"  "\\flat" nil "" "" "266D" "♭")
          ("sharp" "\\sharp" nil "" "" "266F" "♯"))
        org-fontify-done-headline t
        org-fontify-quote-and-verse-blocks t
        org-fontify-whole-heading-line t
        org-footnote-auto-label 'plain
        org-global-properties (quote (("Effort_ALL" . "0 0:10 0:30 1:00 2:00 3:00 4:00 5:00 6:00 7:00")))
        org-hidden-keywords nil
        org-hide-block-startup t
        org-hide-emphasis-markers nil
        org-hide-leading-stars nil
        org-hide-leading-stars-before-indent-mode nil
        org-highest-priority ?A
        org-insert-heading-respect-content t
        org-id-link-to-org-use-id t
        org-id-locations-file (concat +org-dir ".org-id-locations")
        org-id-track-globally t
        org-image-actual-width nil
        org-imenu-depth 8
        org-indent-indentation-per-level 2
        org-indent-mode-turns-on-hiding-stars t
        org-list-description-max-indent 4
        org-log-done 'time
        org-log-into-drawer t
        org-log-note-clock-out t

        org-log-redeadline 'time
        org-log-reschedule 'time
        org-log-state-notes-into-drawer t
        org-lowest-priority ?F
        org-modules (quote (org-bibtex org-habit org-info org-protocol org-mac-link org-notmuch))
        org-outline-path-complete-in-steps nil
        org-pretty-entities nil

        org-pretty-entities-include-sub-superscripts t
        ;; org-priority-faces
        ;; `((?a . ,(face-foreground 'error))
        ;;   (?b . ,(face-foreground 'warning))
        ;;   (?c . ,(face-foreground 'success)))
        org-publish-timestamp-directory (concat +org-dir ".org-timestamps/")
        org-refile-targets '((nil :maxlevel . 9)
                             (org-agenda-files :maxlevel . 9))
        org-refile-use-outline-path 'file
        org-startup-folded t
        org-startup-indented t
        org-startup-with-inline-images nil
        org-tags-column 0
        ;; org-todo-keyword-faces
        ;; '(("TODO" . org-todo-keyword-todo)
        ;;   ("HABT" . org-todo-keyword-habt)
        ;;   ("DONE" . org-todo-keyword-done)
        ;;   ("WAIT" . org-todo-keyword-wait)
        ;;   ("KILL" . org-todo-keyword-kill)
        ;;   ("OUTD" . org-todo-keyword-outd))
        ;; org-todo-keywords
        ;; '((sequence "TODO(t!)"  "|" "DONE(d!/@)")
        ;;   (sequence "WAIT(w@/@)" "|" "OUTD(o@/@)" "KILL(k@/@)")
        ;;   (sequence "HABT(h!)" "|" "DONE(d!/@)" "KILL(k@/@)"))
        org-treat-insert-todo-heading-as-state-change t
        org-use-fast-tag-selection nil
        org-use-fast-todo-selection t
        org-use-sub-superscripts '{}
        outline-blank-line t)

  ;; Update UI when theme is changed
  (add-hook 'doom-init-theme-hook #'+org-private|setup-ui))

(defun +org-private|setup-keybinds ()
  (map! :map org-mode-map
        :i [S-tab] #'+org/dedent
        :ni "<s-return>" #'+org/work-on-heading
        ;; expand tables (or shiftmeta move)
        :ni "M-L" #'org-shiftmetaright
        :ni "M-H" #'org-shiftmetaleft
        :ni "M-J" #'org-shiftmetadown
        :ni "M-K" #'org-shiftmetaup
        :ni "M-k" #'org-metaup
        :ni "M-j" #'org-metadown
        :ni "M-h" #'org-metaleft
        :ni "M-l" #'org-metaright

        :ni "C-S-h" #'org-shiftleft
        :ni "C-S-l" #'org-shiftright
        :ni "C-S-j" #'org-shiftdown
        :ni "C-S-k" #'org-shiftup

        ;; toggle local fold, instead of all children
        :n  [tab]   #'org-cycle
        ;; more intuitive RET keybinds
        :i  "RET"   #'org-return-indent
        :n  "RET"   #'+org/dwim-at-point
        :ni [S-M-return] (lambda! (+org/insert-go-eol)
                             (call-interactively #'org-insert-todo-heading))
        :ni [M-return] #'org-meta-return
        ;; more org-ish vim motion keys
        :m  "]]"  (λ! (org-forward-heading-same-level nil) (org-beginning-of-line))
        :m  "[["  (λ! (org-backward-heading-same-level nil) (org-beginning-of-line))
        :m  "]o"  #'org-next-visible-heading
        :m  "[o"  #'org-previous-visible-heading
        :m  "]l"  #'org-next-link
        :m  "[l"  #'org-previous-link
        :m  "]i"  #'org-next-item
        :m  "[i"  #'org-previous-item
        :m  "]v"  #'org-next-block
        :m  "[v"  #'org-previous-block
        :m  "]s"  #'org-babel-next-src-block
        :m  "[s"  #'org-babel-previous-src-block
        :n  "gQ"  #'org-fill-paragraph
        ;; sensible code-folding vim keybinds
        :n  "za"  #'+org/toggle-fold
        :n  "zA"  #'org-shifttab
        :n  "zc"  #'outline-hide-subtree
        :n  "zC"  (λ! (outline-hide-sublevels 1))
        :n  "zd"  (lambda (&optional arg) (interactive "p") (outline-hide-sublevels (or arg 3)))
        :n  "zm"  (λ! (outline-hide-sublevels 1))
        :n  "zo"  #'outline-show-subtree
        :n  "zO"  #'outline-show-all
        :n  "zr"  #'outline-show-all)
  (map! :map org-mode-map
        "M-o" #'org-open-at-point
        "M-i" #'org-insert-last-stored-link
        "M-I" #'org-insert-link
        "s-p" #'org-ref-ivy-insert-cite-link
        :n  "RET" #'+org/dwim-at-point
        ;; :n  [tab]     #'org-cycle
        :n  "t"       #'org-todo
        :n  "T"       #'org-insert-todo-heading-respect-content

        (:localleader
          :desc "Schedule"          :n "s"                  #'org-schedule
          :desc "Math"              :n "m"                  #'+org-toggle-math
          :desc "Column View"       :n "c"                  #'org-columns
          :desc "All Column View"   :n "C"                  #'(lambda () (interactive)
                                                                (let ((current-prefix-arg 4))
                                                                  (call-interactively #'org-columns)))
          :desc "Remove link"       :n "L"                  #'+org/remove-link
          :desc "Deadline"          :n "d"                  #'org-deadline
          :desc "C-c C-c"           :n doom-localleader-key #'org-ctrl-c-ctrl-c
          :desc "Edit Special"      :n "'"                  #'org-edit-special
          :desc "Effort"            :n "e"                  #'org-set-effort
          :desc "TODO"              :n "t"                  #'org-todo
          :desc "org-refile"        :n "r"                  #'org-refile
          :desc "Export"            :n [tab]                #'org-export-dispatch
          :desc "Clocking Effort"   :n "E"                  #'org-clock-modify-effort-estimate
          :desc "Property"          :n "p"                  #'org-set-property
          :desc "Clock-in"          :n "i"                  #'org-clock-in
          :desc "Clock-out"         :n "o"                  #'org-clock-out
          :desc "Get skim link"     :n "="                  (λ! (call-interactively #'evil-append) (insert (+reference/skim-get-annotation)))
          :desc "Narrow to Subtree" :n "n"                  #'org-narrow-to-subtree
          :desc "Narrow to Element" :n "N"                  #'org-narrow-to-element
          :desc "Widen"             :n "w"                  #'widen
          :desc "Lookup"            :n "$"                  #'wordnut-lookup-current-word
          :desc "Toggle heading"    :n "h"                  #'org-toggle-heading
          :desc "Archive Subtree"   :n "A"                  #'org-archive-subtree
          :desc "Toggle Archive"    :n "a"                  #'org-toggle-archive-tag
          )
        (:after org-agenda
          (:map org-agenda-mode-map
            :nm "C-k"      #'evil-window-up
            :nm "C-j"      #'evil-window-down
            :nm "C-h"      #'evil-window-left
            :nm "C-l"      #'evil-window-right
            :nm "<escape>" #'org-agenda-Quit
            :nm "q"        #'org-agenda-Quit
            :nm "J"        #'org-clock-convenience-timestamp-down
            :nm "K"        #'org-clock-convenience-timestamp-up
            :nm "M-j"      #'org-agenda-later
            :nm "M-k"      #'org-agenda-earlier
            :nm "s-o"      #'org-clock-convenience-fill-gap
            :nm "s-e"      #'org-clock-convenience-fill-gap-both
            :nm "\\"       #'ace-window
            :nm "t"        #'org-agenda-todo
            :nm "p"        #'org-set-property
            :nm "r"        #'org-agenda-redo
            :nm "e"        #'org-agenda-set-effort
            :nm "H"        #'org-habit-toggle-habits
            :nm "L"        #'org-agenda-log-mode
            :nm "D"        #'org-agenda-toggle-diary
            :nm "G"        #'org-agenda-toggle-time-grid
            :nm ";"        #'counsel-org-tag-agenda
            :nm "s-j"      #'counsel-org-goto-all
            :nm "i"        #'org-agenda-clock-in
            :nm "o"        #'org-agenda-clock-out
            :nm "<tab>"    #'org-agenda-goto
            :nm "C"        #'org-agenda-capture
            :nm "m"        #'org-agenda-bulk-mark
            :nm "u"        #'org-agenda-bulk-unmark
            :nm "U"        #'org-agenda-bulk-unmark-all
            :nm "f"        #'+org@org-agenda-filter/body
            :nm "-"        #'org-agenda-manipulate-query-subtract
            :nm "="        #'org-agenda-manipulate-query-add
            :nm "_"        #'org-agenda-manipulate-query-subtract-re
            :nm "$"        #'org-agenda-manipulate-query-add-re
            :nm "d"        #'org-agenda-deadline
            :nm "s"        #'org-agenda-schedule
            :nm "z"        #'org-agenda-view-mode-dispatch
            :nm "S"        #'org-save-all-org-buffers))
        (:after org-src
          (:map org-src-mode-map
            "C-c C-c" nil
            "C-c C-k" nil
            (:localleader
              :desc "Finish" :nm ","  #'org-edit-src-exit
              :desc "Abort"  :nm "k"  #'org-edit-src-abort
              )))
        (:after org-capture
          (:map org-capture-mode-map
            "C-c C-c" nil
            "C-c C-k" nil
            "C-c C-w" nil
            (:localleader
              :desc "Finish" :nm "," #'org-capture-finalize
              :desc "Refile" :nm "r" #'org-capture-refile
              :desc "Abort"  :nm "k" #'org-capture-kill
              )))))

(defun +org-private|setup-overrides ()
  (after! org-html
    (defun +org-private/org-html--tags (tags info)
      "Format TAGS into HTML.
INFO is a plist containing export options."
      (when tags
        (format "\n<span class=\"tag\">%s</span>\n"
                (mapconcat
                 (lambda (tag)
                   (format "<span class=\"%s\">%s</span>"
                           (concat (plist-get info :html-tag-class-prefix)
                                   (org-html-fix-class-name tag))
                           tag))
                 tags " "))))
    (advice-add 'org-html--tags :override #'+org-private/org-html--tags))
  (setq org-file-apps
        `(("pdf" . default)
          ("\\.x?html?\\'" . default)
          (auto-mode . emacs)
          (directory . emacs)
          (t . ,(cond (IS-MAC "open \"%s\"")
                      (IS-LINUX "xdg-open \"%s\"")))))
  (defun +org-private/org-add-ids-to-headlines-in-file ()
    "Add CUSTOM_ID properties to all headlines in the current file"
    (interactive)
    (unless
        (or
         (string-equal (buffer-name) "cal.org")
         (string-equal default-directory "/Users/xfu/Source/playground/gatsby-orga/src/pages/")
         (string-equal default-directory "/Users/xfu/Source/playground/fuxialexander.github.io/src/pages/")
         (string-equal (buffer-name) "cal_kevin.org"))
      (save-excursion
        (widen)
        (goto-char (point-min))
        (org-map-entries 'org-id-get-create))))
  (add-hook 'org-mode-hook (lambda () (add-hook 'before-save-hook '+org-private/org-add-ids-to-headlines-in-file nil 'local)))
  (defun +org/insert-item-with-ts ()
    "When on org timestamp item insert org timestamp item with current time.
This holds only for inactive timestamps."
    (interactive)
    (when (save-excursion
            (let ((item-pos (org-in-item-p)))
              (when item-pos
                (goto-char item-pos)
                (org-list-at-regexp-after-bullet-p org-ts-regexp-inactive))))
      (let ((item-pos (org-in-item-p))
            (pos (point)))
        (assert item-pos)
        (goto-char item-pos)
        (let* ((struct (org-list-struct))
               (prevs (org-list-prevs-alist struct))
               (s (concat (with-temp-buffer
                            (org-insert-time-stamp nil t t)
                            (buffer-string)) " ")))
          (setq struct (org-list-insert-item pos struct prevs nil s))
          (org-list-write-struct struct (org-list-parents-alist struct))
          (looking-at org-list-full-item-re)
          (goto-char (match-end 0))
          (end-of-line)))
      t))

  (defun +org/insert-go-eol ()
    (when (bound-and-true-p evil-mode)
      (evil-insert 1))
    (end-of-line))
  (add-hook 'org-metareturn-hook '+org/insert-item-with-ts)
  (add-hook 'org-metareturn-hook '+org/insert-go-eol)

  (after! org-capture
    (defadvice org-capture-finalize
        (after org-capture-finalize-after activate)
      "Advise capture-finalize to close the frame"
      (if (or (equal "SA" (org-capture-get :key))
              (equal "GSA" (org-capture-get :key)))
          (do-applescript "tell application \"Skim\"\n    activate\nend tell")))
    (add-hook 'org-capture-prepare-finalize-hook
              #'(lambda () (if (or (equal "SA" (org-capture-get :key))
                              (equal "GSA" (org-capture-get :key)))
                          (+reference/append-org-id-to-skim (org-id-get-create))))))
  (after! elfeed-show
    (map! (:map elfeed-show-mode-map
            :nm "b" #'org-ref-add-bibtex-entry-from-elfeed-entry)))
  (after! org-mac-link
    (org-link-set-parameters "skim"
                             :face 'default
                             :follow #'+reference/org-mac-skim-open
                             :export (lambda (path desc backend)
                                       (cond ((eq 'html backend)
                                              (format "<a href=\"skim:%s\" >%s</a>"
                                                      (org-html-encode-plain-text path)
                                                      desc)))))
    (defun +org-private/as-get-skim-page-link ()
      (do-applescript
       (concat
        "tell application \"Skim\"\n"
        "set theDoc to front document\n"
        "set theTitle to (name of theDoc)\n"
        "set thePath to (path of theDoc)\n"
        "set thePage to (get index for current page of theDoc)\n"
        "set theSelection to selection of theDoc\n"
        "set theContent to contents of (get text for theSelection)\n"
        "if theContent is missing value then\n"
        "    set theContent to theTitle & \", p. \" & thePage\n"
        (when org-mac-Skim-highlight-selection-p
          (concat
           "else\n"
           "    tell theDoc\n"
           "        set theNote to make note with data theSelection with properties {type:highlight note}\n"
           "         set text of theNote to (get text for theSelection)\n"
           "    end tell\n"))
        "end if\n"
        "set theLink to \"skim://\" & thePath & \"::\" & thePage & "
        "\"::split::\" & theContent\n"
        "end tell\n"
        "return theLink as string\n")))

    (advice-add 'as-get-skim-page-link :override #'+org-private/as-get-skim-page-link))
  (defun org-refile-get-targets (&optional default-buffer)
    "Produce a table with refile targets."
    (let ((case-fold-search nil)
          ;; otherwise org confuses "TODO" as a kw and "Todo" as a word
          (entries (or org-refile-targets '((nil . (:level . 1)))))
          targets tgs files desc descre)
      (message "Getting targets...")
      (with-current-buffer (or default-buffer (current-buffer))
        (dolist (entry entries)
          (setq files (car entry) desc (cdr entry))
          (cond
           ((null files) (setq files (list (current-buffer))))
           ((eq files 'org-agenda-files)
            (setq files (org-agenda-files 'unrestricted)))
           ((and (symbolp files) (fboundp files))
            (setq files (funcall files)))
           ((and (symbolp files) (boundp files))
            (setq files (symbol-value files))))
          (when (stringp files) (setq files (list files)))
          (cond
           ((eq (car desc) :tag)
            (setq descre (concat "^\\*+[ \t]+.*?:" (regexp-quote (cdr desc)) ":")))
           ((eq (car desc) :todo)
            (setq descre (concat "^\\*+[ \t]+" (regexp-quote (cdr desc)) "[ \t]")))
           ((eq (car desc) :regexp)
            (setq descre (cdr desc)))
           ((eq (car desc) :level)
            (setq descre (concat "^\\*\\{" (number-to-string
                                            (if org-odd-levels-only
                                                (1- (* 2 (cdr desc)))
                                              (cdr desc)))
                                 "\\}[ \t]")))
           ((eq (car desc) :maxlevel)
            (setq descre (concat "^\\*\\{1," (number-to-string
                                              (if org-odd-levels-only
                                                  (1- (* 2 (cdr desc)))
                                                (cdr desc)))
                                 "\\}[ \t]")))
           (t (error "Bad refiling target description %s" desc)))
          (dolist (f files)
            (with-current-buffer (if (bufferp f) f (org-get-agenda-file-buffer f))
              (or
               (setq tgs (org-refile-cache-get (buffer-file-name) descre))
               (progn
                 (when (bufferp f)
                   (setq f (buffer-file-name (buffer-base-buffer f))))
                 (setq f (and f (expand-file-name f)))
                 (when (eq org-refile-use-outline-path 'file)
                   (push (list (file-name-nondirectory f) f nil nil) tgs))
                 (org-with-wide-buffer
                  (goto-char (point-min))
                  (setq org-outline-path-cache nil)
                  (while (re-search-forward descre nil t)
                    (beginning-of-line)
                    (let ((case-fold-search nil))
                      (looking-at org-complex-heading-regexp))
                    (let ((begin (point))
                          (heading (match-string-no-properties 4)))
                      (unless (or (and
                                   org-refile-target-verify-function
                                   (not
                                    (funcall org-refile-target-verify-function)))
                                  (not heading))
                        (let ((re (format org-complex-heading-regexp-format
                                          (regexp-quote heading)))
                              (target
                               (if (not org-refile-use-outline-path) heading
                                 (concat
                                  (file-name-nondirectory (buffer-file-name (buffer-base-buffer)))
                                  " ✦ "
                                  (org-format-outline-path (org-get-outline-path t t) 1000 nil " ➜ ")
                                  ))))

                          (push (list target f re (org-refile-marker (point)))
                                tgs)))
                      (when (= (point) begin)
                        ;; Verification function has not moved point.
                        (end-of-line)))))))
              (when org-refile-use-cache
                (org-refile-cache-put tgs (buffer-file-name) descre))
              (setq targets (append tgs targets))))))
      (message "Getting targets...done")
      (delete-dups (nreverse targets))))

  (defun +org-private/*org-ctrl-c-ctrl-c-counsel-org-tag ()
    "Hook for `org-ctrl-c-ctrl-c-hook' to use `counsel-org-tag'."
    (if (save-excursion (beginning-of-line) (looking-at "[ \t]*$"))
        (or (run-hook-with-args-until-success 'org-ctrl-c-ctrl-c-final-hook)
            (user-error "C-c C-c can do nothing useful at this location"))
      (let* ((context (org-element-context))
             (type (org-element-type context)))
        (case type
          ;; When at a link, act according to the parent instead.
          (link (setq context (org-element-property :parent context))
                (setq type (org-element-type context)))
          ;; Unsupported object types: refer to the first supported
          ;; element or object containing it.
          ((bold code entity export-snippet inline-babel-call inline-src-block
                 italic latex-fragment line-break macro strike-through subscript
                 superscript underline verbatim)
           (setq context
                 (org-element-lineage
                  context '(radio-target paragraph verse-block table-cell)))))
        ;; For convenience: at the first line of a paragraph on the
        ;; same line as an item, apply function on that item instead.
        (when (eq type 'paragraph)
          (let ((parent (org-element-property :parent context)))
            (when (and (eq (org-element-type parent) 'item)
                       (= (line-beginning-position)
                          (org-element-property :begin parent)))
              (setq context parent type 'item))))
        (case type
          ((headline inlinetask)
           (save-excursion (goto-char (org-element-property :begin context))
                           (call-interactively 'counsel-org-tag)) t)))))
  (add-hook 'org-ctrl-c-ctrl-c-hook '+org-private/*org-ctrl-c-ctrl-c-counsel-org-tag)
  (defvar *org-git-notes nil
    "use log notes for git commit notes")
  (defun *org-store-log-note ()
    "Finish taking a log note, and insert it to where it belongs."
    (let ((txt (prog1 (buffer-string)
                 (kill-buffer)))
          (note (cdr (assq org-log-note-purpose org-log-note-headings)))
          lines)
      (while (string-match "\\`# .*\n[ \t\n]*" txt)
        (setq txt (replace-match "" t t txt)))
      (when (string-match "\\s-+\\'" txt)
        (setq txt (replace-match "" t t txt)))
      (setq lines (and (not (equal "" txt)) (org-split-string txt "\n")))
      (when (org-string-nw-p note)
        (setq note
              (org-replace-escapes
               note
               (list (cons "%u" (user-login-name))
                     (cons "%U" user-full-name)
                     (cons "%t" (format-time-string
                                 (org-time-stamp-format 'long 'inactive)
                                 org-log-note-effective-time))
                     (cons "%T" (format-time-string
                                 (org-time-stamp-format 'long nil)
                                 org-log-note-effective-time))
                     (cons "%d" (format-time-string
                                 (org-time-stamp-format nil 'inactive)
                                 org-log-note-effective-time))
                     (cons "%D" (format-time-string
                                 (org-time-stamp-format nil nil)
                                 org-log-note-effective-time))
                     (cons "%s" (cond
                                 ((not org-log-note-state) "")
                                 ((string-match-p org-ts-regexp
                                                  org-log-note-state)
                                  (format "\"[%s]\""
                                          (substring org-log-note-state 1 -1)))
                                 (t (format "\"%s\"" org-log-note-state))))
                     (cons "%S"
                           (cond
                            ((not org-log-note-previous-state) "")
                            ((string-match-p org-ts-regexp
                                             org-log-note-previous-state)
                             (format "\"[%s]\""
                                     (substring
                                      org-log-note-previous-state 1 -1)))
                            (t (format "\"%s\""
                                       org-log-note-previous-state)))))))
        (when lines (setq note (concat note " \\\\")))
        (push note lines))
      (when (and lines (not org-note-abort))
        (setq *org-git-notes (concat *org-git-notes ": " (substring-no-properties (car lines))))
        (with-current-buffer (marker-buffer org-log-note-marker)
          (org-with-wide-buffer
           ;; Find location for the new note.
           (goto-char org-log-note-marker)
           (set-marker org-log-note-marker nil)
           ;; Note associated to a clock is to be located right after
           ;; the clock.  Do not move point.
           (unless (eq org-log-note-purpose 'clock-out)
             (goto-char (org-log-beginning t)))
           ;; Make sure point is at the beginning of an empty line.
           (cond ((not (bolp)) (let ((inhibit-read-only t)) (insert "\n")))
                 ((looking-at "[ \t]*\\S-") (save-excursion (insert "\n"))))
           ;; In an existing list, add a new item at the top level.
           ;; Otherwise, indent line like a regular one.
           (let ((itemp (org-in-item-p)))
             (if itemp
                 (indent-line-to
                  (let ((struct (save-excursion
                                  (goto-char itemp) (org-list-struct))))
                    (org-list-get-ind (org-list-get-top-point struct) struct)))
               (org-indent-line)))
           (insert (org-list-bullet-string "-") (pop lines))
           (let ((ind (org-list-item-body-column (line-beginning-position))))
             (dolist (line lines)
               (insert "\n")
               (indent-line-to ind)
               (insert line)))
           (message "Note stored")
           (org-back-to-heading t)
           (org-cycle-hide-drawers 'children))
          ;; Fix `buffer-undo-list' when `org-store-log-note' is called
          ;; from within `org-add-log-note' because `buffer-undo-list'
          ;; is then modified outside of `org-with-remote-undo'.
          (when (eq this-command 'org-agenda-todo)
            (setcdr buffer-undo-list (cddr buffer-undo-list)))))
      )
    ;; Don't add undo information when called from `org-agenda-todo'.
    (let ((buffer-undo-list (eq this-command 'org-agenda-todo)))
      (set-window-configuration org-log-note-window-configuration)
      (with-current-buffer (marker-buffer org-log-note-return-to)
        (goto-char org-log-note-return-to))
      (move-marker org-log-note-return-to nil)
      (let ((file (buffer-file-name)))
        (magit-call-git "add" file)
        (magit-call-git "commit" "-m" (concat file ": " *org-git-notes))
        (magit-refresh))
      (when org-log-post-message (message "%s" org-log-post-message))))
  (advice-add 'org-store-log-note :override #'*org-store-log-note)
  )


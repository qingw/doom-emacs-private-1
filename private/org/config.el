;;; config.el -*- lexical-binding: t; -*-
(require 'org)

(setq org-default-journal-file
      (expand-file-name "journal.org.gpg" org-directory)
      ledger-journal-file
      (expand-file-name "ledger.gpg" org-directory))


(setq org-capture-templates
      '(("t" "Todo" entry (file+headline  org-default-notes-file "Daily Tasks")
         "* TODO %?\n  %i\n"
         :empty-lines 1)
        ("n" "Note" entry (file+headline  org-default-notes-file "Quick notes")
         "*  %? :NOTE:\n%U\n%a\n"
         :empty-lines 1)
        ("b" "Blog Ideas" entry (file+headline  org-default-notes-file "Blog Ideas")
         "* TODO %?\n  %i\n %U"
         :empty-lines 1)
        ("s" "Code Snippet" entry
         (file (expand-file-name  "snippets.org" org-directory))
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


(def-package! org-brain
  :commands org-brain-visualize
  :after org
  :init
  (setq org-brain-path "~/org/brain")
  (push 'org-agenda-mode evil-snipe-disabled-modes)
  ;; (add-hook 'org-agenda-mode-hook #'(lambda () (evil-vimish-fold-mode -1)))
  (set! :evil-state 'org-brain-visualize-mode 'normal)
  :config
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
  (setq org-brain-visualize-default-choices 'all
        org-brain-title-max-length 20)
  (set! :popup "^\\*org-brain\\*$" '((vslot . -1) (size . 0.3) (side . left)) '((select . t) (quit) (transient)))

  (map!
   "s-b"     #'org-brain-visualize
   (:map org-brain-visualize-mode-map
     :n "a" 'org-brain-visualize-attach
     :n "b" 'org-brain-visualize-back
     :n "c" 'org-brain-add-child
     :n "C" 'org-brain-remove-child
     :n "p" 'org-brain-add-parent
     :n "P" 'org-brain-remove-parent
     :n "f" 'org-brain-add-friendship
     :n "F" 'org-brain-remove-friendship
     :n "d" 'org-brain-delete-entry
     :n "G" 'revert-buffer
     :n "-" 'org-brain-new-child
     :n ";" 'org-brain-set-tags
     :n "j" 'forward-button
     :n "k" 'backward-button
     :n "l" 'org-brain-add-resource
     :n "L" 'org-brain-visualize-paste-resource
     :n "t" 'org-brain-set-title
     :n "m" 'org-brain-pin
     :n "o" 'ace-link-woman
     :n "q" 'org-brain-visualize-quit
     :n "r" 'org-brain-visualize-random
     :n "R" 'org-brain-visualize-wander
     :n "v" 'org-brain-visualize
     :n "g" 'org-brain-goto
     :n [tab] 'org-brain-goto-current
     )))

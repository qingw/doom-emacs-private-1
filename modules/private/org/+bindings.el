;;; +bindings.el -*- lexical-binding: t; -*-

(map!

 :gnvime "s-r" #'counsel-org-capture
 :gnvime "s-R" #'counsel-projectile-org-capture

 :gnvime "s-g" #'org-agenda-show-daily
 :gnvime "s-j" #'org-mru-clock-in
 :gnvime "s-J" #'org-mru-clock-select-recent-task


 :gnvime "s-b" #'org-brain-visualize

 (:leader
   :nv    "O"  #'org-capture

   (:desc "Org"  :prefix "o"
     ;; org-agenda
     :nv   "#"    #'org-agenda-list-stuck-projects
     :nv   "/"    #'org-occur-in-agenda-files
     :nv   "a"    #'org-agenda-list
     :nv   "c"    #'org-capture
     :nv   "e"    #'org-store-agenda-views
     :nv   "ki"   #'org-clock-in-last
     :nv   "kj"   #'org-clock-jump-to-current-clock
     :nv   "ko"   #'org-clock-out
     :nv   "kr"   #'org-resolve-clocks
     :nv   "l"    #'org-store-link
     :nv   "m"    #'org-tags-view
     :nv   "o"    #'org-agenda
     :nv   "s"    #'org-search-view
     :nv   "t"    #'org-todo-list
     ;; SPC C- capture/colors
     :nv   "c"    #'org-capture))

 (:after org-agenda
   (:map org-agenda-mode-map
     "C-c r" #'my-org-agenda-clockreport
     "R"     #'org-clock-budget-report
     "C-n"   #'org-agenda-next-item
     "C-p"   #'org-agenda-previous-item
     "P"     #'my-org-narrow-to-project
     "U"     #'my-org-narrow-to-parent
     "N"     #'my-org-narrow-to-subtree
     "W"     #'my-org-widen
     "/"     #'my-org-agenda-filter-by-tag
     "\\"    #'my-org-agenda-filter-by-tag-refine
     "o"     #'my-org-agenda-open-at-point

     ;; :nv "cR"    #'org-resolve-clocks
     "C-."   #'hydra-org-agenda/body

     "<s-up>"    #'org-clock-convenience-timestamp-up
     "<s-down>"  #'org-clock-convenience-timestamp-down
     "g"         #'org-clock-convenience-fill-gap
     "G"         #'org-clock-convenience-fill-gap-both
     ))

 (:after org
   (:map org-mode-map
     ;; :i [remap doom/inflate-space-maybe] #'org-self-insert-command
     ;; :i  "C-e"   #'org-end-of-line
     ;; :i  "C-a"   #'org-beginning-of-line
     :ni "C-c l" #'org-web-tools-insert-link-for-url
     :ni "C-c i" #'org-web-tools-insert-web-page-as-entry
     :ni "C-c I" #'org-web-tools-convert-links-to-page-entrys

     ;; TODO: when < not in first char
     :i "<"  (λ! (if (bolp) (hydra-org-template/body) (self-insert-command 1)))

     (:localleader
       :nv "'"    #'org-edit-special
       :nv "C"    #'org-capture

       :nv "e"   #'org-export-dispatch

       ;; Multi-purpose keys
       :nv  "*"     #'org-ctrl-c-star
       :nv  "-"     #'org-ctrl-c-minus
       :nv  "#"     #'org-update-statistics-cookies
       :nv  "RET"   #'org-ctrl-c-ret
       :nv  "M-RET" #'org-meta-return
       ;; attachments
       :nv  "A"     #'org-attach

       (:desc "Clock & Time"
         :prefix "c"
         :nv "c"   #'org-clock-cancel
         :nv "i"   #'org-clock-in
         :nv "o"   #'org-clock-out
         :nv "r"   #'org-resolve-clocks

         :nv "d"   #'org-deadline
         :nv "s"   #'org-schedule
         :nv "t"   #'org-time-stamp
         :nv "T"   #'org-time-stamp-inactive)

       (:desc "Toggle"
         :prefix "T"
         :nv "e"   #'org-toggle-pretty-entities
         :nv "i"   #'org-toggle-inline-images
         :nv "l"   #'org-toggle-link-display
         :nv "t"   #'org-show-todo-tree
         :nv "T"   #'org-todo
         :nv "V"   #'space-doc-mode
         :nv "x"   #'org-toggle-latex-fragment)

       ;; More cycling options (timestamps, headlines, items, properties)
       :nv "L"    #'org-shiftright
       :nv "H"    #'org-shiftleft
       :nv "J"    #'org-shiftdown
       :nv "K"    #'org-shiftup

       ;; Change between TODO sets
       :nv "C-S-l"  #'org-shiftcontrolright
       :nv "C-S-h"  #'org-shiftcontrolleft
       :nv "C-S-j"  #'org-shiftcontroldown
       :nv "C-S-k"  #'org-shiftcontrolup

       ;; Subtree editing
       (:desc "Subtree edit"
         :prefix "s"

         :nv  "a"     #'org-toggle-archive-tag
         :nv  "A"     #'org-archive-subtree
         :nv  "b"     #'org-tree-to-indirect-buffer
         :nv  "h"     #'org-promote-subtree
         :nv  "j"     #'org-move-subtree-down
         :nv  "k"     #'org-move-subtree-up
         :nv  "l"     #'org-demote-subtree
         :nv  "N"     #'org-narrow-to-subtree
         :nv  "W"     #'widen
         :nv  "r"     #'org-refile
         :nv  "K"     #'org-cut-subtree
         :nv  "s"     #'org-sparse-tree
         :nv  "S"     #'org-sort)

       ;; tables
       (:desc  "Table"
         :prefix "t"
         :nv  "a"     #'org-table-align
         :nv  "b"     #'org-table-blank-field
         :nv  "c"     #'org-table-convert
         :nv  "dc"    #'org-table-delete-column
         :nv  "dr"    #'org-table-kill-row
         :nv  "e"     #'org-table-eval-formula
         :nv  "E"     #'org-table-export
         :nv  "h"     #'org-table-previous-field
         :nv  "H"     #'org-table-move-column-left
         :nv  "ic"    #'org-table-insert-column
         :nv  "ih"    #'org-table-insert-hline
         :nv  "iH"    #'org-table-hline-and-move
         :nv  "ir"    #'org-table-insert-row
         :nv  "I"     #'org-table-import
         :nv  "j"     #'org-table-next-row
         :nv  "J"     #'org-table-move-row-down
         :nv  "K"     #'org-table-move-row-up
         :nv  "l"     #'org-table-next-field
         :nv  "L"     #'org-table-move-column-right
         :nv  "n"     #'org-table-create
         :nv  "N"     #'org-table-create-with-table.el
         :nv  "r"     #'org-table-recalculate
         :nv  "s"     #'org-table-sort-lines
         :nv  "tf"    #'org-table-toggle-formula-debugger
         :nv  "to"    #'org-table-toggle-coordinate-overlays
         :nv  "w"     #'org-table-wrap-region)

       ;; Source blocks / org-babel
       ;; :desc  "org-babel"  :prefix "b"
       (:desc  "Babel"
         :prefix "b"

         :nv  "p"    #'org-babel-previous-src-block
         :nv  "n"    #'org-babel-next-src-block
         :nv  "e"    #'org-babel-execute-maybe
         :nv  "o"    #'org-babel-open-src-block-result
         :nv  "v"    #'org-babel-expand-src-block
         :nv  "u"    #'org-babel-goto-src-block-head
         :nv  "g"    #'org-babel-goto-named-src-block
         :nv  "r"    #'org-babel-goto-named-result
         :nv  "b"    #'org-babel-execute-buffer
         :nv  "s"    #'org-babel-execute-subtree
         :nv  "d"    #'org-babel-demarcate-block
         :nv  "t"    #'org-babel-tangle
         :nv  "f"    #'org-babel-tangle-file
         :nv  "c"    #'org-babel-check-src-block
         :nv  "j"    #'org-babel-insert-header-arg
         :nv  "l"    #'org-babel-load-in-session
         :nv  "i"    #'org-babel-lob-ingest
         :nv  "I"    #'org-babel-view-src-block-info
         :nv  "z"    #'org-babel-switch-to-session
         :nv  "Z"    #'org-babel-switch-to-session-with-code
         :nv  "a"    #'org-babel-sha1-hash
         :nv  "x"    #'org-babel-do-key-sequence-in-edit-buffer
         :nv  "."    #'spacemacs/org-babel-transient-state/body)

       ;; insertion
       (:desc "Insert"
         :prefix "i"
         :nv  "d"    #'org-insert-drawer
         :nv  "e"    #'org-set-effort
         :nv  "f"    #'org-footnote-new
         :nv  "h"    #'org-insert-heading
         :nv  "H"    #'org-insert-heading-after-current
         :nv  "K"    #'spacemacs/insert-keybinding-org
         :nv  "l"    #'org-insert-link
         :nv  "p"    #'org-set-property
         :nv  "s"    #'org-insert-subheading
         :nv  "t"    #'org-set-tags)

       ;; region manipulation
       ;; "xb" (spacemacs|org-emphasize spacemacs/org-bold ?*)
       ;; "xc" (spacemacs|org-emphasize spacemacs/org-code ?~)
       ;; "xi" (spacemacs|org-emphasize spacemacs/org-italic ?/)
       :nv  "xo" 'org-open-at-point
       ;; "xr" (spacemacs|org-emphasize spacemacs/org-clear ? )
       ;; "xs" (spacemacs|org-emphasize spacemacs/org-strike-through ?+)
       ;; "xu" (spacemacs|org-emphasize spacemacs/org-underline ?_)
       ;; "xv" (spacemacs|org-emphasize spacemacs/org-verbatim ?=)
       )
     )
   ))

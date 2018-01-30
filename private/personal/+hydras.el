;;; +hydras.el -*- lexical-binding: t; -*-

(defhydra hydra-yasnippet (:color blue :hint nil)
  "
              ^YASnippets^
--------------------------------------------
  Modes:    Load/Visit:    Actions:

 _g_lobal  _d_irectory    _i_nsert
 _m_inor   _f_ile         _t_ryout
 _e_xtra   _l_ist         _n_ew
         _a_ll
"
  ("d" yas-load-directory)
  ("e" yas-activate-extra-mode)
  ("i" yas-insert-snippet)
  ("f" yas-visit-snippet-file :color blue)
  ("n" yas-new-snippet)
  ("t" yas-tryout-snippet)
  ("l" yas-describe-tables)
  ("g" yas/global-mode)
  ("m" yas/minor-mode)
  ("a" yas-reload-all))

;; (spacemacs/set-leader-keys "os" 'hydra-yasnippet/body)

(defhydra hydra-outline (:color pink :hint nil)
  "
^Hide^             ^Show^           ^Move
^^^^^^------------------------------------------------------
_q_: sublevels     _a_: all         _u_: up
_t_: body          _e_: entry       _n_: next visible
_o_: other         _i_: children    _p_: previous visible
_c_: entry         _k_: branches    _f_: forward same level
_l_: leaves        _s_: subtree     _b_: backward same level
_d_: subtree

"
  ;; Hide
  ("q" hide-sublevels) ; Hide everything but the top-level headings
  ("t" hide-body)	 ; Hide everything but headings (all body lines)
  ("o" hide-other) ; Hide other branches
  ("c" hide-entry) ; Hide this entry's body
  ("l" hide-leaves) ; Hide body lines in this entry and sub-entries
  ("d" hide-subtree) ; Hide everything in this entry and sub-entries
  ;; Show
  ("a" show-all)          ; Show (expand) everything
  ("e" show-entry)        ; Show this heading's body
  ("i" show-children)	; Show this heading's immediate child sub-headings
  ("k" show-branches)	; Show all sub-headings under this heading
  ("s" show-subtree) ; Show (expand) everything in this heading & below
  ;; Move
  ("u" outline-up-heading)			   ; Up
  ("n" outline-next-visible-heading)	   ; Next
  ("p" outline-previous-visible-heading) ; Previous
  ("f" outline-forward-same-level)	   ; Forward - same level
  ("b" outline-backward-same-level)	   ; Backward - same level
  ("z" nil "leave"))

;; (global-set-key (kbd "C-c #") 'hydra-outline/body) ; by example

(define-key Info-mode-map (kbd "h") 'Info-backward-node) ;; h was Info-help, Info-backward-node was [
(define-key Info-mode-map (kbd "l") 'Info-forward-node)	;; l was Info-history-back, Info-forward-node was ]
(define-key Info-mode-map (kbd "y") 'Info-help)	;; y wasn't bound, Info-help was h
(define-key Info-mode-map (kbd "K") 'Info-history) ;; K wasn't bound, Info-history was L
(define-key Info-mode-map (kbd "H") 'Info-history-back)	;; H was describe-mode, Info-history-back was l
(define-key Info-mode-map (kbd "L") 'Info-history-forward) ;; L was Info-history, Info-history-forward was r
(define-key Info-mode-map (kbd "k") 'Info-up) ;; k wasn't bound, Info-up was ^ and u
(define-key Info-mode-map (kbd "j") 'Info-menu)	;; j was bmkp-info-jump, Info-menu was m
(define-key Info-mode-map (kbd "b") 'bmkp-info-jump) ;; b was beginning-of-buffer, bmkp-info-jump was j

(defhydra hydra-info (:color pink
                             :hint nil)
  "
Info-mode:
_I_ndex(virtual)    _T_OC                            ^ ^^ ^  ^ ^ ^^     _k_/_u_p   ( )
_i_ndex             _t_op node        Node           _[__h_ + _l__]_      _j_/_m_enu ( ) (C-u for new window)
_c_opy node name    _a_propos         Top/Final Node _<__t_   ^ ^_>_      _g_oto node^^    (C-u for new window)
_C_lone buffer      _f_ollow          Level nxt/prev _p_^ ^   ^ ^_n_
_d_irectory         _b_mkp-jump       History        _H_^ ^   ^ ^_L_      _K_ History^^

_s_earch regex (_S_ case sens) ^^^^   _1_ .. _9_ Pick first .. ninth item in the node's menu.
"
  ("j"   Info-menu) ;; m
  ("k"   Info-up)	  ;; ^
  ("m"   Info-menu)
  ("u"   Info-up)

  ("l"   Info-forward-node)
  ("h"   Info-backward-node)
  ("]"   Info-forward-node)
  ("["   Info-backward-node)

  ("t"   Info-top-node)
  ("<"   Info-top-node)
  (">"   Info-final-node)

  ("n"   Info-next)
  ("p"   Info-prev)

  ("K"   Info-history)
  ("H"   Info-history-back)
  ("L"   Info-history-forward)

  ("s"   Info-search)
  ("S"   Info-search-case-sensitively)

  ("g"   Info-goto-node)

  ("f"   Info-follow-reference)
  ("b"   bmkp-info-jump)
  ("i"   Info-index)
  (","   Info-index-next)
  ("I"   Info-virtual-index)

  ("T"   Info-toc)
  ("t"   Info-top-node)
  ("d"   Info-directory)
  ("c"   Info-copy-current-node-name)
  ("C"   clone-buffer)
  ("a"   info-apropos)

  ("1"   Info-nth-menu-item)
  ("2"   Info-nth-menu-item)
  ("3"   Info-nth-menu-item)
  ("4"   Info-nth-menu-item)
  ("5"   Info-nth-menu-item)
  ("6"   Info-nth-menu-item)
  ("7"   Info-nth-menu-item)
  ("8"   Info-nth-menu-item)
  ("9"   Info-nth-menu-item)

  ("?"   Info-summary "Info summary")
  ("y"   Info-help "Info help")
  ("q"   Info-exit "Info exit" :color blue)
  ("C-g" nil "cancel" :color blue))

;; (define-key Info-mode-map (kbd ".") #'hydra-info/body)

(defhydra hydra-macro (:hint nil :color pink :pre
                             (when defining-kbd-macro
                               (kmacro-end-macro 1)))
  "
  ^Create-Cycle^   ^Basic^           ^Insert^        ^Save^         ^Edit^
╭─────────────────────────────────────────────────────────────────────────╯
     ^_i_^           [_e_] execute    [_n_] insert    [_b_] name      [_'_] previous
     ^^↑^^           [_d_] delete     [_t_] set       [_K_] key       [_,_] last
 _j_ ←   → _l_       [_o_] edit       [_a_] add       [_x_] register
     ^^↓^^           [_r_] region     [_f_] format    [_B_] defun
     ^_k_^           [_m_] step
    ^^   ^^          [_s_] swap
"
  ("j" kmacro-start-macro :color blue)
  ("l" kmacro-end-or-call-macro-repeat)
  ("i" kmacro-cycle-ring-previous)
  ("k" kmacro-cycle-ring-next)
  ("r" apply-macro-to-region-lines)
  ("d" kmacro-delete-ring-head)
  ("e" kmacro-end-or-call-macro-repeat)
  ("o" kmacro-edit-macro-repeat)
  ("m" kmacro-step-edit-macro)
  ("s" kmacro-swap-ring)
  ("n" kmacro-insert-counter)
  ("t" kmacro-set-counter)
  ("a" kmacro-add-counter)
  ("f" kmacro-set-format)
  ("b" kmacro-name-last-macro)
  ("K" kmacro-bind-to-key)
  ("B" insert-kbd-macro)
  ("x" kmacro-to-register)
  ("'" kmacro-edit-macro)
  ("," edit-kbd-macro)
  ("q" nil :color blue))



(defhydra hydra-ediff (:color blue :hint nil)
  "
^Buffers           Files           VC                     Ediff regions
----------------------------------------------------------------------
_b_uffers           _f_iles (_=_)       _r_evisions              _l_inewise
_B_uffers (3-way)   _F_iles (3-way)                          _w_ordwise
                  _c_urrent file
"
  ("b" ediff-buffers)
  ("B" ediff-buffers3)
  ("=" ediff-files)
  ("f" ediff-files)
  ("F" ediff-files3)
  ("c" ediff-current-file)
  ("r" ediff-revision)
  ("l" ediff-regions-linewise)
  ("w" ediff-regions-wordwise))

(defhydra hydra-ag (:exit t
                          :columns 2
                          :idle 1.0)
  "Ag Search"
  ("c" helm-ag "Current directory")
  ("d" (lambda ()
         (interactive)
         (let ((current-prefix-arg '(4)))
           (call-interactively 'helm-ag))) "Select directory")
  ("D" helm-do-ag "Select directory (interactive)")
  ("f" helm-ag-this-file "Current file")
  ("F" helm-do-ag-this-file "Current file (interactive)")
  ("p" helm-ag-project-root "Project")
  ("b" helm-ag-buffers "Buffers")
  ("B" helm-do-ag-buffers "Buffers (interactive)"))

;; (spacemacs/set-leader-keys "s." 'hydra-ag/body)

;; Hydra - Multiple cursors
(defhydra multiple-cursors-hydra (:columns 3
                                           :idle 1.0)
  "Multiple cursors"
  ("l" mc/edit-lines "Edit lines in region" :exit t)
  ("b" mc/edit-beginnings-of-lines "Edit beginnings of lines in region" :exit t)
  ("e" mc/edit-ends-of-lines "Edit ends of lines in region" :exit t)
  ("a" mc/mark-all-dwim "Mark all dwim" :exit t)
  ("S" mc/mark-all-symbols-like-this "Mark all symbols likes this" :exit t)
  ("w" mc/mark-all-words-like-this "Mark all words like this" :exit t)
  ("r" mc/mark-all-in-region "Mark all in region" :exit t)
  ("R" mc/mark-all-in-region-regexp "Mark all in region (regexp)" :exit t)
  ("d" mc/mark-all-like-this-in-defun "Mark all like this in defun" :exit t)
  ("s" mc/mark-all-symbols-like-this-in-defun "Mark all symbols like this in defun" :exit t)
  ("W" mc/mark-all-words-like-this-in-defun "Mark all words like this in defun" :exit t)
  ("i" mc/insert-numbers "Insert numbers" :exit t)
  ("n" mc/mark-next-like-this "Mark next like this")
  ("N" mc/skip-to-next-like-this "Skip to next like this")
  ("M-n" mc/unmark-next-like-this "Unmark next like this")
  ("p" mc/mark-previous-like-this "Mark previous like this")
  ("P" mc/skip-to-previous-like-this "Skip to previous like this")
  ("M-p" mc/unmark-previous-like-this "Unmark previous like this")
  ("q" nil "Quit" :exit t))

;; (spacemacs/set-leader-keys "mm" 'multiple-cursors-hydra/body)

(defhydra hydra-org-template (:color blue :hint nil)
  "
_C_enter  _q_uote    plant_u_ml    _L_aTeX:
_l_atex   _e_xample  _s_hell       _i_ndex:
_a_scii   _v_erse    _E_macs-lisp  _I_NCLUDE:
s_r_c     ^ ^        _p_ython      _H_TML:
_h_tml    ^ ^        Lil_y_pond    _A_SCII:
"
  ("c" (hot-expand-and-edit "clojure"))
  ("s" (hot-expand-and-edit "shell"))
  ("E" (hot-expand-and-edit "emacs-lisp"))
  ("p" (hot-expand-and-edit "python"))
  ("y" (hot-expand-and-edit "lilypond"))
  ("u" (hot-expand-and-edit "plantuml :file CHANGE.png"))
  ;; ("r" (hot-expand "<s"))
  ("r" (call-interactively 'src-expand-and-edit))
  ("e" (hot-expand "<e"))
  ("q" (hot-expand "<q"))
  ("v" (hot-expand "<v"))
  ("C" (hot-expand "<c"))
  ("l" (hot-expand "<l"))
  ("h" (hot-expand "<h"))
  ("a" (hot-expand "<a"))
  ("L" (hot-expand "<L"))
  ("i" (hot-expand "<i"))
  ("I" (hot-expand "<I"))
  ("H" (hot-expand "<H"))
  ("A" (hot-expand "<A"))
  ("<" self-insert-command "ins")
  ("o" nil "quit"))
(defun hot-expand (str)
  "Expand org template."
  (insert str)
  (org-try-structure-completion))
(defun hot-expand-and-edit (str)
  "Expand src template for given languange and enter org-edit-special."
  (hot-expand "<s")
  (insert str)
  (forward-line)
  (evil-normal-state)
  (org-edit-special)
  (evil-insert-state))
(defun src-expand-and-edit ()
  "Expand select src type block and edit in org-mode"
  (interactive)
  (ivy-read "Source code type: "
            '("emacs-lisp" "python" "C" "shell" "java" "js" "clojure" "C++" "css"
              "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
              "octave" "oz" "plantuml" "R" "sass" "screen" "sql" "awk" "ditaa"
              "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
              "scheme" "sqlite")
            :action (lambda (x) (hot-expand-and-edit x ))
            ))

;; Hydra for org agenda (graciously taken from Spacemacs)
(defhydra hydra-org-agenda (:pre (setq which-key-inhibit t)
                                 :post (setq which-key-inhibit nil)
                                 :hint none)
  "
Org agenda (_q_uit)

^Clock^      ^Visit entry^              ^Date^             ^Other^
^-----^----  ^-----------^------------  ^----^-----------  ^-----^---------
_ci_ in      _SPC_ in other window      _ds_ schedule      _gr_ reload
_co_ out     _TAB_ & go to location     _dd_ set deadline  _._  go to today
_cq_ cancel  _RET_ & del other windows  _dt_ timestamp     _gd_ go to date
_cj_ jump    _o_   link                 _+_  do later      ^^
^^           ^^                         _-_  do earlier    ^^
^^           ^^                         ^^                 ^^
^View^          ^Filter^                 ^Headline^         ^Toggle mode^
^----^--------  ^------^---------------  ^--------^-------  ^-----------^----
_vd_ day        _ft_ by tag              _ht_ set status    _tf_ follow
_vw_ week       _fr_ refine by tag       _hk_ kill          _tl_ log
_vt_ fortnight  _fc_ by category         _hr_ refile        _ta_ archive trees
_vm_ month      _fh_ by top headline     _hA_ archive       _tA_ archive files
_vy_ year       _fx_ by regexp           _h:_ set tags      _tr_ clock report
_vn_ next span  _fd_ delete all filters  _hp_ set priority  _td_ diaries
_vp_ prev span  ^^                       ^^                 ^^
_vr_ reset      ^^                       ^^                 ^^
^^              ^^                       ^^                 ^^
"
  ;; Entry
  ("hA" org-agenda-archive-default)
  ("hk" org-agenda-kill)
  ("hp" org-agenda-priority)
  ("hr" org-agenda-refile)
  ("h:" org-agenda-set-tags)
  ("ht" org-agenda-todo)
  ;; Visit entry
  ("o"   link-hint-open-link :exit t)
  ("<tab>" org-agenda-goto :exit t)
  ("TAB" org-agenda-goto :exit t)
  ("SPC" org-agenda-show-and-scroll-up)
  ("RET" org-agenda-switch-to :exit t)
  ;; Date
  ("dt" org-agenda-date-prompt)
  ("dd" org-agenda-deadline)
  ("+" org-agenda-do-date-later)
  ("-" org-agenda-do-date-earlier)
  ("ds" org-agenda-schedule)
  ;; View
  ("vd" org-agenda-day-view)
  ("vw" org-agenda-week-view)
  ("vt" org-agenda-fortnight-view)
  ("vm" org-agenda-month-view)
  ("vy" org-agenda-year-view)
  ("vn" org-agenda-later)
  ("vp" org-agenda-earlier)
  ("vr" org-agenda-reset-view)
  ;; Toggle mode
  ("ta" org-agenda-archives-mode)
  ("tA" (org-agenda-archives-mode 'files))
  ("tr" org-agenda-clockreport-mode)
  ("tf" org-agenda-follow-mode)
  ("tl" org-agenda-log-mode)
  ("td" org-agenda-toggle-diary)
  ;; Filter
  ("fc" org-agenda-filter-by-category)
  ("fx" org-agenda-filter-by-regexp)
  ("ft" org-agenda-filter-by-tag)
  ("fr" org-agenda-filter-by-tag-refine)
  ("fh" org-agenda-filter-by-top-headline)
  ("fd" org-agenda-filter-remove-all)
  ;; Clock
  ("cq" org-agenda-clock-cancel)
  ("cj" org-agenda-clock-goto :exit t)
  ("ci" org-agenda-clock-in :exit t)
  ("co" org-agenda-clock-out)
  ;; Other
  ("q" nil :exit t)
  ("gd" org-agenda-goto-date)
  ("." org-agenda-goto-today)
  ("gr" org-agenda-redo))

(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-x C-q : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir    C-c C-c : commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          C-c ESC : abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _._ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp
_Z_ compress       _Q_ repl regexp

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff) ;; smart diff
  ("?" dired-summary)
  ("$" diredp-hide-subdir-nomove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)	;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)	;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay) ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file) ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("q" nil)
  ("." nil :color blue))

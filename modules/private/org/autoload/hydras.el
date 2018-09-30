;;; hydras.el -*- lexical-binding: t; -*-

;; More of those nice template expansion
(add-to-list 'org-structure-template-alist '("A" "#+DATE: ?"))
(add-to-list 'org-structure-template-alist '("C" "#+BEGIN_CENTER\n?\n#+END_CENTER\n"))
(add-to-list 'org-structure-template-alist '("D" "#+DESCRIPTION: ?"))
(add-to-list 'org-structure-template-alist '("E" "#+BEGIN_EXAMPLE\n?\n#+END_EXAMPLE\n"))
(add-to-list 'org-structure-template-alist '("H" "#+LATEX_HEADER: ?"))
(add-to-list 'org-structure-template-alist '("I" ":INTERLEAVE_PDF: ?"))
(add-to-list 'org-structure-template-alist '("L" "#+BEGIN_LaTeX\n?\n#+END_LaTeX"))
(add-to-list 'org-structure-template-alist '("M" "#+LATEX_HEADER: \\usepackage{minted}\n"))
(add-to-list 'org-structure-template-alist '("N" "#+NAME: ?"))
(add-to-list 'org-structure-template-alist '("P" "#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\"org.css\"/>\n"))
(add-to-list 'org-structure-template-alist '("S" "#+SUBTITLE: ?"))
(add-to-list 'org-structure-template-alist '("T" ":DRILL_CARD_TYPE: twosided"))
(add-to-list 'org-structure-template-alist '("V" "#+BEGIN_VERSE\n?\n#+END_VERSE"))
(add-to-list 'org-structure-template-alist '("X" "#+EXCLUDE_TAGS: reveal?"))
(add-to-list 'org-structure-template-alist '("a" "#+AUTHOR: ?"))
(add-to-list 'org-structure-template-alist '("c" "#+CAPTION: ?"))
(add-to-list 'org-structure-template-alist '("d" "#+OPTIONS: ':nil *:t -:t ::t <:t H:3 \\n:nil ^:t arch:headline\n#+OPTIONS: author:t email:nil e:t f:t inline:t creator:nil d:nil date:t\n#+OPTIONS: toc:nil num:nil tags:nil todo:nil p:nil pri:nil stat:nil c:nil d:nil\n#+LATEX_HEADER: \\usepackage[margin=2cm]{geometry}\n#+LANGUAGE: en\n\n#+REVEAL_TRANS: slide\n#+REVEAL_THEME: white\n#+REVEAL_ROOT: file:///Users/sriramkswamy/Documents/github/reveal.js\n\n?"))
(add-to-list 'org-structure-template-alist '("e" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC"))
(add-to-list 'org-structure-template-alist '("f" "#+TAGS: @?"))
(add-to-list 'org-structure-template-alist '("h" "#+BEGIN_HTML\n?\n#+END_HTML\n"))
(add-to-list 'org-structure-template-alist '("i" "#+INTERLEAVE_PDF: ?"))
(add-to-list 'org-structure-template-alist '("k" "#+KEYWORDS: ?"))
(add-to-list 'org-structure-template-alist '("l" "#+LABEL: ?"))
(add-to-list 'org-structure-template-alist '("m" "#+BEGIN_SRC matlab\n?\n#+END_SRC"))
(add-to-list 'org-structure-template-alist '("n" "#+BEGIN_NOTES\n?\n#+END_NOTES"))
(add-to-list 'org-structure-template-alist '("o" "#+OPTIONS: ?"))
(add-to-list 'org-structure-template-alist '("p" "#+BEGIN_SRC python\n?\n#+END_SRC"))
(add-to-list 'org-structure-template-alist '("q" "#+BEGIN_QUOTE\n?\n#+END_QUOTE"))
(add-to-list 'org-structure-template-alist '("r" ":PROPERTIES:\n?\n:END:"))
(add-to-list 'org-structure-template-alist '("s" "#+BEGIN_SRC ?\n#+END_SRC\n"))
(add-to-list 'org-structure-template-alist '("t" "#+TITLE: ?"))
(add-to-list 'org-structure-template-alist '("v" "#+BEGIN_VERBATIM\n?\n#+END_VERBATIM"))

(defhydra sk/hydra-org-template (:color blue
                                  :hint nil)
  "
 ^One liners^                                        ^Blocks^                                      ^Properties^
--------------------------------------------------------------------------------------------------------------------------------------------------------
 _a_: author        _i_: interleave  _D_: description    _C_: center      _p_: python src    _n_: notes    _d_: defaults   _r_: properties        _<_: insert '<'
 _A_: date          _l_: label       _S_: subtitle       _e_: elisp src   _Q_: quote         _L_: latex    _x_: export     _I_: interleave        _q_: quit
 _c_: caption       _N_: name        _k_: keywords       _E_: example     _s_: src                       _X_: noexport   _T_: drill two-sided
 _f_: file tags     _o_: options     _M_: minted         _h_: html        _v_: verbatim
 _H_: latex header  _t_: title       _P_: publish        _m_: matlab src  _V_: verse
 "
  ("a" (hot-expand "<a"))
  ("A" (hot-expand "<A"))
  ("c" (hot-expand "<c"))
  ("f" (hot-expand "<f"))
  ("H" (hot-expand "<H"))
  ("i" (hot-expand "<i"))
  ("I" (hot-expand "<I"))
  ("l" (hot-expand "<l"))
  ("n" (hot-expand "<n"))
  ("N" (hot-expand "<N"))
  ("P" (hot-expand "<P"))
  ("o" (hot-expand "<o"))
  ("t" (hot-expand "<t"))
  ("C" (hot-expand "<C"))
  ("D" (hot-expand "<D"))
  ("e" (hot-expand "<e"))
  ("E" (hot-expand "<E"))
  ("h" (hot-expand "<h"))
  ("k" (hot-expand "<k"))
  ("M" (hot-expand "<M"))
  ("m" (hot-expand "<m"))
  ("p" (hot-expand "<p"))
  ("Q" (hot-expand "<q"))
  ("s" (hot-expand "<s"))
  ("S" (hot-expand "<S"))
  ("v" (hot-expand "<v"))
  ("V" (hot-expand "<V"))
  ("x" (hot-expand "<x"))
  ("X" (hot-expand "<X"))
  ("d" (hot-expand "<d"))
  ("L" (hot-expand "<L"))
  ("r" (hot-expand "<r"))
  ("I" (hot-expand "<I"))
  ("T" (hot-expand "<T"))
  ("b" (hot-expand "<b"))
  ("<" self-insert-command)
  ("q" nil :color blue))

(defhydra hydra-org-clock (:color blue :timeout 12 :columns 4)
  "Org commands"
  ("i" (lambda () (interactive) (org-clock-in '(4))) "Clock in")
  ("o" org-clock-out "Clock out")
  ("q" org-clock-cancel "Cancel a clock")
  ("<f10>" org-clock-in-last "Clock in the last task")
  ("j" (lambda () (interactive) (org-clock-goto '(4))) "Go to a clock")
  ("m" make-this-message-into-an-org-todo-item "Flag and capture this message"))

(defhydra hydra-clock (:color blue)
  "
  ^
  ^Clock^             ^Do^
  ^─────^─────────────^──^─────────
  _q_ quit            _c_ cancel
  ^^                  _d_ display
  ^^                  _e_ effort
  ^^                  _i_ in
  ^^                  _j_ jump
  ^^                  _o_ out
  ^^                  _r_ report
  ^^                  ^^
  "
  ("q" nil)
  ("c" org-clock-cancel :color pink)
  ("d" org-clock-display)
  ("e" org-clock-modify-effort-estimate)
  ("i" org-clock-in)
  ("j" org-clock-goto)
  ("o" org-clock-out)
  ("r" org-clock-report))

(defhydra hydra-org (:color blue)
  "
  ^
  ^Org^             ^Do^
  ^───^─────────────^──^─────────────
  _q_ quit          _A_ archive
  ^^                _a_ agenda
  ^^                _c_ capture
  ^^                _d_ decrypt
  ^^                _i_ insert-link
  ^^                _j_ jump-task
  ^^                _k_ cut-subtree
  ^^                _o_ open-link
  ^^                _r_ refile
  ^^                _s_ store-link
  ^^                _t_ todo-tree
  ^^                ^^
  "
  ("q" nil)
  ("A" my/org-archive-done-tasks :color pink)
  ("a" org-agenda)
  ("c" org-capture)
  ("d" org-decrypt-entry)
  ("k" org-cut-subtree)
  ("i" org-insert-link-global)
  ("j" my/org-jump)
  ("o" org-open-at-point-global)
  ("r" org-refile)
  ("s" org-store-link)
  ("t" org-show-todo-tree))

(defhydra hydra-org2 (:color blue :hint nil :exit nil :foreign-keys nil)
  "

^Org Mode^
------------------------------------------------------------------------
_y_ ivy todo     _d_ deadline       _t_ tags          _e_mphasis-s
_c_ calendar     _w_ widen          _A_ align tags    _E_mphasis-h
_a_ agenda       _h_ hide other     _o_ goto
_r_ refile       _l_ store link     _g_ goto all
_b_ sw. buffe    _s_ sort todos     _s_ sync
_i_ cliplink     _S_ spart tree     _p_ edit special
  "
("q" nil)
("SPC o" nil)
("<escape>" nil)
("E" org-hide-emphasis)
("e" org-show-emphasis)
("y" ivy-todo)
("c" calendar)
("r" org-refile)
("b" org-switchb)
("i" org-cliplink)
("d" org-deadline)
("w" widenToCenter)
("h" org-hide-other)
("l" org-store-link)
("s" org-sort-todos)
("S" org-sparse-tree)
("t" counsel-org-tag)
("p" org-edit-special)
("o" counsel-org-goto)
("g" counsel-org-goto-all)
("A" org-align-all-tags)
("T" org-set-tags-command)
("c" counsel-org-capture)
("n" org-narrow-to-subtree)
("x" org-toggle-latex-fragment)
("u" org-archive-subtree-default)
("a" hydra-org-agenda/body))

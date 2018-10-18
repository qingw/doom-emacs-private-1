;;; private/+bindings.el -*- lexical-binding: t; -*-

;;
(map! :gnvime "M-;" #'evil-commentary-line
      :gnvime "M-:" #'eval-expression
      :gnvime "s-:" #'doom/open-scratch-buffer
      :gnvime "s-;" #'evil-ex

      :gnvime "C-M-:" #'doom/open-scratch-buffer

      :gnvime "M-J" #'drag-stuff-down
      :gnvime "M-K" #'drag-stuff-up

      ;; Window Movements
      "C-M-h"         #'previous-multiframe-window
      "C-M-l"         #'next-multiframe-window
      "s-i"           #'ivy-resume
      "s-m"           #'doom/window-zoom

      "s-d"           #'evil-window-vsplit
      "s-D"           #'evil-window-split

      "s-/"           #'counsel-imenu
      "C-M-/"         #'undo-tree-visualize
      "s-?"           #'ivy-imenu-anywhere

      :n  "s-k"       #'kill-this-buffer
      :n  "s-K"       #'delete-frame
      :nv "M-SPC"     #'+evil:fold-toggle

      :gnvime "M-g"   #'goto/body

      :nie "C-S-u"    #'doom/backward-kill-to-bol-and-indent
      :nie "C-u"      #'kill-line

      :nie "\C-b"     #'backward-char
      :nie "\C-f"     #'forward-char

      ;; "C-s"           #'counsel-grep-or-swiper
      ;; "C-S-s"         #'doom/swiper-region-or-symbol
      ;; "C-M-s"         #'swiper-all
      ;; "C-M-S-s"       #'doom/swiper-all-region-or-symbol

      :nvime  "C-y" #'evil-paste-before
      :nvime  "M-y" #'evil-paste-pop
      :nvime  "M-Y" #'evil-paste-pop-next

      :nv  "p"      #'hydra-yank-pop/evil-paste-after
      :nv  "P"      #'hydra-yank-pop/evil-paste-before


      ;; Other sensible, textmate-esque global bindings
      ;; :m  "A-j"   #'+default:multi-next-line
      ;; :m  "A-k"   #'+default:multi-previous-line
      ;; :nv "C-SPC" #'+evil:fold-toggle
      :gnvimer "s-v" #'clipboard-yank

      "C-x p"     #'+popup/other


      ;; --- <leader> -------------------------------------
      (:leader
        ;; Most commonly used
        :desc "extended command"        :n "SPC" #'execute-extended-command
        :desc "Toggle last popup"       :n "`"   #'+popup/toggle

        (:desc "search" :prefix "s"
          :desc "Project"                :nv "p" #'+ivy/project-search
          :desc "Directory"              :nv "d" (λ! (+ivy/project-search t))
          :desc "Buffer"                 :nv "b" #'swiper
          :desc "Symbols"                :nv "i" #'imenu
          :desc "Symbols across buffers" :nv "I" #'imenu-anywhere
          :desc "counsel-rg"             :nv "s" #'counsel-rg
          :desc "show marks"             :nv "m" #'evil-show-marks
          :desc "show registers"         :nv "r" #'evil-show-registers
          :desc "Online providers"       :nv "o" #'+lookup/online-select)

        (:desc "buffer" :prefix "b"
          :desc "Revert buffer"           :n "r" #'revert-buffer
          :desc "VC Revert buffer"        :n "R" #'vc-revert-buffer
          :desc "Doom dashboard"          :n "h" #'+doom-dashboard/open
          :desc "Switch to *Messages*"    :n "M" (λ! (switch-to-buffer "*Messages*"))
          :desc "Switch to *scrach*"      :n "X" (λ! (switch-to-buffer "*scratch*")))

        (:desc "file" :prefix "f"
          :desc "Counsel file fzf"          :n "/" #'counsel-fzf
          :desc "Copy this file"            :n "C" #'doom/copy-this-file
          :desc "Find file in project"      :n "f" #'projectile-find-file)

        (:desc "git" :prefix "g"
          :desc "Git Hydra"             :n  "." #'+version-control@git-gutter/body
          )

        (:desc "help" :prefix "h"
          :desc "Help map"              :n  "h" help-map
          :desc "Find function"         :n  "J" #'find-function
          :desc "Which key top level"   :n  "b" #'which-key-show-top-level
          :desc "Which key major mode"  :n  "B" #'which-key-show-major-mode
          :desc "Which key mino mode"   :n  "C-b" #'which-key-show-minor-mode-keymap
          :desc "Describe keybriefly"   :n  "c" #'describe-key-briefly
          :desc "Describe char"         :n  "C" #'describe-char
          :desc "Toggle profiler"       :n  "p" #'doom/toggle-profiler)

        (:desc "insert" :prefix "i"
          :desc "Time stamp"            :nv "t" #'hydra/timestamp/body)

        (:desc "project" :prefix "p"
          :desc "Search project with rg"  :n  "s" #'counsel-projectile-rg
          :desc "Find file in project"    :n  "f" #'projectile-find-file
          :desc "Projectile kill buffers" :n  "k" #'projectile-kill-buffers)

        (:desc "quit" :prefix "q"
          :desc "Restart Emacs"          :n "r" #'restart-emacs)

        (:desc "snippets" :prefix "y"
          :desc "New snippet"            :n  "n" #'yas-new-snippet
          :desc "Insert snippet"         :nv "i" #'yas-insert-snippet
          :desc "Find snippet for mode"  :n  "s" #'yas-visit-snippet-file
          :desc "Find snippet"           :n  "S" #'+default/find-in-snippets)

        (:desc "toggle" :prefix "t"
          :desc "Company"                :n "c" #'company-mode
          :desc "Frame fullscreen"       :n "f" #'toggle-frame-fullscreen
          :desc "Frame maximized"        :n "m" #'toggle-frame-maximized
          :desc "Impatient mode"         :n "P" #'+impatient-mode/toggle
          :desc "Flycheck mode global"   :n "Y" #'global-flycheck-mode
          :desc "Flycheck mode"          :n "y" #'flycheck-mode))

      ;; --- Personal vim-esque bindings ------------------
      :m  "gh" #'+lookup/documentation

      ;; ivy
      (:after ivy
        :map ivy-minibuffer-map
        "TAB"  #'ivy-alt-done
        "C-y" #'evil-paste-after
        "C-/" #'undo
        "C-A-k"  #'ivy-scroll-down-command
        "C-A-j"  #'ivy-scroll-up-command
        "s-j" #'ivy-avy
        "C-h" #'ivy-backward-kill-word
        "C-u" #'ivy-kill-line
        "C-b" #'backward-char
        "M-b" #'backward-word
        "C-f" #'forward-char
        "M-f" #'forward-word
        )

      ;; neotree
      (:after neotree
        :map neotree-mode-map
        :n "C-M-v"     #'scroll-other-window
        :n "C-M-S-v"   #'scroll-other-window-down)

      (:after debug
        ;; For elisp debugging
        :map debugger-mode-map
        :n "RET" #'debug-help-follow
        :n "e"   #'debugger-eval-expression
        :n "n"   #'debugger-step-through
        :n "c"   #'debugger-continue)
     )

(map!
 (:after smartparens
   "C-c m j"   #'sp-down-sexp
   "C-c m k"   #'sp-backward-up-sexp
   "C-c m h"   #'sp-backward-down-sexp
   "C-c m l"   #'sp-up-sexp
   "C-c m f"   #'sp-forward-sexp
   "C-c m b"   #'sp-backward-sexp
   "C-c m a"   #'sp-beginning-of-sexp
   "C-c m e"   #'sp-end-of-sexp
   "C-c m n"   #'sp-next-sexp
   "C-c m p"   #'sp-previous-sexp
   "C-c m >"   #'sp-forward-barf-sexp
   "C-c m <"   #'sp-backward-barf-sexp
   "C-c m )"   #'sp-forward-slurp-sexp
   "C-c m ("   #'sp-backward-slurp-sexp
   "C-c m x"   #'sp-transpose-sexp
   "C-c m d"   #'sp-kill-sexp
   "C-c m y"   #'sp-copy-sexp
   "C-c m u"   #'sp-unwrap-sexp
   "C-c m U"   #'sp-backward-unwrap-sexp
   "C-c m C"   #'sp-convolute-sexp
   "C-c m r"   #'sp-raise-sexp
   "C-c m s"   #'sp-split-sexp
   "C-c m S"   #'sp-splice-sexp
   "C-c m F"   #'sp-splice-sexp-killing-forward
   "C-c m B"   #'sp-splice-sexp-killing-backward
   "C-c m A"   #'sp-splice-sexp-killing-around
   )
 )

;; TODO: add some replace
(after! which-key

  (push '(
          ("SPC TAB 1" . nil) .
          ("1..9" . "Switch to 1..9 workspace")) which-key-replacement-alist)

  (which-key-add-key-based-replacements
    "C-c m" "smartparent"
    "SPC o k" "Clock")
  )

;; buffer
(do-repeat! previous-buffer next-buffer previous-buffer)
(do-repeat! next-buffer next-buffer previous-buffer)
;; workspace
(after! persp
  (do-repeat! +workspace/switch-left +workspace/switch-left +workspace/switch-right)
  (do-repeat! +workspace/switch-right +workspace/switch-left +workspace/switch-right))

;; git-gutter
(after! git-gutter
  (do-repeat! git-gutter:next-hunk git-gutter:next-hunk git-gutter:previous-hunk)
  (do-repeat! git-gutter:previous-hunk git-gutter:next-hunk git-gutter:previous-hunk))

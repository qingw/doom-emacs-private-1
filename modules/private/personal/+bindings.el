;;; private/+bindings.el -*- lexical-binding: t; -*-

;;
(map! :gnvime "M-;" #'evil-commentary-line
      :gnvime "M-:" #'eval-expression
      :gnvime "s-:" #'doom/open-scratch-buffer
      :gnvime "s-;" #'evil-ex

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
      :nv "C-SPC"     #'+evil:fold-toggle

      :gnvime "M-g"   #'goto/body

      :nie "C-S-u" #'doom/backward-kill-to-bol-and-indent
      :nie "C-u"   #'kill-line

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
          :desc "counsel-rg"            :nv "s" #'counsel-rg
          :desc "Swiper"                :nv "/" #'swiper
          :desc "Imenu"                 :nv "i" #'imenu
          :desc "Imenu across buffers"  :nv "I" #'imenu-anywhere
          :desc "jump back"             :nv "b" #'avy-pop-mark
          :desc "show marks"            :nv "m" #'evil-show-marks
          :desc "show registers"        :nv "r" #'evil-show-registers
          :desc "Online providers"      :nv "o" #'+lookup/online-select)

        (:desc "workspace" :prefix "TAB"
          :desc "Display tab bar"          :n "TAB" #'+workspace/display
          :desc "New workspace"            :n "n"   #'+workspace/new
          :desc "Load workspace from file" :n "l"   #'+workspace/load
          :desc "Load last session"        :n "L"   (λ! (+workspace/load-session))
          :desc "Save workspace to file"   :n "s"   #'+workspace/save
          :desc "Autosave current session" :n "S"   #'+workspace/save-session
          :desc "Switch workspace"         :n "."   #'+workspace/switch-to
          :desc "Kill all buffers"         :n "x"   #'doom/kill-all-buffers
          :desc "Delete session"           :n "X"   #'+workspace/kill-session
          :desc "Delete this workspace"    :n "d"   #'+workspace/delete
          :desc "Load session"             :n "L"   #'+workspace/load-session
          :desc "Next workspace"           :n "]"   #'+workspace/switch-right
          :desc "Previous workspace"       :n "["   #'+workspace/switch-left
          :desc "Switch to 1st workspace"  :n "1"   (λ! (+workspace/switch-to 0))
          :desc "Switch to 2nd workspace"  :n "2"   (λ! (+workspace/switch-to 1))
          :desc "Switch to 3rd workspace"  :n "3"   (λ! (+workspace/switch-to 2))
          :desc "Switch to 4th workspace"  :n "4"   (λ! (+workspace/switch-to 3))
          :desc "Switch to 5th workspace"  :n "5"   (λ! (+workspace/switch-to 4))
          :desc "Switch to 6th workspace"  :n "6"   (λ! (+workspace/switch-to 5))
          :desc "Switch to 7th workspace"  :n "7"   (λ! (+workspace/switch-to 6))
          :desc "Switch to 8th workspace"  :n "8"   (λ! (+workspace/switch-to 7))
          :desc "Switch to 9th workspace"  :n "9"   (λ! (+workspace/switch-to 8))
          :desc "Switch to last workspace" :n "0"   #'+workspace/switch-to-last)

        (:desc "buffer" :prefix "b"
          :desc "New empty buffer"        :n "n" #'evil-buffer-new
          :desc "Switch workspace buffer" :n "b" #'persp-switch-to-buffer
          :desc "Switch buffer"           :n "B" #'switch-to-buffer
          :desc "Kill buffer"             :n "k" #'kill-this-buffer
          :desc "Kill other buffers"      :n "o" #'doom/kill-other-buffers
          :desc "Save buffer"             :n "s" #'save-buffer
          :desc "Revert buffer"           :n "r" #'revert-buffer
          :desc "VC Revert buffer"        :n "R" #'vc-revert-buffer
          :desc "Pop scratch buffer"      :n "x" #'doom/open-scratch-buffer
          :desc "Bury buffer"             :n "z" #'bury-buffer
          :desc "Next buffer"             :n "]" #'next-buffer
          :desc "Previous buffer"         :n "[" #'previous-buffer
          :desc "Doom dashboard"          :n "h" #'+doom-dashboard/open
          :desc "Switch to *Messages*"    :n "M" (λ! (switch-to-buffer "*Messages*"))
          :desc "Switch to *scrach*"      :n "X" (λ! (switch-to-buffer "*scratch*"))
          :desc "Sudo edit this file"     :n "S" #'doom/sudo-this-file)

        (:desc "code" :prefix "c"
          :desc "List errors"               :n  "x" #'flycheck-list-errors
          :desc "Evaluate buffer/region"    :n  "e" #'+eval/buffer
                                            :v  "e" #'+eval/region
          :desc "Evaluate & replace region" :nv "E" #'+eval:replace-region
          :desc "Build tasks"               :nv "b" #'+eval/build
          :desc "Jump to definition"        :n  "d" #'+lookup/definition
          :desc "Jump to references"        :n  "D" #'+lookup/references
          :desc "Open REPL"                 :n  "r" #'+eval/open-repl
                                            :v  "r" #'+eval:repl)

        (:desc "file" :prefix "f"
          :desc "Find file"                 :n "." #'find-file
          :desc "Counsel file fzf"          :n "/" #'counsel-fzf
          :desc "Sudo find file"            :n "s" #'doom/sudo-find-file
          :desc "Find file in project"      :n "f" #'projectile-find-file
          :desc "Find file from here"       :n "?" #'counsel-file-jump
          :desc "Find other file"           :n "a" #'projectile-find-other-file
          :desc "Open project editorconfig" :n "c" #'editorconfig-find-current-editorconfig
          :desc "Find directory"            :n "d" #'dired
          :desc "Find file in emacs.d"      :n "e" #'+default/find-in-emacsd
          :desc "Browse emacs.d"            :n "E" #'+default/browse-emacsd
          :desc "Recent files"              :n "r" #'recentf-open-files
          :desc "Recent project files"      :n "R" #'projectile-recentf
          :desc "Find file on TRAMP"        :n "t" #'counsel-tramp
          :desc "Yank filename"             :n "y" #'+default/yank-buffer-filename
          (:when (featurep! :config private)
            :desc "Find file in private config" :n "p" #'+private/find-in-config
            :desc "Browse private config"       :n "P" #'+private/browse-config))

        (:desc "git" :prefix "g"
          :desc "Git status"            :n  "g" #'magit-status
          :desc "Git Hydra"             :n  "." #'+version-control@git-gutter/body
          :desc "List gists"            :n  "l" #'+gist:list)

        (:desc "help" :prefix "h"
          :desc "Help map"              :n  "h" help-map
          :desc "Apropos"               :n  "a" #'apropos
          :desc "Reload theme"          :n  "R" #'doom//reload-theme
          :desc "Find library"          :n  "l" #'find-library
          :desc "Toggle Emacs log"      :n  "m" #'view-echo-area-messages
          :desc "Command log"           :n  "L" #'global-command-log-mode
          :desc "Describe function"     :n  "f" #'describe-function
          :desc "Find function"         :n  "j" #'find-function
          :desc "Describe key"          :n  "k" #'describe-key
          :desc "Which key top level"   :n  "b" #'which-key-show-top-level
          :desc "Which key major mode"  :n  "B" #'which-key-show-major-mode
          :desc "Which key mino mode"   :n  "C-b" #'which-key-show-minor-mode-keymap
          :desc "Describe keybriefly"   :n  "c" #'describe-key-briefly
          :desc "Describe char"         :n  "C" #'describe-char
          :desc "Describe mode"         :n  "M" #'describe-mode
          :desc "Describe variable"     :n  "v" #'describe-variable
          :desc "Describe face"         :n  "F" #'describe-face
          :desc "Describe DOOM setting" :n  "s" #'doom/describe-setting
          :desc "Describe DOOM module"  :n  "d" #'doom/describe-module
          :desc "Open Doom manual"      :n  "D" #'doom/help
          :desc "Find definition"       :n  "." #'+lookup/definition
          :desc "Find references"       :n  "/" #'+lookup/references
          :desc "Find documentation"    :n  "," #'+lookup/documentation
          :desc "Describe at point"     :n  "." #'helpful-at-point
          :desc "What face"             :n  "'" #'doom/what-face
          :desc "What minor modes"      :n  ";" #'doom/what-minor-mode
          :desc "Info"                  :n  "i" #'info
          :desc "Toggle profiler"       :n  "p" #'doom/toggle-profiler)

        (:desc "insert" :prefix "i"
          :desc "From kill-ring"        :nv "y" #'counsel-yank-pop
          :desc "From evil registers"   :nv "r" #'counsel-evil-registers
          :desc "From snippet"          :nv "s" #'yas-insert-snippet)

        (:desc "notes" :prefix "n"
          :desc "Find file in notes"    :n  "n" #'+default/find-in-notes
          :desc "Browse notes"          :n  "N" #'+default/browse-notes
          :desc "Org capture"           :n  "x" #'org-capture
          :desc "Browse mode notes"     :n  "m" #'+org/browse-notes-for-major-mode
          :desc "Browse project notes"  :n  "p" #'+org/browse-notes-for-project)

        (:desc "open" :prefix "a"
          :desc "Default browser"       :n  "b" #'browse-url-of-file
          :desc "Debugger"              :n  "d" #'+debug/open
          :desc "REPL"                  :n  "r" #'+eval/open-repl
                                        :v  "r" #'+eval:repl
          :desc "Neotree"               :n  "n" #'+neotree/open
          :desc "Neotree: on this file" :n  "N" #'+neotree/find-this-file
          :desc "Imenu sidebar"         :nv "i" #'imenu-list-minor-mode
          :desc "Terminal"              :n  "t" #'+term/open-popup
          :desc "Terminal in project"   :n  "T" #'+term/open-popup-in-project

          ;; applications
          :desc "APP: elfeed"           :n "E" #'=rss
          :desc "APP: email"            :n "M" #'=email
          :desc "APP: twitter"          :n "T" #'=twitter
          :desc "APP: regex"            :n "X" #'=regex

          :desc "Eshell"               :n "s" #'+eshell/open-popup
          :desc "Calendar"             :n "c" #'=calendar

          ;; macos
          (:when IS-MAC
            :desc "Reveal in Finder"          :n "o" #'+macos/reveal-in-finder
            :desc "Reveal project in Finder"  :n "O" #'+macos/reveal-project-in-finder
            :desc "Send to Transmit"          :n "u" #'+macos/send-to-transmit
            :desc "Send project to Transmit"  :n "U" #'+macos/send-project-to-transmit
            :desc "Send to Launchbar"         :n "l" #'+macos/send-to-launchbar
            :desc "Send project to Launchbar" :n "L" #'+macos/send-project-to-launchbar))

        (:desc "project" :prefix "p"
          :desc "Browse project"          :n  "." #'+default/browse-project
          :desc "Search project with ag"  :n  "s" #'counsel-projectile-ag
          :desc "Find file in project"    :n  "f" #'projectile-find-file
          :desc "Projectile kill buffers" :n  "k" #'projectile-kill-buffers
          :desc "Run cmd in project root" :nv "!" #'projectile-run-shell-command-in-root
          :desc "Compile project"         :n  "c" #'projectile-compile-project
          :desc "Find other file"         :n  "o" #'projectile-find-other-file
          :desc "Switch project"          :n  "p" #'projectile-switch-project
          :desc "Recent project files"    :n  "r" #'projectile-recentf
          :desc "List project tasks"      :n  "t" #'+ivy/tasks
          :desc "Pop term in project"     :n  "o" #'+term/open-popup-in-project
          :desc "Invalidate cache"        :n  "x" #'projectile-invalidate-cache)

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
      :m  "gs" #'+default/easymotion

      (:after company
        (:map company-active-map
          ;; Don't interfere with `evil-delete-backward-word' in insert mode
          "C-w"        nil
          "C-o"        #'company-search-kill-others
          "C-n"        #'company-select-next
          "C-p"        #'company-select-previous
          "C-h"        #'company-quickhelp-manual-begin
          "C-S-h"      #'company-show-doc-buffer
          "C-S-s"      #'company-search-candidates
          "C-s"        #'company-filter-candidates
          "C-c"        #'company-complete-common
          "C-h"        #'company-quickhelp-manual-begin
          "TAB"     #'company-complete-common-or-cycle
          [tab]        #'company-complete-common-or-cycle
          "S-TAB"   #'company-select-previous
          [backtab] #'company-select-previous)
        ;; Automatically applies to `company-filter-map'
        (:map company-search-map
          "C-n"     #'company-select-next-or-abort
          "C-p"     #'company-select-previous-or-abort
          "C-s"        (λ! (company-search-abort) (company-filter-candidates))
          [escape]     #'company-search-abort))


      ;; ivy
      (:after ivy
        :map ivy-minibuffer-map
        [escape] #'keyboard-escape-quit
        "C-TAB" #'ivy-call-and-recenter
        "TAB"  #'ivy-alt-done
        "C-y" #'evil-paste-after
        "C-/" #'undo
        "C-r" #'evil-paste-from-register
        "C-k" #'ivy-previous-line
        "C-j" #'ivy-next-line
        "C-A-k"  #'ivy-scroll-down-command
        "C-A-j"  #'ivy-scroll-up-command
        "s-j" #'ivy-avy
       "C-l" #'ivy-alt-done
        "C-w" #'ivy-backward-kill-word
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

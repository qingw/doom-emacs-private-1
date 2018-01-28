;;; +bindings.el -*- lexical-binding: t; -*-


(setq doom-localleader-key ",")
;; * Keybindings
(map!
      "C-M-h"         #'previous-multiframe-window
      "C-M-l"         #'next-multiframe-window
	  "s-<return>"    #'doom/toggle-fullscreen
	  "s-i"           #'ivy-resume
	  "s-m"           #'doom/window-zoom

	  "s-t"           #'+neotree/toggle
	  "s-/"           #'counsel-imenu
	  "s-?"           #'ivy-imenu-anywhereare
      "s-l"           #'avy-goto-line
      "s-h"           #'avy-goto-word-1

	  :gnvime "M-;" #'evil-commentary-line

      :gnvime "s-r" #'counsel-org-capture
      :gnvime "s-g" #'org-agenda-show-daily
      ;; :gnvime "M-s" #'org-store-link
      ;; :gnvime "M-o" #'org-open-at-point-global
      ;; :gnvime "M-i" #'org-insert-last-stored-link
      ;; :gnvime "s-j" #'dwim-jump
      :gnvime "<C-escape>" #'universal-argument
      :m "C-u" #'evil-scroll-up
      (:map universal-argument-map
        "C-u" nil
        "<C-escape>" #'universal-argumnt-more)
;; *** Misc
      :n    "\\"    #'ace-window
      :n    "/"     #'swiper
      :v    "<escape>"    #'evil-escape
      :gnvime "<f2>" #'+lookup/documentation
;; *** A little sandbox to run code in
      :gnvime "s-;" #'eval-expression
      :gnvime "s-:" #'doom/open-scratch-buffer

 (:leader

   ;; *** Most commonly used
   :desc "Find file in project"    :n "SPC" #'execute-extended-command
   ;; :desc "Find project files"      :n "/"   #'counsel-projectile-find-file
   ;; :desc "Eval expression"         :n ":"   #'eval-expression

;; buffer
   (:prefix "b"
	 :desc "Dashboard"            :n "h" #'+doom-dashboard/open
	 :desc "Swith to scratch buffer" :n "e" (λ! (switch-to-buffer (get-buffer-create "*scratch*")))
	 )

;; search
   (:prefix "/"
	 :desc "counsel-ag"            :nv "r" #'counsel-ag
	 )

;; project
   (:prefix "p"
	 :desc "Search project with rg"  :n "/" #'counsel-projectile-rg
	 :desc "Find file in project"    :n "f" #'counsel-projectile-find-file
	 :desc "Projectile kill buffers" :n "k" #'projectile-kill-buffers
	 )

;; git
;;
   (:prefix "g"
	 :desc "Git status"            :n  "g" #'magit-status
	 :desc "Git Hydra"             :n  "." #'+version-control@git-gutter/body
	 :desc "List gists"            :n  "l" #'+gist:list
	 )

;; *** toggle
   (:prefix "t"
	 :desc "Company"                :n "c" #'company-mode
	 :desc "Truncate Lines"         :n "w" #'toggle-truncate-lines
	 :desc "Highlight Lines"        :n "H" #'hl-line-mode
	 :desc "Visual Lines"           :n "v" #'visual-line-mode
	 :desc "Flycheck mode global"   :n "Y" #'global-flycheck-mode
	 :desc "Flycheck mode"          :n "y" #'flycheck-mode)

   ))


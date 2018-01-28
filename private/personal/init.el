;;; init.el -*- lexical-binding: t; -*-

(cond (IS-MAC
       (setq mac-command-modifier 'super
             mac-option-modifier  'meta))
	  (IS-LINUX
	   (setq x-super-keysym 'super
			 x-alt-keysym   'meta)
	  ))

;; Prevents the unstyled mode-line flash at startup
(setq-default mode-line-format nil)

;; I've swapped these keys on my keyboard
(setq user-mail-address "drfitcrow@gmail.com"
      user-full-name    "driftcrow"

      doom-font (font-spec :family "Input Mono Narrow" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans")
      doom-unicode-font (font-spec :family "Input Mono Narrow" :size 12)
      doom-big-font (font-spec :family "Fira Mono" :size 19)

      org-ellipsis " ▼ ")

(add-hook! doom-big-font-mode
  (setq +doom-modeline-height (if doom-big-font-mode 37 29)))
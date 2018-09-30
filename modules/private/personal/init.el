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
(setq user-mail-address "driftcrow@gmail.com"
      user-full-name    "driftcrow"

      evil-want-integration t

      doom-localleader-key ","

      doom-font (font-spec :family "Fira Code" :size 14 )
      ;; doom-font (font-spec :family "Source Code Pro" :size 14 )
      ;; doom-variable-pitch-font (font-spec :family "Fira Sans")
      doom-unicode-font (font-spec :family "Source Code Pro" :size 14)
      doom-big-font (font-spec :family "Fira Mono" :size 18)

      frame-resize-pixelwise t
      )

(add-hook! doom-big-font-mode
  (setq +doom-modeline-height (if doom-big-font-mode 37 29)))

;; (setq
 ;; epa-file-encrypt-to user-mail-address
      ;; auth-sources (list (expand-file-name ".authinfo.gpg" "~")))

;; ;; Auto generated by cnfonts
;; ;; <https://github.com/tumashu/cnfonts>
;; (set-face-attribute
;;  'default nil
;;  :font (font-spec :name "-1ASC-Droid Sans Mono-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1"
;;                   :weight 'normal
;;                   :slant 'normal
;;                   :size 12.5))
;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;   (set-fontset-font
;;    (frame-parameter nil 'font)
;;    charset
;;    (font-spec :name "-WQYF-文泉驿等宽微米黑-normal-normal-normal-*-*-*-*-*-*-0-iso10646-1"
;;               :weight 'normal
;;               :slant 'normal
;;               :size 15.0)))



(setq-default explicit-shell-file-name (executable-find "bash"))
(setq-default shell-file-name (executable-find "bash"))


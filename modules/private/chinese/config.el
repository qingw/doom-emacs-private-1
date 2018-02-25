;; ;;; config.el -*- lexical-binding: t; -*-

(def-package! fcitx
  :config
  ;; Make sure the following comes before `(fcitx-aggressive-setup)'
  ;; (fcitx-evil-turn-off)                                  ; turn on in chinese
  (setq fcitx-active-evil-states '(insert emacs))
  (fcitx-prefix-keys-add "M-m" "C-M-m") ; M-m is common in Spacemacs
  (fcitx-prefix-keys-add "C-x" "C-c" "C-h" "M-s" "M-o")
  ;; (fcitx-prefix-keys-turn-on)
  ;; (fcitx-default-setup)
  (fcitx-aggressive-setup)
  ;; (setq fcitx-use-dbus t) ; uncomment if you're using Linux
  )


(def-package! youdao-dictionary
  ;; :disabled
  :commands youdao-dictionary-search-at-point+
  :bind ("s-y" . youdao-dictionary-search-at-point+)
  :init
  (progn
    ;; Enable Cache
    (setq
     ;; conflic with magithub
     ;; url-automatic-caching t

     ;; Set file path for saving search history
     youdao-dictionary-search-history-file
     (concat doom-cache-dir ".youdao")
     ;; Enable Chinese word segmentation support
     youdao-dictionary-use-chinese-word-segmentation t))
  )


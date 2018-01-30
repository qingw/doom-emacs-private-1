;;; config.el -*- lexical-binding: t; -*-

(def-package! org-brain
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
  (setq org-brain-visualize-default-choices 'all
        org-brain-title-max-length 30)
  (set! :popup "^\\*org-brain\\*$" '((vslot . -1) (size . 0.3) (side . left)) '((select . t) (quit) (transient)))

  (map!
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
     :n "g" 'revert-buffer
     :n "_" 'org-brain-new-child
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
     :n "s" 'org-brain-visualize
     :n "S" 'org-brain-goto
     :n [tab] 'org-brain-goto-current
     )))

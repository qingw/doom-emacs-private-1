;;; packages.el -*- lexical-binding: t; -*-

;; (package! centered-window-mode :ignore t)

(package! orgit)
(package! evil-magit)
(package! magithub)

(package! keyfreq)

(package! graphviz-dot-mode)
(package! whitespace-cleanup-mode)

(package! atomic-chrome)

;; for python lang
(package! lsp-python)
(package! py-isort)
(package! pipenv)
(package! yapfify :recipe (:fetcher github :repo "JorisE/yapfify"))

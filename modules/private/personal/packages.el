;;; packages.el -*- lexical-binding: t; -*-

;; (package! centered-window-mode :ignore t)

(package! orgit)
(package! evil-magit)
(package! magithub)

(package! keyfreq)

(package! graphviz-dot-mode)
(package! whitespace-cleanup-mode)

(package! atomic-chrome)

(package! prog-fill)

;; for python lang
(package! lsp-python)
(package! py-isort)
(package! pipenv)
(package! yapfify :recipe (:fetcher github :repo "JorisE/yapfify"))

(package! counsel-tramp)
(package! docker-tramp)

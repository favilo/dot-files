;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

(package! move-text)
(package! fzf-spacemacs-layer
  :recipe
  (:fetcher github :repo "AshyIsMe/fzf-spacemacs-layer")
  )
(package! godot-gdscript
  :recipe
  (:fetcher github
            :repo "francogarcia/godot-gdscript.el"
            )
  )
(package! toml-mode)

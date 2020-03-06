;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

(package! move-text)
(package! fzf-spacemacs-layer
  :recipe
  (:host github :repo "AshyIsMe/fzf-spacemacs-layer")
  )
(package! godot-gdscript
  :recipe
  (:host github :repo "francogarcia/godot-gdscript.el")
  )
(package! websocket)
(package! circe)
(package! circe-notifications)
(package! request)
;; (package! emacs-slack
;;   :recipe
;;   (:host github :repo "yuya373/emacs-slack")
;;   )
;; (package! helm-slack
;;   :recipe
;;   (:host github :repo "yuya373/helm-slack")
;;   )
(package! toml-mode)
(package! realgud)

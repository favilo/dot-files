;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-j") 'windmove-down)
(global-set-key (kbd "C-k") 'windmove-up)
(global-set-key (kbd "C-l") 'windmove-right)
(map! :leader
      (:prefix "f"
        :n "f" #'counsel-fzf
        )
      )

(require 'godot-gdscript)
(add-to-list 'auto-mode-alist '("\\.tscn\\'" . toml-mode))
(setq gdscript-tabs-mode t)

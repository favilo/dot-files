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
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(setq gdscript-tabs-mode t)

(def-package! realgud
  :commands realgud:pdb)

;; (def-package! emacs-slack
;;   :commands (slack-start)
;;   :init
;;   (setq slack-buffer-emojify t) ;; if you want to enable emoji, default nil
;;   (setq slack-prefer-current-team t)
;;   :config
;;   (slack-register-team
;;      :name "oberliesslack"
;;      :default t
;;      :token (auth-source-pick-first-password
;;          :host "oberliesslack.slack.com"
;;          :user "favilo@gmail.com")
;;      :subscribed-channels '(general programming family)
;;      :full-and-display-names t
;;      )
;;   )

;; (def-package! helm-slack
;;   :after (slack)
;;   )
(def-package! alert
  :commands (alert)
  :init
  (setq alert-default-style 'notifier)
  )

(require 'floobits)
;; (set-formatter! 'black \"black -S -q -\")
(setq lsp-python-ms-executable
      "~/git/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")

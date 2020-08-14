;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-j") 'windmove-down)
(global-set-key (kbd "C-k") 'windmove-up)
(global-set-key (kbd "C-l") 'windmove-right)

(map! :leader
      "ff" #'counsel-fzf
      )

;; (map! :leader
;;       "c l e" #'lsp-extend-selection
;;       )

(require 'godot-gdscript)
(add-to-list 'auto-mode-alist '("\\.tscn\\'" . toml-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(setq gdscript-tabs-mode t)

(use-package! realgud
  :commands realgud:pdb)

(setq auth-source-debug t)
(use-package! slack
  :commands (slack-start)
  :init
  (setq slack-buffer-emojify t) ;; if you want to enable emoji, default nil
  (setq slack-prefer-current-team t)
  :config
  (slack-register-team
   :name "oberliesslack"
   :default t
   :token (auth-source-pick-first-password
           :host '("oberliesslack")
           :user "token" :type 'netrc :max 1)
   :subscribed-channels '(general programming family)
   :full-and-display-names t
   )
  )

(use-package! helm-slack
  :after emacs-slack)

;; (use-package! helm-slack
;;   :after (slack)
;;   )
(use-package! alert
  :commands (alert)
  :init
  (setq alert-default-style 'notifier)
  )

;; (set-formatter! 'black \"black -S -q -\")
(setq lsp-python-ms-executable
      "~/git/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")

(setq x-select-enable-clipboard nil)
(setq display-line-numbers-type 'relative)

(after! lsp-haskell
  (setq lsp-haskell-process-path-hie "ghcide")
  (setq lsp-haskell-process-args-hie '()))

(setq doom-theme 'doom-molokai)
(setq lsp-rust-server 'rust-analyzer)
(setq rustic-lsp-server 'rust-analyzer)

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;;; Code:

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Kevin Oberlies"
      user-mail-address "favilo@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-monokai-classic)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq org-roam-directory "~/notes/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq select-enable-clipboard nil)

(after! rustic
  (setq lsp-rust-server 'rust-analyzer))
(after! rustic
  (setq rustic-lsp-server 'rust-analyzer))
(after! eglot
  :config
  (set-eglot-client! 'python-mode '("pylsp"))
  ;; TODO set others?
  ;; (set-eglot-client! 'python-mode '("pylsp"))
  )

(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-j") 'windmove-down)
(global-set-key (kbd "C-k") 'windmove-up)
(global-set-key (kbd "C-l") 'windmove-right)

;; (map! :leader
;;       "ff" #'counsel-fzf
;;       )
;; (setq counsel-fzf-cmd "fzf -f \"%s\"")
;; (map! :leader
;;       "c l e" #'lsp-extend-selection
;;       )
(map! :leader
      "c d" #'lsp-find-definition
      )

;; Enable terminal copy to cliboard
(defun copy-to-clipboard ()
  "Copies selection to x-clipboard."
  (interactive)
  (if (display-graphic-p)
      (progn
        (message "Yanked region to x-clipboard!")
        (call-interactively 'clipboard-kill-ring-save)
        )
    (if (region-active-p)
        (progn
          (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
          (message "Yanked region to clipboard!")
          (deactivate-mark))
      (message "No region active; can't yank to clipboard!"))))

(defun paste-from-clipboard ()
  "Pastes from x-clipboard."
  (interactive)
  (if (display-graphic-p)
      (progn
        (clipboard-yank)
        (message "graphics active")
        )
    (insert (shell-command-to-string "xsel -o -b"))))
(map! :leader "oy" 'copy-to-clipboard)
(map! :leader "op" 'paste-from-clipboard)

(require 'godot-gdscript)
(add-to-list 'auto-mode-alist '("\\.tscn\\'" . toml-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(setq gdscript-tabs-mode t)

(use-package! realgud
  :commands realgud:pdb)

(use-package! fzf
  :commands (spacemacs/fzf-find-files
             spacemacs/fzf-recentf
             spacemacs/fzf-buffers)
  :init
  (map! :leader
        ;; get rid of conflicting keybinds first
        "of" nil
        "ob" nil
        "off" #'spacemacs/fzf-find-files
        "ofr" #'spacemacs/fzf-recentf
        "obb" #'spacemacs/fzf-buffers))

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

;; (use-package! helm-slack
;;   :after emacs-slack)

;; (use-package! helm-slack
;;   :after (slack)
;;   )
(use-package! alert
  :commands (alert)
  :init
  (setq alert-default-style 'notifier)
  )

(after! dap-mode
  (setq dap-python-debugger 'debugpy))

(map! :map dap-mode-map
      :leader
      :prefix ("d" . "dap")
      ;; basics
      :desc "dap next"          "n" #'dap-next
      :desc "dap step in"       "i" #'dap-step-in
      :desc "dap step out"      "o" #'dap-step-out
      :desc "dap continue"      "c" #'dap-continue
      :desc "dap hydra"         "h" #'dap-hydra
      :desc "dap debug restart" "r" #'dap-debug-restart
      :desc "dap debug"         "s" #'dap-debug

      ;; debug
      :prefix ("dd" . "Debug")
      :desc "dap debug recent"  "r" #'dap-debug-recent
      :desc "dap debug last"    "l" #'dap-debug-last

      ;; eval
      :prefix ("de" . "Eval")
      :desc "eval"                "e" #'dap-eval
      :desc "eval region"         "r" #'dap-eval-region
      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
      :desc "add expression"      "a" #'dap-ui-expressions-add
      :desc "remove expression"   "d" #'dap-ui-expressions-remove

      :prefix ("db" . "Breakpoint")
      :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)

;; (defun my-tab ()
;;   (interactive)
;;   (or (copilot-accept-completion)
;;       (company-indent-or-complete-common nil)))

;; (use-package! copilot
;;   :hook (prog-mode . copilot-mode)
;;   :bind (("C-TAB" . 'copilot-accept-completion-by-word)
;;          ("C-<tab>" . 'copilot-accept-completion-by-word)
;;          ;; :map company-active-map
;;          ;; ("<tab>" . 'my-tab)
;;          ;; ("TAB" . 'my-tab)
;;          :map company-mode-map
;;          ("<tab>" . 'my-tab)
;;          ("TAB" . 'my-tab)
;;          )
;;   )

(with-eval-after-load 'company
                                        ; disable inline previews
  (delq 'company-preview-if-just-one-frontend company-frontends)

                                        ; enable tab completion
  ;; (define-key company-mode-map (kbd "<tab>") 'my-tab)
  ;; (define-key company-mode-map (kbd "TAB") 'my-tab)
  ;; (define-key company-active-map (kbd "<tab>") 'my-tab)
  ;; (define-key company-active-map (kbd "TAB") 'my-tab)
  ;; (define-key company-mode-map (kbd "C-<tab>") 'copilot-next-completion)
  ;; (define-key company-mode-map (kbd "C-TAB") 'copilot-next-completion)
  ;; (define-key company-active-map (kbd "C-<tab>") 'copilot-next-completion)
  ;; (define-key company-active-map (kbd "C-TAB") 'copilot-next-completion)
  ;; (define-key company-mode-map (kbd "C-S-<tab>") 'copilot-previous-completion)
  ;; (define-key company-mode-map (kbd "C-S-TAB") 'copilot-previous-completion)
  ;; (define-key company-active-map (kbd "C-S-<tab>") 'copilot-previous-completion)
  ;; (define-key company-active-map (kbd "C-S-TAB") 'copilot-previous-completion)
  )


;; (use-package! wakatime-mode
;;   :ensure t)

;; (global-wakatime-mode)

;; Doesn't work
;; (after! format
;;   (set-formatter! 'black \"black -S -q -\" :modes `(python-mode))
;;   )

;; (when (featurep 'pgtk)
;;   (add-hook 'after-focus-change-function
;;             (lambda ()
;;               (if (window-system (selected-frame))
;;                   (setq mouse-wheel-down-event 'mouse-4
;; 			mouse-wheel-up-event 'mouse-5)
;;                 (setq mouse-wheel-down-event 'wheel-up
;;                       mouse-wheel-up-event 'wheel-down)
;;                 )
;;               )
;;             )
;;   )

(unless window-system
  (defun track-mouse (e))
  (xterm-mouse-mode 1)
  ;; (global-set-key (kbd "<mouse-4>") 'pel-scroll-down)
  ;; (global-set-key (kbd "<mouse-5>") 'pel-scroll-up)
  (cond (IS-MAC
         ;; (global-set-key (kbd "<mouse-4>") 'scroll-down-command)
         ;; (global-set-key (kbd "<mouse-5>") 'scroll-up-command)
         (global-set-key (kbd "<mouse-4>") (lambda () (interactive) (scroll-down-command 3)))
         (global-set-key (kbd "<mouse-5>") (lambda () (interactive) (scroll-up-command 3)))
         )
        (IS-LINUX
         (setq mouse-wheel-down-event 'mouse-4)
         (setq mouse-wheel-up-event 'mouse-5)
         (global-set-key (kbd "<mouse-4>") 'mwheel-scroll)
         (global-set-key (kbd "<mouse-5>") 'mwheel-scroll)
         (global-set-key (kbd "<C-mouse-4>") 'mouse-wheel-text-scale)
         (global-set-key (kbd "<C-mouse-5>") 'mouse-wheel-text-scale)
         (global-set-key (kbd "<S-mouse-4>") 'mwheel-scroll)
         (global-set-key (kbd "<S-mouse-5>") 'mwheel-scroll)
         )
        )
  ;; (global-set-key (kbd "<mouse-4>") (kbd "<wheel-up>"))
  ;; (global-set-key (kbd "<mouse-5>") (kbd "<wheel-down>"))
  )

(if (featurep 'ns)
    (progn
      (global-set-key (kbd "<mouse-4>") (kbd "<wheel-up>"))
      (global-set-key (kbd "<mouse-5>") (kbd "<wheel-down>"))))
(global-set-key (kbd "M-[ h") 'beginning-of-line)
(global-set-key (kbd "<select>") 'end-of-line)

(use-package! python-black
  :demand t
  :after python
  :config
  ;; (add-hook! 'python-mode-hook #'python-black-on-save-mode)
  ;; Feel free to throw your own personal keybindings here
  (map! :leader :desc "Blacken Buffer" "m b b" #'python-black-buffer)
  (map! :leader :desc "Blacken Region" "m b r" #'python-black-region)
  (map! :leader :desc "Blacken Statement" "m b s" #'python-black-statement)
  )

(setq load-prefer-newer t)
;; (set-formatter! 'black \"black -S -q -\")

(cond (IS-LINUX
       (setq wl-copy-process nil)
       (defun wl-copy (text)
         (setq wl-copy-process (make-process :name "wl-copy"
                                             :buffer nil
                                             :command '("wl-copy" "-f" "-n")
                                             :connection-type 'pipe))
         (process-send-string wl-copy-process text)
         (process-send-eof wl-copy-process))
       (defun wl-paste ()
         (if (and wl-copy-process (process-live-p wl-copy-process))
             nil ; should return nil if we're the current paste owner
           (shell-command-to-string "wl-paste -n | tr -d \r")))
       (setq interprogram-cut-function 'wl-copy)
       (setq interprogram-paste-function 'wl-paste)
       ))

(map! :leader
      :desc "FuZzilly find File in home"
      "f z f" (cmd!! #'affe-find "~/"))

(map! :leader :desc "FuZzilly find File this Dir"
      "f z d" (cmd!! #'affe-find ))

;; Outlining stuff
;;
;; Requred for outshine
(add-hook 'outline-minor-mode-hook 'outshine-mode)

;; Enables outline-minor-mode for *ALL* programming buffers
(add-hook 'prog-mode-hook 'outline-minor-mode)

;; Narrowing now works within the headline rather than requiring to be on it
(advice-add 'outshine-narrow-to-subtree :before
            (lambda (&rest args) (unless (outline-on-heading-p t)
                                   (outline-previous-visible-heading 1))))

;; (provide 'init)
;;; config.el ends here

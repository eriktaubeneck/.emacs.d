(require 'python)

(setq fci-rule-column 88)

(define-key python-mode-map (kbd "s-<return>") 'python-shell-send-region)
(add-hook 'python-mode-hook 'fci-mode)
(add-hook 'python-mode-hook 'python-isort-on-save-mode)
(add-hook 'python-mode-hook 'ruff-format-on-save-mode)

(set-default-coding-systems 'utf-8)

;; Tree-sitter for better syntax highlighting
;; (requires python tree-sitter grammar: M-x treesit-install-language-grammar RET python)
(when (treesit-available-p)
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
  ;; Carry over hooks to python-ts-mode
  (dolist (hook '(eglot-ensure fci-mode python-isort-on-save-mode
                  ruff-format-on-save-mode flycheck-mode
                  my/set-pyvenv-to-project-venv))
    (add-hook 'python-ts-mode-hook hook)))

;; Eglot with Pyright for real-time diagnostics, navigation, and completions
(use-package eglot
  :hook ((python-mode python-ts-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("pyright-langserver" "--stdio")))

  (setq eglot-autoshutdown t
        eglot-sync-connect nil)

  ;; Pyright in "basic" mode (faster than strict) scoped to open files only.
  ;; mypy --strict via flycheck is the authority for deep type checking.
  (setq-default eglot-workspace-configuration
                '(:python
                  (:analysis
                   (:typeCheckingMode "basic"
                    :diagnosticMode "openFilesOnly"
                    :autoImportCompletions t
                    :useLibraryCodeForTypes t
                    :autoSearchPaths t
                    :diagnosticSeverityOverrides
                    (:reportUnusedImport "warning"
                     :reportMissingImports "error"))))))

;; Flymake — integrates with eglot for real-time LSP diagnostics
(use-package flymake
  :hook ((python-mode python-ts-mode) . flymake-mode)
  :config
  (setq flymake-no-changes-timeout 0.3)
  (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)
  (define-key flymake-mode-map (kbd "C-c ! l") 'flymake-show-diagnostics-buffer))

;; Flycheck for mypy (deep type checking on save)
(use-package flycheck
  :ensure t
  :hook ((python-mode python-ts-mode) . flycheck-mode)
  :config
  (setq flycheck-python-mypy-executable "mypy"
        flycheck-python-mypy-args '("--strict")
        flycheck-flake8-maximum-line-length 88
        flycheck-disabled-checkers '(python-flake8 python-pylint python-pycompile python-pyright))

  ;; Only enable mypy checker
  (setq flycheck-checkers '(python-mypy))

  ;; Navigate errors
  (define-key flycheck-mode-map (kbd "M-n") 'flycheck-next-error)
  (define-key flycheck-mode-map (kbd "M-p") 'flycheck-previous-error)
  (define-key flycheck-mode-map (kbd "C-c ! l") 'flycheck-list-errors))

;; eldoc-box for hover documentation at point
(use-package eldoc-box
  :ensure t
  :hook (eglot-managed-mode . eldoc-box-hover-mode)
  :config
  (setq eldoc-box-max-pixel-width 800
        eldoc-box-max-pixel-height 600
        eldoc-box-position-function #'eldoc-box--default-at-point-position-function
        eldoc-box-clear-with-C-g t)

  (set-face-attribute 'eldoc-box-body nil
                      :inherit 'default)

  ;; Eglot keybindings
  (define-key eglot-mode-map (kbd "C-c h") 'eldoc-box-help-at-point)
  (define-key eglot-mode-map (kbd "C-c H") 'eldoc-box-eglot-help-at-point)

  ;; Go to definition / references
  (define-key eglot-mode-map (kbd "M-.") 'xref-find-definitions)
  (define-key eglot-mode-map (kbd "M-,") 'xref-go-back)
  (define-key eglot-mode-map (kbd "M-?") 'xref-find-references)

  ;; Rename and code actions
  (define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c a") 'eglot-code-actions))

(global-set-key (kbd "<s-mouse-1>") 'xref-find-definitions-at-mouse)

;; imenu — jump to any function/class in the file
(global-set-key (kbd "C-c i") 'imenu)

;; Show current function in modeline
(which-function-mode 1)

;; Company mode for completion
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1
        company-tooltip-align-annotations t
        company-backends '((company-capf :with company-yasnippet))))

;; Projectile
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1))

;; Virtual environment support
(use-package pyvenv
  :ensure t
  :config
  (pyvenv-mode 1))

(defun my/set-pyvenv-to-project-venv ()
  "Automatically activate the project's .venv virtual environment."
  (when (and (fboundp 'projectile-project-root) (projectile-project-root))
    (let ((venv-path (expand-file-name ".venv" (projectile-project-root))))
      (when (file-directory-p venv-path)
        (pyvenv-activate venv-path)
        (when (and (fboundp 'eglot-managed-p) (eglot-managed-p))
          (call-interactively 'eglot-reconnect))
        (message "Activated virtual environment: %s" venv-path)))))

(add-hook 'python-mode-hook 'my/set-pyvenv-to-project-venv)
(add-hook 'projectile-after-switch-project-hook 'my/set-pyvenv-to-project-venv)

(provide 'python-setup)

(require 'python)

(setq fci-rule-column 88)

(define-key python-mode-map (kbd "s-<return>") 'python-shell-send-region)
(add-hook 'python-mode-hook 'fci-mode)
(add-hook 'python-mode-hook 'python-isort-on-save-mode)
(add-hook 'python-mode-hook 'ruff-format-on-save-mode)

(set-default-coding-systems 'utf-8)

;; Eglot with strict Pyright (configured in Emacs only)
(use-package eglot
  :hook (python-mode . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               '(python-mode . ("pyright-langserver" "--stdio")))

  (setq eglot-autoshutdown t
        eglot-sync-connect nil)

  ;; Strict Pyright configuration
  (setq-default eglot-workspace-configuration
                '(:python
                  (:analysis
                   (:typeCheckingMode "strict"
                    :diagnosticMode "workspace"
                    :autoImportCompletions t
                    :useLibraryCodeForTypes t
                    :autoSearchPaths t
                    :strictListInference t
                    :strictDictionaryInference t
                    :strictParameterNoneValue t
                    :diagnosticSeverityOverrides
                    (:reportMissingTypeStubs "none"
                     :reportUnknownParameterType "warning"
                     :reportUnknownArgumentType "warning"
                     :reportUnknownMemberType "none"
                     :reportUnknownVariableType "warning"
                     :reportUntypedFunctionDecorator "warning"
                     :reportUntypedClassDecorator "warning"
                     :reportUntypedBaseClass "error"
                     :reportUnusedVariable "warning"
                     :reportUnusedImport "warning"))))))

;; Flymake (integrates automatically with Eglot)
(use-package flymake
  :hook (python-mode . flymake-mode)
  :config
  (setq flymake-no-changes-timeout 0.3)

  ;; Better key bindings
  (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)
  (define-key flymake-mode-map (kbd "C-c ! l") 'flymake-show-diagnostics-buffer))

;; Flycheck for mypy only
(use-package flycheck
  :ensure t
  :hook (python-mode . flycheck-mode)
  :config
  (setq flycheck-python-mypy-executable "mypy"
        flycheck-python-mypy-args '("--strict")
        flycheck-flake8-maximum-line-length 88
        ;; Disable all checkers except mypy (Pyright handles the rest via Flymake)
        flycheck-disabled-checkers '(python-flake8 python-pylint python-pycompile python-pyright))

  ;; Only enable mypy checker
  (setq flycheck-checkers '(python-mypy)))

;; eldoc-box for beautiful hover documentation
;; eldoc-box for beautiful hover documentation AT POINT
(use-package eldoc-box
  :ensure t
  :hook (eglot-managed-mode . eldoc-box-hover-mode)
  :config
  (setq eldoc-box-max-pixel-width 800
        eldoc-box-max-pixel-height 600
        ;; Show box near the cursor instead of top-right corner
        eldoc-box-position-function #'eldoc-box--default-at-point-position-function
        ;; Clear with C-g
        eldoc-box-clear-with-C-g t)

  ;; Match the font size to your default buffer font
  (set-face-attribute 'eldoc-box-body nil
                      :inherit 'default)  ; Inherit from default face

  (define-key eglot-mode-map (kbd "C-c h") 'eldoc-box-help-at-point)
  (define-key eglot-mode-map (kbd "C-c H") 'eldoc-box-eglot-help-at-point))

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

(add-hook 'python-mode-hook 'projectile-mode)

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

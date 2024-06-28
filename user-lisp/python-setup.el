(require 'python)

(setq fci-rule-column 88)

(define-key python-mode-map (kbd "s-<return>") 'python-shell-send-region)
(add-hook 'python-mode-hook 'fci-mode)
(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'python-mode-hook 'blacken-mode)
(add-hook 'python-mode-hook 'python-isort-on-save-mode)

(set-default-coding-systems 'utf-8)

(setq-default flycheck-flake8-maximum-line-length 88)

(setq jedi:complete-on-dot t) ; Enable autocompletion after a dot
(setq jedi:use-shortcuts t) ; Enable keybindings for Jedi commands

;; Specify the Python interpreter to use (optional)
(if (executable-find "pythonforemacs")
    ;; incase system python is not what I want to use...
    (setq python-shell-interpreter "pythonforemacs")
  (setq python-shell-interpreter "python3"))

;; Hook company-jedi to Python mode
(add-hook 'python-mode-hook
          (lambda ()
            (add-to-list 'company-backends 'company-jedi)))

(setq company-idle-delay 0.1)

(provide 'python-setup)

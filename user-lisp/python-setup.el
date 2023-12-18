(require 'python)

(setq fci-rule-column 88)

(define-key python-mode-map (kbd "s-<return>") 'python-shell-send-region)
(add-hook 'python-mode-hook 'fci-mode)
(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'python-mode-hook 'blacken-mode)

(set-default-coding-systems 'utf-8)

(setq-default flycheck-flake8-maximum-line-length 88)

(setq jedi:complete-on-dot t) ; Enable autocompletion after a dot
(setq jedi:use-shortcuts t) ; Enable keybindings for Jedi commands

;; Specify the Python interpreter to use (optional)
(setq python-shell-interpreter "python3") ; Replace with the path to your desired Python interpreter

;; Hook company-jedi to Python mode
(add-hook 'python-mode-hook
          (lambda ()
            (add-to-list 'company-backends 'company-jedi)))

(setq company-idle-delay 0.1)

(provide 'python-setup)

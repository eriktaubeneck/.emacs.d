(require 'python)

(setq fci-rule-column 80)
(setq-default flycheck-flake8-maximum-line-length 100)

(define-key python-mode-map (kbd "s-<return>") 'python-shell-send-region)
(add-hook 'python-mode-hook 'fci-mode)
(add-hook 'python-mode-hook 'flycheck-mode)

(provide 'python-setup)

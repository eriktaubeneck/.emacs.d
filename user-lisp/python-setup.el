(require 'python)

(setq fci-rule-column 88)

(define-key python-mode-map (kbd "s-<return>") 'python-shell-send-region)
(add-hook 'python-mode-hook 'fci-mode)
(add-hook 'python-mode-hook 'flycheck-mode)

(set-default-coding-systems 'utf-8)

(setq-default flycheck-flake8-maximum-line-length 88)


(provide 'python-setup)

(require 'python)

(setq fci-rule-column 80)

(define-key python-mode-map (kbd "s-<return>") 'python-shell-send-region)
(add-hook 'python-mode-hook 'fci-mode)
(add-hook 'python-mode-hook 'flycheck-mode)

(provide 'python-setup)

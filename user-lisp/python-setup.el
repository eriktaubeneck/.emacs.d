(require 'python)

(setq fci-rule-column 80)

(define-key python-mode-map (kbd "s-<return>") 'python-shell-send-region)
(add-hook 'python-mode-hook (lambda () (interactive) (column-marker-1 80)))
(add-hook 'python-mode-hook 'fci-mode)

(provide 'python-setup)

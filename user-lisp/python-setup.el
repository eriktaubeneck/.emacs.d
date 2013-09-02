(require 'python)

(define-key python-mode-map (kbd "s-<return>") 'python-shell-send-region)

(provide 'python-setup)

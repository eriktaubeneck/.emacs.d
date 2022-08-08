(require 'rust-mode)

(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))

(setq rust-format-on-save t)

(define-key rust-mode-map (kbd "C-c C-c") 'rust-run)

(add-hook 'rust-mode-hoop 'flycheck-mode)

(provide 'rust-setup)

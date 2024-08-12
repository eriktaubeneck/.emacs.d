(require 'rust-mode)

(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))

(setq rust-format-on-save t)

(define-key rust-mode-map (kbd "C-c C-c") 'rust-run)

(add-hook 'rust-mode-hook 'flycheck-mode)

;; lsp-mode bug
(add-to-list 'image-types 'svg)

(require 'lsp-mode)
(setq lsp-rust-all-features t)
(setq lsp-rust-server 'rust-analyzer)
(add-hook 'rust-mode-hook #'lsp)
(setq lsp-log-io t)

(provide 'rust-setup)

(require 'rust-mode)
(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))
(setq rust-format-on-save t)
(define-key rust-mode-map (kbd "C-c C-c") 'rust-run)
;; Adjust flycheck to check only on save
(add-hook 'rust-mode-hook (lambda ()
                            (setq flycheck-check-syntax-automatically '(save mode-enabled))))
;; lsp-mode configuration
(require 'lsp-mode)
(setq lsp-rust-all-features t)
(setq lsp-rust-server 'rust-analyzer)
(setq lsp-diagnostics-provider :flycheck)  ; Use flycheck as the diagnostics provider
(add-hook 'rust-mode-hook #'lsp)
(setq lsp-log-io t)

;; lsp-mode bug fix related to image types
(add-to-list 'image-types 'svg)
(provide 'rust-setup)

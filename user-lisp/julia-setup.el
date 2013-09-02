;; require julia mode
(require 'julia-mode)
(setq inferior-julia-program "/Applications/Julia-0.2.0-pre-7530d98cfd.app/Contents/Resources/julia/bin/julia-release-basic")
(add-hook 'julia-mode-hook
          (lambda () (local-set-key (kbd "s-<return>")
                                    'inferior-julia-send-line-or-region)))

(provide 'julia-setup)

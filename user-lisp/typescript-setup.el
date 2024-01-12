;; tsx mode
(use-package tsx-mode
  :config
  (define-derived-mode typescriptreact-mode tsx-mode
    "TypeScript TSX" "Major mode for TypeScript React files.")

  ;; use our derived mode for tsx files
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescriptreact-mode))

  ;; start prettier-js-mode with typescriptreact-mode
  (add-hook 'typescriptreact-mode-hook 'prettier-js-mode)

  ;; by default, typescript-mode is mapped to the treesitter typescript parser
  ;; use our derived mode to map both .tsx AND .ts -> typescriptreact-mode -> treesitter tsx
  (add-to-list 'treesit-language-source-alist '(typescriptreact-mode . tsx)))

;; see details here: https://www.masteringemacs.org/article/how-to-get-started-tree-sitter
;; tsx-mode uses tree-sitter, so we want to override the default
(setq major-mode-remap-alist
      '((tsx-ts-mode . typescriptreact-mode)))

(add-hook 'typescriptreact-mode-hook 'prettier-js-mode)

(cl-defmethod project-root ((project (head eglot-project)))
  (cdr project))

(defun my-project-try-tsconfig-json (dir)
  (when-let* ((found (locate-dominating-file dir "tsconfig.json")))
    (cons 'eglot-project found)))

(add-hook 'project-find-functions
          'my-project-try-tsconfig-json nil nil)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((typescript-mode :language-id "typescriptreact") . ("typescript-language-server" "--stdio"))))


(provide 'typescript-setup)

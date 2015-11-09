;; defaults.el
;; inital defaults to work with

;; theme
(load-theme 'solarized-dark t)
(load-theme 'erik t)


;; Don't ring bell
(setq ring-bell-function #'ignore)

;; Always display line numbers and column numbers
(setq line-number-mode t)
(setq column-number-mode t)

;; No fucking tabs
(setq-default indent-tabs-mode nil)

;; show matching parens
(show-paren-mode 1)

;; automatically delete trailing whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; require all files to end with a single newline
(setq require-final-newline 't)

;; don't make backup files
(setq make-backup-files nil)

;; Multiple cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-c C-.") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c C-,") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-/") 'mc/mark-all-like-this)

;; Bind return to automagically indent.
(global-set-key (kbd "RET") 'newline-and-indent)

;; Bind M-p/M-n to scroll-down/scroll-up
(global-set-key (kbd "M-p") 'scroll-down)
(global-set-key (kbd "M-n") 'scroll-up)

;; Bind C-x n l to multiple cursors next line
(global-set-key (kbd "C-x n l") 'mc/mark-next-like-this)

;; Bind C-x p to last window
(defun prev-window ()
  (interactive)
  (other-window -1))
(global-set-key (kbd "C-x p") 'prev-window)

;; Bind C-x c to pbcopy
(defun pbcopy-on-region ()
  (interactive)
  (shell-command-on-region (region-beginning) (region-end) "pbcopy"))
(global-set-key (kbd "C-x c") 'pbcopy-on-region)

;; turn on flyspell for text-mode
(dolist (hook '(text-mode-hook))
        (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(text-mode-hook))
        (add-hook hook (lambda () (flyspell-buffer))))

;; Markdown mode
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; adoc-mode
(autoload 'adoc-mode "adoc-mode"
  "Major mode for editing ascidoc files" t)
(add-to-list 'auto-mode-alist '("\\.asciidoc$" . adoc-mode))

;; yaml-mode
(autoload 'yaml-mode "yaml-mode"
  "Major mode for editing yaml files" t)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; open to ~/notes.md
(setq dir default-directory)
(find-file (expand-file-name "~/Dropbox (Personal)/notes.md"))
(setq default-directory dir)

;; Jinja2 Mode
(autoload 'jinja2-mode "jinja2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.jinja2$" . jinja2-mode))

;; ** IDO EVERYTHING!!!1!1!one!1
(ido-mode 1)
(setq ido-everywhere t)
(flx-ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

(global-set-key
 "\M-x"
 (lambda ()
   (interactive)
   (call-interactively
    (intern
     (ido-completing-read
      "M-x "
      (all-completions "" obarray 'commandp))))))

;; adjust thresholds for splits when opening multiple files
(setq split-height-threshold nil)
(setq split-width-threshold 0)


(provide 'defaults)

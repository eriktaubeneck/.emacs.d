;; defaults.el
;; inital defaults to work with

;; theme
(load-theme 'solarized-dark t)
(load-theme 'solarized-light t)
;; theme for ein
(defun switch-theme ()
  "Switch default bg for ipython notebook."
  ;;(face-remap-add-relative 'default '((:background "white"))))
  (load-theme 'zenburn-theme t)
  )
(add-hook 'ein:notebook-multilang-mode-hook 'switch-theme)

;; graphic vs terminal
(if (display-graphic-p)
    (progn
    ;; if graphic
      (load-theme 'erik-gui t)
      ;; SPACEMACS
      ;;(setq spacemacs-start-directory "~/.emacs.d/spacemacs/")
      ;;(load-file (concat spacemacs-start-directory "init.el"))
    )
    ;; else (optional)
    (load-theme 'erik t)
    )



;; Set Font
(add-to-list 'default-frame-alist '(font . "Monaco-16" ))

;; Don't ring bell
(setq ring-bell-function #'ignore)

;; Always display line numbers and column numbers
(setq line-number-mode t)
(setq column-number-mode t)

;; No fucking tabs
(setq-default indent-tabs-mode nil)

;; confirm exit
(setq confirm-kill-emacs 'y-or-n-p)

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

;; Bind C-x g to ag
(global-set-key (kbd "C-x g") 'ag)

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
(setq ispell-program-name "/usr/local/bin/ispell")
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

;; r-mode
(autoload 'r-mode "r-mode"
  "Major mode for editing r files" t)
(add-to-list 'auto-mode-alist '("\\.r$" . r-mode))

;; python-mode for .mpc files
(autoload 'python-mode "python-mode"
  "Major mode for editing mpc files" t)
(add-to-list 'auto-mode-alist '("\\.mpc$" . python-mode))

;; xhp-mode
(setq magic-mode-alist (append '(("<\\?php\\s " . xhp-mode))
                              magic-mode-alist))
(setq auto-mode-alist (append '(("\\.php$" . xhp-mode))
                              auto-mode-alist))

;; open to ~/notes.md
(setq dir default-directory)
(find-file (expand-file-name "~/Dropbox (Personal)/notes.md"))
(setq default-directory dir)


;; Jinja2 Mode
(autoload 'jinja2-mode "jinja2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.jinja2$" . jinja2-mode))

;; rust-mode
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs$" . rust-mode))



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

;; exec-path-from-shell setup
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; default utf-8 for flake8
(set-default-coding-systems 'utf-8)
(setq flycheck-python-flake8-executable "python3")

(provide 'defaults)

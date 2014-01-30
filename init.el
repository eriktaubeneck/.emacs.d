;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)


(autoload 'markdown-mode "markdown-mode"
     "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; put .emacs.d and user-lisp directory on load-path
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/user-lisp/")

;; Add local lib dir and recursively dir within lib
(let ((base "~/.emacs.d/lib"))
  (add-to-list 'load-path base)
  (dolist (f (directory-files base))
    (let ((name (concat base "/" f)))
      (when (and (file-directory-p name)
                 (not (equal f ".."))
                 (not (equal f ".")))
        (add-to-list 'load-path name)))))

;; Bind return to automagically indent.
(global-set-key (kbd "RET") 'newline-and-indent)

;; Bind M-p/M-n to scroll-down/scroll-up
(global-set-key (kbd "M-p") 'scroll-down)
(global-set-key (kbd "M-n") 'scroll-up)

;; Specific settings
(require 'package-manage)
(require 'defaults)
(require 'python-setup)
(require 'julia-setup)
;;
(require 'nyan-mode)
(nyan-mode t)
(nyan-start-animation)

(require 'fill-column-indicator)

(global-set-key [?\C-c ?m] 'column-marker-1)

(setq dir default-directory)
(find-file (expand-file-name "~/notes.md"))
(setq default-directory dir)

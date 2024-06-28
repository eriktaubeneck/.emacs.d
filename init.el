;; do this first to size the window quickly
(defvar font-size "16")

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; put .emacs.d and user-lisp directory on load-path
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

;; Enable company mode globally
(add-hook 'after-init-hook 'global-company-mode)

;; Specific settings
(require 'package-manage)
(require 'cl-libify)
(require 'defaults)
(require 'python-setup)
(require 'julia-setup)
(require 'sql-indent)
(require 'useful-functions)
(require 'tramp-setup)
(require 'user-fonts)
;;(require 'tsx-mode)
(require 'typescript-setup)
(require 'rust-setup)
;;

(require 'fill-column-indicator)

(put 'downcase-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" "0f18329d5b523ebc75bc6e4b0f04d650a0899ce1d9a0c961cd19585664f6c5e2" "fe1c13d75398b1c8fd7fdd1241a55c286b86c3e4ce513c4292d01383de152cb7" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "67e998c3c23fe24ed0fb92b9de75011b92f35d3e89344157ae0d544d50a63a72" default))
 '(package-selected-packages
   '(python-isort cl-libify markdown-mode prettier-js deferred jedi company-jedi rjsx-mode powerline dracula-theme flymake-python-pyflakes nyan-mode yaml-mode ws-butler winum which-key wgrep volatile-highlights vi-tilde-fringe uuidgen use-package toc-org sublime-themes spaceline solarized-theme smex smartrep scss-mode sass-mode restart-emacs rainbow-delimiters python-mode popwin persp-mode pcre2el paradox org-bullets open-junk-file neotree multiple-cursors move-text mmm-mode markdown-toc macrostep lorem-ipsum linum-relative link-hint jinja2-mode ivy-hydra info+ indent-guide hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-indentation hide-comnt help-fns+ helm-make haskell-mode google-translate golden-ratio gh-md flycheck flx-ido fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu elisp-slime-nav ein dumb-jump define-word counsel-projectile column-marker column-enforce-mode clean-aindent-mode auto-highlight-symbol auto-compile aggressive-indent ag adoc-mode adaptive-wrap ace-window ace-link))
 '(tramp-verbose 6 nil (tramp) "Enable remote command traces")
 '(warning-suppress-types '((comp))))

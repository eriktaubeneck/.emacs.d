;; Turn off mouse interface early in startup to avoid momentary display

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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


;; Specific settings
(require 'package-manage)
(require 'defaults)
(require 'python-setup)
(require 'julia-setup)
(require 'indent-sql)
(require 'useful-functions)
(require 'tramp-setup)
(require 'xhp-mode)
;;

(require 'fill-column-indicator)

(global-set-key [?\C-c ?m] 'column-marker-1)
(put 'downcase-region 'disabled nil)
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(package-selected-packages
;;    (quote
;;     (php-mode yaml-mode sublime-themes solarized-theme smartparens scss-mode sass-mode multiple-cursors markdown-mode jinja2-mode haskell-mode flycheck flx-ido fill-column-indicator exec-path-from-shell column-marker ag adoc-mode))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )

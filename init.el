;; Turn off mouse interface early in startup to avoid momentary display
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
;;

(require 'fill-column-indicator)

(global-set-key [?\C-c ?m] 'column-marker-1)
(put 'downcase-region 'disabled nil)

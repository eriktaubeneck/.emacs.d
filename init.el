;; Add thrid party repos
(require 'package)
(defvar marmalade '("marmalade" . "http://marmalade-repo.org/packages/"))
(defvar gnu '("gnu" . "http://elpa.gnu.org/packages/"))
(defvar melpa '("melpa" . "http://melpa.milkbox.net/packages/"))

;; Add third-party repos
(add-to-list 'package-archives marmalade)
(add-to-list 'package-archives melpa t)

(autoload 'markdown-mode "markdown-mode"
     "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

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

;; require julia mode
(require 'julia-mode)
(setq inferior-julia-program "/Applications/Julia-0.2.0-pre-acc85a8eb0.app/Contents/Resources/julia/bin/julia-release-basic")
(add-hook 'julia-mode-hook
          (lambda () (local-set-key (kbd "s-<return>")
                                    'inferior-julia-send-line-or-region)))

;; No fucking tabs
(setq-default indent-tabs-mode nil)

;; Multiple cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-c C-.") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c C-,") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-/") 'mc/mark-all-like-this)

;; ** IDO EVERYTHING!!!1!1!one!1
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(global-set-key
 "\M-x"
 (lambda ()
   (interactive)
   (call-interactively
    (intern
     (ido-completing-read
      "M-x "
      (all-completions "" obarray 'commandp))))))

;;======== configure package management ========
(require 'package)

(defvar marmalade '("marmalade" . "http://marmalade-repo.org/packages/"))
(defvar gnu '("gnu" . "http://elpa.gnu.org/packages/"))
(defvar melpa '("melpa" . "http://melpa.milkbox.net/packages/"))

;; Add third-party repos
(add-to-list 'package-archives gnu)
(add-to-list 'package-archives marmalade)
(add-to-list 'package-archives melpa)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; packages I use
(defvar user-packages
  '(flycheck
    column-marker
    fill-column-indicator
    jinja2-mode
    markdown-mode
    multiple-cursors
    sublime-themes
    smartparens
    haskell-mode
    sass-mode
    scss-mode
    adoc-mode
    yaml-mode
    ))

;; install any packages that aren't found
(dolist (p user-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(provide 'package-manage)

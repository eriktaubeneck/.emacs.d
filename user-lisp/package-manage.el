;;======== configure package management ========
(require 'package)

(defvar marmalade '("marmalade" . "https//marmalade-repo.org/packages/"))
(defvar gnu '("gnu" . "https://elpa.gnu.org/packages/"))
(defvar melpa '("melpa" . "https://melpa.org/packages/"))
(defvar melpastable '("MELPA Stable" . "https://stable.melpa.org/packages/"))

;; Add third-party repos
(add-to-list 'package-archives melpastable)
(add-to-list 'package-archives gnu)
(add-to-list 'package-archives marmalade)
(add-to-list 'package-archives melpa)


;; packages I use
(defvar user-packages
  '(flycheck
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
    ag
    flx-ido
    exec-path-from-shell
    solarized-theme
    websocket
    request
    python-mode
    smartrep
    ein
    nyan-mode
    zenburn-theme
    rust-mode
    ))

;; install any packages that aren't found
(dolist (p user-packages)
  (when (not (package-installed-p p))
    (package-refresh-contents)
    (package-install p)
    )
  )

(package-initialize)
(provide 'package-manage)

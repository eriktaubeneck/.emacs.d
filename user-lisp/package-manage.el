;;======== configure package management ========
(require 'package)

;; (defvar marmalade '("marmalade" . "http://marmalade-repo.org/packages/"))
(defvar gnu '("gnu" . "http://elpa.gnu.org/packages/"))
(defvar melpa '("melpa" . "https://melpa.org/packages/") t)

(defvar melpastable '("MELPA Stable" . "http://stable.melpa.org/packages/"))

;; Add third-party repos
(add-to-list 'package-archives melpastable)
(add-to-list 'package-archives gnu)
(add-to-list 'package-archives melpa)
;; (add-to-list 'package-archives marmalade)


;; packages I use
(defvar user-packages
  '(flycheck
    fill-column-indicator
    jinja2-mode
    markdown-mode
    multiple-cursors
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
    nyan-mode
    zenburn-theme
    dracula-theme
    rust-mode
    lsp-mode
    solidity-mode
    ligature
    powerline
    typescript-mode
    rjsx-mode
    tree-sitter
    tree-sitter-langs
    company
    coverlay
    origami
    graphql-mode
    company-jedi
    vundo
    lsp-mode
    lsp-ui
    lsp-treemacs
    lsp-ivy
    dap-mode
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

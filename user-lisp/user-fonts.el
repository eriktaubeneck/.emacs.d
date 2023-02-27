;; Set Font

(defvar font-size "16")

(defun font-size-string (font font-size)
  (concatenate 'string font "-" font-size))

;; list of fonts, in order of preference
(defvar fonts
  '(
    "Berkeley Mono"
    "Hack"
    "Menlo"
    ))


(defun find-installed-font (fonts)
  "Finds the first installed font in FONTS."
  (catch 'font-found
    (dolist (font fonts)
      (if (find-font (font-spec :name font))
        (progn
          (throw 'font-found font)
          )
        (unless (file-exists-p "~/.emacs.d/.suppress-font-warning")
          (warn (format "Font %s is not installed. Touch ~/.emacs.d/.suppress-font-warning to ignore"  font))
          )
        )
      )
    )
  )


(let ((font (find-installed-font fonts)))
  (set-frame-font (font-size-string font font-size))
  )



;; ligatures!
(autoload 'ligatures "ligatures" nil t)

;; Enable the www ligature in every possible major mode
(ligature-set-ligatures 't '("www"))

;; Enable ligatures in programming modes
(defvar ligature-set
  '("www"
    "**"
    "***"
    "**/"
    "*>"
    "*/"
    "\\\\"
    "\\\\\\"
    "{-"
    "::"
    ":::"
    ":="
    "!!"
    "!="
    "!=="
    "-}"
    "----"
    "-->"
    "->"
    "->>"
    "-<"
    "-<<"
    "-~"
    "#{"
    "#["
    "##"
    "###"
    "####"
    "#("
    "#?"
    "#_"
    "#_("
    ".-"
    ".="
    ".."
    "..<"
    "..."
    "?="
    "??"
    ";;"
    "/*"
    "/**"
    "/="
    "/=="
    "/>"
    "//"
    "///"
    "&&"
    "||"
    "||="
    "|="
    "|>"
    "^="
    "$>"
    "++"
    "+++"
    "+>"
    "=:="
    "=="
    "==="
    "==>"
    "=>"
    "=>>"
    "<="
    "=<<"
    "=/="
    ">-"
    ">="
    ">=>"
    ">>"
    ">>-"
    ">>="
    ">>>"
    "<*"
    "<*>"
    "<|"
    "<|>"
    "<$"
    "<$>"
    "<!--"
    "<-"
    "<--"
    "<->"
    "<+"
    "<+>"
    "<="
    "<=="
    "<=>"
    "<=<"
    "<>"
    "<<"
    "<<-"
    "<<="
    "<<<"
    "<~"
    "<~~"
    "</"
    "</>"
    "~@"
    "~-"
    "~>"
    "~~"
    "~~>"
    "%%"
    ))

(ligature-set-ligatures 'prog-mode ligature-set)
(ligature-set-ligatures 'html-mode ligature-set)
(ligature-set-ligatures 'markdown-mode ligature-set)

(global-ligature-mode 't)

(provide 'user-fonts)

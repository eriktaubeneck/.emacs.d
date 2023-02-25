;; Set Font
(add-to-list 'default-frame-alist '(font . "Berkeley Mono-16" ))

(autoload 'ligatures "ligatures" nil t)

;; Enable the www ligature in every possible major mode
(ligature-set-ligatures 't '("www"))

;; Enable ligatures in programming modes
(defvar ligature-set '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
                       ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
                       "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
                       "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
                       "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
                       "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
                       "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
                       "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
                       "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
                       "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))
(ligature-set-ligatures 'prog-mode ligature-set)
(ligature-set-ligatures 'html-mode ligature-set)
(ligature-set-ligatures 'markdown-mode ligature-set)

(global-ligature-mode 't)

(provide 'user-fonts)

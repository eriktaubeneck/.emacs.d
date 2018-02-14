;;; xhp-mode.el --- major mode for editing PHP/hack code with XHP support

(eval-when-compile
  (when (fboundp #'byte-compile-disable-warning)
    (byte-compile-disable-warning 'cl-functions)
    (byte-compile-disable-warning 'obsolete)
    (byte-compile-disable-warning 'interactive-only)))

(require 'sgml-mode)
(require 'hack-mode)

(eval-and-compile
  (c-add-language 'xhp-mode 'hack-mode))

(defgroup xhp nil
  "Major mode `xhp-mode' for editing Hack+XHP code."
  :prefix "xhp-"
  :group 'languages)

(defconst xhp-end-tag-re
  (concat "</" sgml-name-re ">\\|/>")
  "Find the end of a XHP element.")

(defconst xhp-after-tag-re "[),;]"
  "Find where XHP ends.
This complements the assumption of where XHP appears from
`xhp-before-tag-re', which see.")

(defcustom xhp-mode-hook nil
  "list of functions to be executed on entry to xhp-mode."
  :type 'hook
  :group 'xhp)

(defcustom xhp-mode-use-xhp-find-tag-p t
  "set to t to use the new xhp-mode-find-tag-at-point"
  :group 'xhp)

;; TODO: XHP declaration classes - 'attribute', 'children', 'category' keywords

(defsubst xhp-find-before-tag ()
  "Find where XHP starts.

Assume XHP appears in the following instances:
- Inside parentheses, when returned or as the first argument
  to a function, and after a newline
- When assigned to variables or object properties, but only
  on a single line
- As the N+1th argument to a function

This is an optimized version of (re-search-backward \"[=(,]\n\"
nil t), except set point to the end of the match.  This logic
executes up to the number of lines in the file, so it should be
really fast to reduce that impact."

  (interactive)

  ;; todo deal with trailing whitespace gracefully...

  (let (pos)
    (while (and (> (point) (point-min))
                (not (progn
                       (end-of-line 0)
                       ;; (re-search-backward "." nil t)
                       (when (or (eq (char-before) 40)   ; (
                                 (eq (char-before) 61)   ; =
                                 (eq (char-before) 44)   ; ,
                                 (and ;; value in associative array
                                  (eq (char-before) 62)  ; >
                                  (eq (char-before (- (point) 1)) 61)
                                  )
                                 (and ;; return a naked xhp fragment
                                  (eq (char-before) 110)  ; n
                                  (eq (char-before (- (point) 1)) 114) ; r
                                  (eq (char-before (- (point) 2)) 117) ; u
                                  (eq (char-before (- (point) 3)) 116) ; t
                                  (eq (char-before (- (point) 4)) 101) ; e
                                  (eq (char-before (- (point) 5)) 114) ; r
                                  (eq (char-before (- (point) 6)) 32) ; ' '
                                  )
                                 )
                         (progn
                           (setq pos (1- (point)))))))))
    pos))

(defun xhp-indented-element-p ()
  "Determine if/how the current line should be indented as XHP.

Return `first' for the first XHP element on its own line.
Return `nth' for subsequent lines of the first XHP element.
Return `expression' for an embedded Hack expression.
Return `after' for anything after the last XHP element.
Return nil for non-XHP lines.

Currently, XHP indentation supports the following styles:

- Single-line elements (indented like normal JS):

  var element = <div></div>;

- Multi-line elements (enclosed in parentheses):

  function () {
    return (
      <div>
        <div></div>
      </div>
    );
  }

- Function arguments:

  React.render(
    <div></div>,
    document.querySelector('.root')
  );"
  (interactive)
  (let ((current-pos (point))
        (current-line (line-number-at-pos))
        last-pos
        before-tag-pos before-tag-line
        tag-start-pos tag-start-line
        tag-end-pos tag-end-line
        after-tag-line
        parens paren type)

    (save-excursion
      (and

       ;; Determine if we're inside a xhp element
       (progn
         (end-of-line)
         (while (and (not tag-start-pos)
                     (setq last-pos (xhp-find-before-tag)))
           (while (forward-comment 1))
           (when (= (char-after) 60) ; <
             (setq before-tag-pos last-pos
                   tag-start-pos (point)))
           (goto-char last-pos))
         tag-start-pos)

       (progn
         (setq before-tag-line (line-number-at-pos before-tag-pos)
               tag-start-line (line-number-at-pos tag-start-pos))
         (and
          ;; A "before" line which also starts an element begins with js, so
          ;; indent it like js
          (> current-line before-tag-line)
          ;; Only indent the xhp lines like xhp
          (>= current-line tag-start-line)))

       (cond

        ;; Analyze bounds if there are any
        ((progn
           (while (and (not tag-end-pos)
                       (setq last-pos (re-search-forward xhp-end-tag-re nil t)))
             (while (forward-comment 1))
             (when (looking-at xhp-after-tag-re)
               (setq tag-end-pos last-pos)))
           tag-end-pos)
         (setq tag-end-line (line-number-at-pos tag-end-pos)
               after-tag-line (line-number-at-pos after-tag-line))
         (or (and
              ;; Ensure we're actually within the bounds of the xhp
              (<= current-line tag-end-line)
              ;; An "after" line which does not end an element begins with
              ;; js, so indent it like js
              (<= current-line after-tag-line))
             (and
              ;; Handle another case where there could be e.g. comments after
              ;; the element
              (> current-line tag-end-line)
              (< current-line after-tag-line)
              (setq type 'after))))

        ;; They may not be any bounds (yet)
        (t))

       ;; Check if we're inside an embedded multi-line js expression
       (cond
        ((not type)
         (goto-char current-pos)
         (end-of-line)
         (setq parens (nth 9 (syntax-ppss)))
         (while (and parens (not type))
           (setq paren (car parens))
           (cond
            ((and (>= paren tag-start-pos)
                  ;; Curly bracket indicates the start of an embedded expression
                  (= (char-after paren) 123) ; {
                  ;; The first line of the expression is indented like sgml
                  (> current-line (line-number-at-pos paren))
                  ;; Check if within a closing curly bracket (if any)
                  ;; (exclusive, as the closing bracket is indented like sgml)
                  (cond
                   ((progn
                      (goto-char paren)
                      (ignore-errors (let (forward-sexp-function)
                                       (forward-sexp))))
                    (< current-line (line-number-at-pos)))
                   (t)))
             ;; Indicate this guy will be indented specially
             (setq type 'expression))
            (t (setq parens (cdr parens)))))
         t)
        (t))

       (cond
        (type)
        ;; Indent the first xhp thing like hack so we can indent
        ;; future xhp things like sgml relative to the first thing
        ((= current-line tag-start-line) 'first)
        ('nth))))))

(defmacro hack-as-sgml (&rest body)
  "Execute BODY as if in sgml-mode."
  `(with-syntax-table sgml-mode-syntax-table
     (let (forward-sexp-function
           parse-sexp-lookup-properties)
       ,@body)))

(defun xhp-expression-in-sgml-indent-line ()
  "Indent the current line as Hack or SGML (whichever is farther)."
  (let* (indent-col
         (savep (point))
         ;; Don't whine about errors/warnings when we're indenting.
         ;; This has to be set before calling parse-partial-sexp below.
         (inhibit-point-motion-hooks t)
         (parse-status (save-excursion
                         (syntax-ppss (point-at-bol)))))
    ;; Don't touch multiline strings.
    (unless (nth 3 parse-status)
      (setq indent-col (save-excursion
                         (back-to-indentation)
                         (if (>= (point) savep) (setq savep nil))
                         (hack-as-sgml (sgml-calculate-indent))))
      (if (null indent-col)
          'noindent
        ;; Use whichever indentation column is greater, such that the sgml
        ;; column is effectively a minimum
        (setq indent-col (+ indent-col (c-indent-line)))
        (if savep
            (save-excursion (indent-line-to indent-col))
          (indent-line-to indent-col))))))

(defun xhp-indent-line ()
  "Indent the current line as XHP (with SGML offsets).
i.e., customize XHP element indentation with `sgml-basic-offset',
`sgml-attribute-offset' et al."
  (interactive)

  (let ((indentation-type (xhp-indented-element-p)))
    (cond
     ;; case: expression
     ((eq indentation-type 'expression)
      (progn
        (xhp-expression-in-sgml-indent-line)
        ))
     ;; case first/after
     ((or (eq indentation-type 'first)
          (eq indentation-type 'after))
      ;; Don't treat this first thing as a continued expression (often a "<" or
      ;; ">" causes this misinterpretation)
      (progn
        (cl-letf (((symbol-function #'xhp-continued-expression-p) 'ignore))
          (c-indent-line))))

     ;; case: nth
     ((eq indentation-type 'nth)
      (progn
        (hack-as-sgml (sgml-indent-line))))

     ;; case: nil, default to regular indentation
     (t (progn
          (c-indent-line))))))

(defun xhp-indent-line-or-region (&optional arg region)
  "Indent active region, current line, or block starting on this line.
In Transient Mark mode, when the region is active, reindent the region.
Otherwise, with a prefix argument, rigidly reindent the expression
starting on the current line.
Otherwise reindent just the current line."
  (interactive
   (list current-prefix-arg (use-region-p)))
  (if region
      (let
          ((lines-count (count-lines (region-beginning) (region-end))))
        (save-excursion
          (goto-char (region-beginning))
          (dotimes (i lines-count)
            (xhp-indent-line)
            (forward-line 1))))
    (xhp-indent-line)))

; (setq max-specpdl-size 10)  ; default is 1000, reduce the backtrace level
; (setq debug-on-error t)

(defcustom xhp-font-lock-extra-types nil
  "*List of extra types (aside from the type keywords) to recognize in xhp mode.
   Each list item should be a regexp matching a single identifier."
  :group 'xhp-mode)

(defconst xhp-sgml-font-lock-keywords
  (list
   '("</?\\([[:alnum:]]+\\)[ >]"
     (1 'font-lock-type-face))
   )
  "Keywords for xml in hack+xhp"
  )

(defconst xhp-font-lock-keywords-1
  (append
   (c-lang-const c-matchers-1 xhp)
   xhp-sgml-font-lock-keywords
   )
  "Minimal highlighting for xhp mode.")

(defconst xhp-font-lock-keywords-2
  (append
   (c-lang-const c-matchers-2 xhp)
   xhp-sgml-font-lock-keywords
   )
  "Fast normal highlighting for xhp mode.")

(defconst xhp-font-lock-keywords-3
  (append
   (c-lang-const c-matchers-3 xhp)
   xhp-sgml-font-lock-keywords
   )
  "Accurate normal highlighting for xhp mode.")

(defvar xhp-font-lock-keywords xhp-font-lock-keywords-3
  "Default expressions to highlight in xhp mode.")

;;;###autoload
(define-derived-mode xhp-mode hack-mode "XHP"
  "Major mode for editing Hack code with XHP.\n\n\\{xhp-mode-map}"

  (set (make-local-variable 'max-lisp-eval-depth)
       (max max-lisp-eval-depth 3000))
  (set (make-local-variable 'syntax-propertize-function) nil)

  (c-initialize-cc-mode t)
  ;; (use-local-map hack-mode-map) ;; Hack
  (c-init-language-vars xhp-mode)
  (c-common-init 'xhp-mode)

  (modify-syntax-entry ?# "< b")
  (modify-syntax-entry ?_ "w")
  (modify-syntax-entry ?- "w") ;; TODO can we make hyphen wordish only inside of xhp?

  (setq indent-line-function 'xhp-indent-line-or-region)
  (setq indent-region-function 'xhp-indent-line-or-region)
  ;; c-mode overrides indent-for-tab-command for some reason
  ;; (they even have a comment with 'is this the right thing to
  ;; do?' there). if we want xhp indentation to work for regions
  ;; as well we have to set this back. (previously this just used
  ;; c-indent AFAICT, so this bug was hidden)
  (substitute-key-definition
   'c-indent-line-or-region
   'indent-for-tab-command
   xhp-mode-map)

  (setq-local compile-command (concat hack-client-binary " --from emacs"))
  (add-hook 'completion-at-point-functions 'hack-completion nil t)

  (modify-syntax-entry ?< "_") ;; Treat '<' and '>' as syntactic whitespace
  (modify-syntax-entry ?> "_") ;; band-aid fix for user attributes on class

  (when xhp-mode-use-xhp-find-tag-p
    (put 'xhp-mode 'find-tag-default-function 'xhp-mode-find-tag-at-point))

  (run-hooks 'xhp-mode-hook))

;; A variation of find-tag-default that enables <xhp:tags:like:this to match.
(defun xhp-mode-find-tag-at-point ()
  "Determine default tag to search for, based on text at point.
If there is no plausible default, return nil."
  (let* ((xhp "\\(?:\\w\\|[_-]\\)") ;; xhp other than ':'
         (re-symbol
          (concat
           ;; xhp (explicitly does not include "::")
           ":?\\(?:\\(?1:\\(?::" xhp "\\|" xhp "\\)+\\)"
           ;; optional static var after xhp class
           "\\(?:::\\(?2:\\(?:\\w\\|_\\)+\\)\\)?\\)\\|"
           ;; typical symbol (includes Static::refs)
           "\\(?1:\\(\\w\\|_\\)+\\)\\(?:::\\(?2:\\(?:\\w\\|_\\)+\\)\\)?"))
         (symbol-chars "a-zA-Z$_:-")
         (non-chars (concat "^" symbol-chars)))
    (flet ((skip-backward ()
             (skip-chars-backward non-chars (line-beginning-position)))
           (skip-forward ()
             (skip-chars-forward non-chars (line-end-position)))
           (test (initial-skip)
             (save-excursion
               (funcall initial-skip)
               (skip-chars-backward symbol-chars (line-beginning-position))
               (looking-at re-symbol))))
      (when (or (test (lambda ()))
                (test #'skip-backward)
                (test #'skip-forward))
        (let ((group (if (and (< (match-end 1) (point)) (match-end 2)) 2 1)))
          (buffer-substring-no-properties
           (match-beginning group) (match-end group)))))))

(provide 'xhp-mode)

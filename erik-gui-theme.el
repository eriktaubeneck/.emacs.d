(deftheme erik-gui
  "Created 2015-01-05.")

;; theme
(load-theme 'dracula t)
(setq nyan-animate-nyancat t)
(setq nyan-wavy-trail t)
(nyan-mode)

;; (defun custom-modeline-modified
;;   ((let* ((config-alist
;;             '(("*" all-the-icons-faicon-family all-the-icons-faicon "chain-broken" :height 1.2 :v-adjust -0.0)
;;               ("-" all-the-icons-faicon-family all-the-icons-faicon "link" :height 1.2 :v-adjust -0.0)
;;               ("%" all-the-icons-octicon-family all-the-icons-octicon "lock" :height 1.2 :v-adjust 0.1)))
;;            (result (cdr (assoc (format-mode-line "%*") config-alist))))
;;       (propertize (apply (cadr result) (cddr result))
;;                   'face `(:family ,(funcall (car result)))))))

;; (defun custom-modeline-window-number ()
;;   (propertize (format " %c" (+ 9311 (window-numbering-get-number)))
;;               'face `(:height ,(/ (* 0.90 powerline/default-height) 100.0))
;;               'display '(raise 0.0)))

;; (defun custom-modeline-mode-icon ()
;;   (format " %s"
;;     (propertize icon
;;                 'help-echo (format "Major-mode: `%s`" major-mode)
;;                 'face `(:height 1.2 :family ,(all-the-icons-icon-family-for-buffer)))))

;; (defun custom-modeline-region-info ()
;;   (when mark-active
;;     (let ((words (count-lines (region-beginning) (region-end)))
;;           (chars (count-words (region-end) (region-beginning))))
;;       (concat
;;        (propertize (format "   %s" (all-the-icons-octicon "pencil") words chars)
;;                    'face `(:family ,(all-the-icons-octicon-family))
;;                    'display '(raise -0.0))
;;        (propertize (format " (%s, %s)" words chars)
;;                    'face `(:height 0.9))))))


;; (defun -custom-modeline-github-vc ()
;;   (let ((branch (mapconcat 'concat (cdr (split-string vc-mode "[:-]")) "-")))
;;     (concat
;;      (propertize (format " %s" (all-the-icons-alltheicon "git")) 'face `(:height 1.2) 'display '(raise -0.1))
;;      " · "
;;      (propertize (format "%s" (all-the-icons-octicon "git-branch"))
;;                  'face `(:height 1.3 :family ,(all-the-icons-octicon-family))
;;                  'display '(raise -0.1))
;;      (propertize (format " %s" branch) 'face `(:height 0.9)))))

;; (defun -custom-modeline-svn-vc ()
;;   (let ((revision (cadr (split-string vc-mode "-"))))
;;     (concat
;;      (propertize (format " %s" (all-the-icons-faicon "cloud")) 'face `(:height 1.2) 'display '(raise -0.1))
;;      (propertize (format " · %s" revision) 'face `(:height 0.9)))))

;; (defun custom-modeline-icon-vc ()
;;   (when vc-mode
;;     (cond
;;       ((string-match "Git[:-]" vc-mode) (-custom-modeline-github-vc))
;;       ((string-match "SVN-" vc-mode) (-custom-modeline-svn-vc))
;;       (t (format "%s" vc-mode)))))

;; (defun custom-modeline-flycheck-status ()
;;   (let* ((text (pcase flycheck-last-status-change
;;                 (`finished (if flycheck-current-errors
;;                                (let ((count (let-alist (flycheck-count-errors flycheck-current-errors)
;;                                               (+ (or .warning 0) (or .error 0)))))
;;                                  (format "✖ %s Issue%s" count (unless (eq 1 count) "s")))
;;                              "✔ No Issues"))
;;                 (`running     "⟲ Running")
;;                 (`no-checker  "⚠ No Checker")
;;                 (`not-checked "✖ Disabled")
;;                 (`errored     "⚠ Error")
;;                 (`interrupted "⛔ Interrupted")
;;                 (`suspicious  ""))))
;;      (propertize text
;;                  'help-echo "Show Flycheck Errors"
;;                  'mouse-face '(:box 1)
;;                  'local-map (make-mode-line-mouse-map
;;                              'mouse-1 (lambda () (interactive) (flycheck-list-errors)))))))

;; (defvar powerline/upgrades nil)

;; (defun powerline/count-upgrades ()
;;   (let ((buf (current-buffer)))
;;     (package-list-packages-no-fetch)
;;     (with-current-buffer "*Packages*"
;;       (setq powerline/upgrades (length (package-menu--find-upgrades))))
;;     (switch-to-buffer buf)))
;; (advice-add 'package-menu-execute :after 'powerline/count-upgrades)

;; (defun custom-modeline-package-updates ()
;;   (let ((num (or powerline/upgrades (powerline/count-upgrades))))
;;     (when (> num 0)
;;       (propertize
;;         (concat
;;          (propertize (format "%s" (all-the-icons-octicon "package"))
;;                      'face `(:family ,(all-the-icons-octicon-family) :height 1.2)
;;                      'display '(raise -0.1))
;;          (propertize (format " %d updates " num)
;;                      'face `(:height 0.9)))
;;         'help-echo "Open Packages Menu"
;;         'mouse-face '(:box 1)
;;         'local-map (make-mode-line-mouse-map
;;                     'mouse-1 (lambda () (interactive) (package-list-packages)))))))

;; (defun custom-modeline-suntime ()
;;   (if (and (boundp 'yahoo-weather-info) yahoo-weather-mode)
;;       (concat
;;          (format "%s "(yahoo-weather-info-format yahoo-weather-info "%(sunrise-time)"))
;;          (format "%s  " (all-the-icons-wicon "sunrise" :height 0.5 :v-adjust -0.1))
;;          (format "%s "(yahoo-weather-info-format yahoo-weather-info "%(sunset-time)"))
;;          (format "%s "(all-the-icons-wicon "sunset" :height 0.5 :v-adjust -0.1)))
;;     ""))

;; (defun custom-modeline-weather ()
;;   (if (and (boundp 'yahoo-weather-info) yahoo-weather-mode)
;;       (let* ((weather (yahoo-weather-info-format yahoo-weather-info format))
;;              (icon (all-the-icons-icon-for-weather (downcase weather)))
;;              (family (if (> (length icon) 2)
;;                          (face-attribute 'default :family)
;;                        (all-the-icons-wicon-family))))
;;         (propertize (format " %s " icon)
;;                     'help-echo weather
;;                     'face `(:height 1.0 :family ,family)
;;                     'display '(raise 0.1)))
;;   ""))

;; (defun custom-modeline-time ()
;;   (let* ((hour (string-to-number (format-time-string "%i")))
;;          (icon (all-the-icons-wicon (format "time-%s" hour) :height 1.3 :v-adjust 0.0)))
;;     (concat
;;      (propertize (format-time-string " %h:%m ") 'face `(:height 0.9))
;;      (propertize (format "%s " icon) 'face `(:height 1.0 :family ,(all-the-icons-wicon-family)) 'display '(raise -0.0)))))


;; (setq mode-line-format '("%e" (:eval
;;   (concat
;;     ;; (custom-modeline-modified)
;;     ;; (custom-modeline-window-number)
;;     ;; (custom-modeline-mode-icon)
;;     ;; (custom-modeline-icon-vc)
;;     ;; (custom-modeline-region-info)
;;     ;; (custom-modeline-flycheck-status)
;;     ;; (custom-modeline-suntime)
;;     ;; (custom-modeline-weather)
;;     ;; (custom-modeline-time)
;;     )
;;   )))

(setq mode-line-format '("%e" (:eval
  (let*
      ((active (powerline-selected-window-active))
       (mode-line-buffer-id
        (if active 'mode-line-buffer-id 'mode-line-buffer-id-inactive))
       (mode-line
        (if active 'mode-line 'mode-line-inactive))
       (face0
        (if active 'powerline-active0 'powerline-inactive0))
       (face1
        (if active 'powerline-active1 'powerline-inactive1))
       (face2
        (if active 'powerline-active2 'powerline-inactive2))
       (separator-left
        (intern
         (format "powerline-%s-%s"
                 (powerline-current-separator)
                 (car powerline-default-separator-dir))))
       (separator-right
        (intern (format "powerline-%s-%s"
                        (powerline-current-separator)
                        (cdr powerline-default-separator-dir))))
       (lhs
        (list
         (powerline-raw "%*" face0 'l)
         (when powerline-display-buffer-size
           (powerline-buffer-size face0 'l))
         (when powerline-display-mule-info
           (powerline-raw mode-line-mule-info face0 'l))
         (powerline-buffer-id `(mode-line-buffer-id ,face0) 'l)
         (when
             (and (boundp 'which-func-mode) which-func-mode)
           (powerline-raw which-func-format face0 'l))
         (powerline-raw " " face0)
         (funcall separator-left face0 face1)
         (when
             (and (boundp 'erc-track-minor-mode) erc-track-minor-mode)
           (powerline-raw erc-modified-channels-object face1 'l))
         (powerline-major-mode face1 'l)
         (powerline-process face1)
         (powerline-minor-modes face1 'l)
         (powerline-narrow face1 'l)
         (powerline-raw " " face1)
         (funcall separator-left face1 face2)
         (powerline-vc face2 'r)
         (when
             (bound-and-true-p nyan-mode)
           (powerline-raw (list (nyan-create)) face2 'l))))
       (rhs
        (list
         (powerline-raw global-mode-string face2 'r)
         (funcall separator-right face2 face1)
         (unless window-system
           (powerline-raw (char-to-string 57505) face1 'l))
         (powerline-raw "%4l" face1 'l)
         (powerline-raw ":" face1 'l)
         (powerline-raw "%3c" face1 'r)
         (funcall separator-right face1 face0)
         (powerline-raw " " face0)
         (powerline-raw "%6p" face0 'r)
         (when powerline-display-hud (powerline-hud face0 face2))
         (powerline-fill face0 0))))
    (concat (powerline-render lhs)
            (powerline-fill face2 (powerline-width rhs))
            (powerline-render rhs)
            )
    )
  )
                         )
      )

(require 'powerline)
(powerline-default-theme)

;; (print mode-line-format (get-buffer "foo"))

(provide-theme 'erik-gui)

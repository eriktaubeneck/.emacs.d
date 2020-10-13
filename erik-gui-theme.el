(deftheme erik-gui
  "Created 2015-01-05.")

(load-theme 'solarized-dark t)
(custom-theme-set-faces
  'erik-gui
  '(default ((t (:background "#002833"))))
)

(setq nyan-animate-nyancat t)
(setq nyan-wavy-trail t)
(nyan-mode)

(provide-theme 'erik-gui)

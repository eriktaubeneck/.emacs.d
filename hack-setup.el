(require 'hh-client)
(add-hook 'xhp-mode-hook
   (lambda ()
     (progn
       (local-set-key (kbd "C-c C-l") #'hh-client-find-definition)
       (local-set-key (kbd "C-c C-t") #'hh-client-show-type-at-point)
)))

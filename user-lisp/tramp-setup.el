;; setup tramp mode for remote file access

; Make tramp handle 2-factor auth
(setq
 tramp-password-prompt-regexp
 (concat
  "^.*"
  (regexp-opt
   '("passcode" "Passcode"
     "password" "Password") t)
  ".*:\0? *"))

(setq tramp-default-method "sshx")

;; (setq debug-on-error t
;;       debug-on-signal t)

(setq vc-handled-backends nil)

(custom-set-variables
 '(tramp-verbose 6 nil (tramp) "Enable remote command traces"))

(provide 'tramp-setup)


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(define-key global-map "\C-h" 'backward-kill-word)

;; screen interaction

(define-key global-map (kbd "M-[ 1;5d") 'backward-word)
(define-key global-map "\M-[1;5c" 'forward-word)


(set-face-italic-p 'italic nil)

;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(package-selected-packages (quote (chess web-server))))
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;)

(defun load-directory (dir)
      (let ((load-it (lambda (f)
         (load-file (concat (file-name-as-directory dir) f)))
       ))
	(mapc load-it (directory-files dir nil "\\.el$"))))

;;(load-directory "~/.emacs.d/plugins")


(setq column-number-mode t)


(add-hook 'LaTeX-mode-hook
          'turn-on-auto-fill)

(add-hook 'LaTeX-mode-hook
          (lambda () (flyspell-mode 1)))

(add-hook 'LaTeX-mode-hook
          (lambda () (set (make-local-variable 'compile-command)
                          (let ((file (file-name-nondirectory buffer-file-name)))
                                      (format "pdflatex -halt-on-error -file-line-error %s" file)
                                      ))))

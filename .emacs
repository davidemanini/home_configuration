
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)


;; Ctr-h deletes the previous word

(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-region (point) (progn (forward-word arg) (point)))))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (delete-word (- arg)))

(define-key global-map "\C-h" 'backward-delete-word)

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

(add-hook 'text-mode-hook 'auto-fill-mode)


(add-hook 'LaTeX-mode-hook 'flyspell-mode)
;(setq ispell-dictionary "en")
;(add-hook 'LaTeX-mode-hook 'ispell)


(add-hook 'LaTeX-mode-hook 'whitespace-mode)

;(add-hook 'LaTeX-mode-hook
;          '(lambda () (ispell-change-dictionary "en"))

(add-hook 'LaTeX-mode-hook
          (lambda () (set (make-local-variable 'compile-command)
                          (let ((file (file-name-nondirectory buffer-file-name)))
                                      (format "latexmk" file)
                                      ))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-command "latexmk")
 '(package-selected-packages
   '(yaml-mode nov markdown-mode cmake-mode web-server poker gited chess bluetooth bibretrieve biblio)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )




;; SyncTex/AUCTeX

;(load "auctex.el" nil t t)

; SyncTeX basics

; un-urlify and urlify-escape-only should be improved to handle all special characters, not only spaces.
; The fix for spaces is based on the first comment on http://emacswiki.org/emacs/AUCTeX#toc20

(defun un-urlify (fname-or-url)
  "Transform file:///absolute/path from Gnome into /absolute/path with very limited support for special characters"
  (if (string= (substring fname-or-url 0 8) "file:///")
      (url-unhex-string (substring fname-or-url 7))
    fname-or-url))

(defun urlify-escape-only (path)
  "Handle special characters for urlify"
  (replace-regexp-in-string " " "%20" path))

(defun urlify (absolute-path)
  "Transform /absolute/path to file:///absolute/path for Gnome with very limited support for special characters"
  (if (string= (substring absolute-path 0 1) "/")
      (concat "file://" (urlify-escape-only absolute-path))
      absolute-path))


; SyncTeX backward search - based on http://emacswiki.org/emacs/AUCTeX#toc20, reproduced on https://tex.stackexchange.com/a/49840/21017

(defun th-evince-sync (file linecol &rest ignored)
  (let* ((fname (un-urlify file))
         (line (car linecol))
         (col (cadr linecol))
	 (bufname (buffer-file-name)))
    (when (string= fname bufname)
      (goto-line line))))

;;       (unless (= col -1)
;;         (move-to-column col)
;;	 )
    

(defvar *dbus-evince-signal* nil)

(defun enable-evince-sync ()
  (require 'dbus)
  (unless *dbus-evince-signal*
    (setf *dbus-evince-signal*
          (dbus-register-signal
           :session nil "/org/gnome/evince/Window/0"
           "org.gnome.evince.Window" "SyncSource"
           'th-evince-sync))))



(add-hook 'LaTeX-mode-hook 'enable-evince-sync)


; SyncTeX forward search - based on https://tex.stackexchange.com/a/46157

;; universal time, need by evince
(defun utime ()
  (let ((high (nth 0 (current-time)))
        (low (nth 1 (current-time))))
   (+ (* high (lsh 1 16) ) low)))

;; Forward search.
;; Adapted from http://dud.inf.tu-dresden.de/~ben/evince_synctex.tar.gz
(defun auctex-evince-forward-sync (pdffile texfile line)
  (let ((dbus-name
     (dbus-call-method :session
               "org.gnome.evince.Daemon"  ; service
               "/org/gnome/evince/Daemon" ; path
               "org.gnome.evince.Daemon"  ; interface
               "FindDocument"
               (urlify pdffile)
	       nil     ; Do NOT open a new window
;;               t     ; Open a new window if the file is not opened.
               )))
    (unless (string= dbus-name "")
    (dbus-call-method :session
          dbus-name
          "/org/gnome/evince/Window/0"
          "org.gnome.evince.Window"
          "SyncView"
          (urlify-escape-only texfile)
          (list :struct :int32 line :int32 1)
  (utime)))))

(defun auctex-evince-view ()
  (let ((pdf (file-truename (concat default-directory
                    (TeX-master-file (TeX-output-extension)))))
    (tex (buffer-file-name))
    (line (line-number-at-pos)))
    (auctex-evince-forward-sync pdf tex line)))

;; New view entry: Evince via D-bus.
(setq TeX-view-program-list '())
(add-to-list 'TeX-view-program-list
         '("EvinceDbus" auctex-evince-view))

;; Prepend Evince via D-bus to program selection list
;; overriding other settings for PDF viewing.
(setq TeX-view-program-selection '())
(add-to-list 'TeX-view-program-selection
         '(output-pdf "EvinceDbus"))


;; for editing encrypted files
(require 'epa-file)
(epa-file-enable)


;; prevent silly initial splash screen
(setq inhibit-splash-screen t)

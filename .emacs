;;;; load additional modes from .emacs.d/ directory
;;;; NC for Kivy syntax
(add-to-list 'load-path "~/.emacs.d/kivy/")
;;;; NC for Robot Framework highlighting, available at https://github.com/sakari/robot-mode
(add-to-list 'load-path "~/.emacs.d/robot/")



;;;; enable wheel mouse
(mouse-wheel-mode t)

;;;; NC additional commands ---- START
(defun uniquify-all-lines-region (start end)
    "Find duplicate lines in region START to END keeping first occurrence."
    (interactive "*r")
    (save-excursion
      (let ((end (copy-marker end)))
        (while
            (progn
              (goto-char start)
              (re-search-forward "^\\(.*\\)\n\\(\\(.*\n\\)*\\)\\1\n" end t))
          (replace-match "\\1\n\\2")))))
  
  (defun uniquify-all-lines-buffer ()
    "Delete duplicate lines in buffer and keep first occurrence."
    (interactive "*")
    (uniquify-all-lines-region (point-min) (point-max)))

;; use shift to move around windows
(windmove-default-keybindings 'shift)
(show-paren-mode t)
 ; Turn beep off
(setq visible-bell nil)

;; ;; Python mode settings START

;; Requisites: Emacs >= 24
(require 'package)
(package-initialize)

;; (add-to-list 'package-archives
;; 	     '("melpa" . "http://melpa.milkbox.net/packages/"))
;; (add-to-list 'package-archives
;; 	     '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; (package-refresh-contents)

(defun install-if-needed (package)
  (unless (package-installed-p package)
    (package-install package)))

;; make more packages available with the package installer
(setq to-install
      '(python-mode magit yasnippet jedi auto-complete autopair find-file-in-repository flycheck))

(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(setq py-electric-colon-active t)
(add-hook 'python-mode-hook 'autopair-mode)
(add-hook 'python-mode-hook 'yas-minor-mode)

;; ;; Jedi settings
(require 'jedi)
;; It's also required to run "pip install --user jedi" and "pip
;; install --user epc" to get the Python side of the library work
;; correctly.
;; With the same interpreter you're using.

;; if you need to change your python intepreter, if you want to change it
;; (setq jedi:server-command
;;       '("python2" "/home/andrea/.emacs.d/elpa/jedi-0.1.2/jediepcserver.py"))

(add-hook 'python-mode-hook
	  (lambda ()
	    (jedi:setup)
	    (jedi:ac-setup)
            (local-set-key "\C-cd" 'jedi:show-doc)
            (local-set-key (kbd "M-SPC") 'jedi:complete)
            (local-set-key (kbd "M-.") 'jedi:goto-definition)))


(add-hook 'python-mode-hook 'auto-complete-mode)

(ido-mode t)
;; ;; END Python settings
;;;; NC additional commands ---- END

;;;; Conformiq styles
(setq super-tab-idle-enabled nil)
;;(setq cq-elisp-path "/home/ncankar/conformiq/elisp")
(setq cq-default-author "Niko Cankar")
(setq cq-default-email "niko@cankar.org")

;; Conformiq coding style 
(defconst cq-java-style
  '((c-basic-offset . 4)
    (c-comment-only-line-offset 0 . 0)
    (c-hanging-comment-starter-p)
    (c-offsets-alist (inline-open . 0)
             (defun-open . 0)
             (substatement-open . 0)))
  "Conformiq Style")

(defun cq-java-mode-hook ()
  "Register cq-java-style"
  (c-add-style "java" cq-java-style t)
  (flyspell-prog-mode)
  (auto-fill-mode 1)
  (setq fill-column 79)
  (c-toggle-hungry-state 0)
  (make-local-variable 'local-write-file-hooks)
  (add-hook 'local-write-file-hooks 'untabify-buffer)
  (add-hook 'local-write-file-hooks 'delete-trailing-whitespace))

(add-hook 'java-mode-hook 'cq-java-mode-hook)

;; Opening a file with suffix .cql puts the editor by default to CQL
;; mode.
(if (not (assoc "\\.cql$" auto-mode-alist))
    (setq auto-mode-alist
	  (cons (cons "\\.cql$" 'cql-mode)
		auto-mode-alist)))

(if (not (assoc "\\.cqa$" auto-mode-alist))
    (setq auto-mode-alist
	  (cons (cons "\\.cqa$" 'java-mode)
		auto-mode-alist)))

;; Simple hook.
(setq cql-mode-hook 'cql-entry)

(defun cql-entry ()
  (font-lock-mode)
  (setq fill-column 79))
;; end Conformiq coding style


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(current-language-environment "Latin-1")
 '(default-input-method "latin-1-prefix")
 '(global-font-lock-mode t nil (font-lock))
 '(inhibit-startup-screen t)
 '(show-paren-mode t nil (paren)))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "gray" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

;; make ääkköset work..
(set-input-mode (car (current-input-mode))
		(nth 1 (current-input-mode))
		'accept-8bit-input)



(put 'downcase-region 'disabled nil)

;; support for Kivy *.kv files
(require 'kivy-mode)
(add-to-list 'auto-mode-alist '("\\.kv$" . kivy-mode))

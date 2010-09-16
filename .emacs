;;;; Macros ;;;;
;; Are we running XEmacs or Emacs?
(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

;; Some simple macros to more easily tell if we're running GNUEmacs or XEmacs
;; taken from the .emacs of sukria@online.fr | http://sukria.online.fr
(defmacro GNUEmacs (&rest x)
  (list 'if (not running-xemacs) (cons 'progn x)))
(defmacro XEmacs (&rest x)
  (list 'if running-xemacs (cons 'progn x)))
(defmacro Xlaunch (&rest x)
  (list 'if (eq window-system 'x) (cons 'progn x)))
;;;; /Macros ;;;;

(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/jdee/lisp"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/cedet/common"))
(load-file (expand-file-name "~/.emacs.d/site-lisp/cedet/common/cedet.el"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/elib"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/ecb"))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/lua-mode"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/textmate"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/smart-tab"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/js2-mode"))
;; Common lisp compatibility
(require 'cl)
(require 'generic-x)
(require 'ecb)
;;(require 'go-mode)
(require 'lua-mode)
(require 'textmate)
(require 'smart-tab)
(require 'js2-mode)
;;(require 'magit)
;;(require 'package)

(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files")

(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))

(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda ()
             (inf-ruby-keys)))
;; If you have Emacs 19.2x or older, use rubydb2x
(autoload 'rubydb "rubydb3x" "Ruby debugger" t)
;; uncomment the next line if you want syntax highlighting
(add-hook 'ruby-mode-hook 'turn-on-font-lock)

;; Rinari
;;(require 'rinari)


;; If you want Emacs to defer loading the JDE until you open a 
;; Java file, edit the following line
(setq defer-loading-jde nil)
;; to read:
;;
;;  (setq defer-loading-jde t)
;;

(if defer-loading-jde
    (progn
      (autoload 'jde-mode "jde" "JDE mode." t)
      (setq auto-mode-alist
	    (append
	     '(("\\.java\\'" . jde-mode))
	     auto-mode-alist))
      )
  (require 'jde))

(eval-after-load "jde"
  '(progn
     (setq jde-web-brower "Chrome")
     )
)
;; "y or n" instead of "yes or no"
(fset 'yes-or-no-p 'y-or-n-p)

;; Highlight regions and add special behaviors to regions.
;; "C-h d transient" for more info
(setq transient-mark-mode t)

(set-background-color "black")
(set-face-background 'default "black")
(set-face-background 'region "black")
(set-face-foreground 'default "white")
(set-face-foreground 'region "gray60")
(set-foreground-color "white")
(set-cursor-color "red")

(add-to-list 'load-path "~/.emacs.d/site-lisp/plugins")
;; Scala Mode

(let ((path "~/.emacs.d/site-lisp/scala-mode"))
  (setq load-path (cons path load-path))
  (load "scala-mode-auto.el"))

(defun scala-turnoff-indent-tabs-mode ()
  (setq indent-tabs-mode nil))

(load "~/.emacs.d/site-lisp/plugins/sbt.el")
;; scala mode hooks
(add-hook 'scala-mode-hook 'scala-turnoff-indent-tabs-mode)

;; YASNIPPIT


(require 'yasnippet-bundle)
(yas/initialize)
(yas/load-directory "~/.emacs.d/site-lisp/plugins")
(setq yas/root-directory "~/.emacs.d/snippets")

(setq smart-tab-using-hippie-expand t)
(setq hippie-expand-try-functions-list
      '(yas/hippie-try-expand
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name
        try-complete-lisp-symbol))
(global-smart-tab-mode 1)

(setq my-modes
  '(("\\.bashrc"  . sh-mode)
    ("\\.js"      . js2-mode)
    ("\\.yml"     . yaml-mode)
    ("\\.spde"    . scala-mode)
    ("\\.clj"     . clojure-mode)
    ("\\.textile" . textile-mode)
;;     ("\\.sml"     . tuareg-mode)
;;    ("\\.sig"     . tuareg-mode)
;;    ("\\.ml"      . tuareg-mode)
    ("\\.rb"      . ruby-mode)
    ("\\.pp"      . ruby-mode)
    ("Capfile"    . ruby-mode)
    ("capfile"    . ruby-mode)
    ("\\.lua"     . lua-mode)
;;    ("\\.f$"      . forth-mode)
    ))

(mapc (lambda (item)
        (add-to-list 'auto-mode-alist item))
      my-modes)

;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir "~/.emacs_autosaves/")

(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
   (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
    (expand-file-name
     (concat "#%" (buffer-name) "#")))))


(eval-after-load 'esh-opt
  '(progn
     (require 'em-prompt)
     (require 'em-term)
     (require 'em-cmpl)
     (setenv "PAGER" "cat")
     (set-face-attribute 'eshell-prompt nil :foreground "turquoise1")
     (when (< emacs-major-version 23)
       (add-hook 'eshell-mode-hook ;; for some reason this needs to be a hook
                 '(lambda () (define-key eshell-mode-map "\C-a" 'eshell-bol)))
       (add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color))

     ;; TODO: submit these via M-x report-emacs-bug
     (add-to-list 'eshell-visual-commands "ssh")
     (add-to-list 'eshell-visual-commands "tail")
     (add-to-list 'eshell-command-completions-alist
                  '("gunzip" "gz\\'"))
     (add-to-list 'eshell-command-completions-alist
                  '("tar" "\\(\\.tar|\\.tgz\\|\\.tar\\.gz\\)\\'"))))

;; ido-mode is like magic pixie dust!
(when (> emacs-major-version 21)
  (ido-mode t)
  (setq ido-enable-prefix nil
        ido-enable-flex-matching t
        ido-create-new-buffer 'always
        ido-use-filename-at-point 'guess
        ido-max-prospects 10))

;; Font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; Use regex searches by default.
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "\C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; Jump to a definition in the current file. (This is awesome.)
(global-set-key (kbd "C-x C-i") 'ido-imenu)

;; File finding
(global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)
(global-set-key (kbd "C-x C-M-f") 'find-file-in-project)
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)
(global-set-key (kbd "C-c y") 'bury-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "M-`") 'file-cache-minibuffer-complete)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Window switching. (C-x o goes to the next window)
(windmove-default-keybindings) ;; Shift+direction
(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1))) ;; back one
(global-set-key (kbd "C-x C-o") (lambda () (interactive) (other-window 2))) ;; forward two


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

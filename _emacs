;;;;;;;;;;;;; VI MODE ;;;;;;;;;;;;;;
; Use vi mode.  Remove this line for plain emacs.
(setq term-setup-hook 'vip-mode)

; Hide because dangerous in vi mode
(global-unset-key "\e\e")

; Turn off binding of colon to eval
(put 'eval-expression 'disabled nil) 

; Interferes with input mode switching, alas
;(global-unset-key (kbd "C-SPC"))

;;;;;;;;;;;;;;;;;;; MINOR CONVENIENCES ;;;;;;;;;;;;;;;
; Show line and column numbers on status line
(setq line-number-mode t)
(setq column-number-mode t)

; Show time 
(display-time)

; Find line number
(global-set-key   "\M-g"   'goto-line)

; used for Rmail in ordinary emacs, to save message
(global-set-key "\C-o" 'rmail-output)

; If at beginning of a line, don't make me C-k twice.
(setq kill-whole-line t)

; Enable color in console mode
(global-font-lock-mode)

;;;;;;;;;  SPLIT WINDOWS ;;;;;;;;;;;;;;;;
; Easier way to change size of split windows
(global-set-key "\C-r" 'shrink-window)
(global-set-key "\C-v" 'enlarge-window)

; jump between windows
(defun other-window-backward (&optional n)
  "Select Nth previous window."
  (interactive "P")
  (other-window (- (prefix-numeric-value n))))
(global-set-key "\C-x\C-n" 'other-window)
(global-set-key "\C-x\C-p" 'other-window-backward)

; Add directory where I put my elisp code to front of load path.
;(setq load-path (append (list nil "~/lib/emacs/lisp") load-path))

;;;;;;;;;   TAGS  ;;;;;;;;;;;;;;;;
; (visit-tags-table "~/TAGS" ) ; this will load TAGS up front (can be slow)
; Load the TAGS file first time it is required.
(defvar loaded-tags-already nil "keep track of whether TAGS was loaded" )
(defadvice find-tag (before load-tag-file-if-necessary 
          activate compile )
  "Load default TAGS file from home directory if needed"
  (if (not loaded-tags-already) 
      (progn (visit-tags-table "~/TAGS" ) (setq loaded-tags-already t ))))

;;;;;;;;;;;; FILE MODES AND HIGHLIGHTING ;;;;;;;;;;
; Perl mode
(setq auto-mode-alist
      (append '(("\\.pl$" . perl-mode)
    ("\\.pm$" . perl-mode)
    ("\\.perl$" . perl-mode)
    ) auto-mode-alist))

; text mode, avoid nroff mode
(setq auto-mode-alist
      (append '(("\\.txt$" . text-mode)
    ("\\.me$" . text-mode)
    ) auto-mode-alist))


; Enable Highlighting of Code, comments
(cond (window-system
         (setq hilit-mode-enable-list  '(not text-mode)
         hilit-background-mode   'dark
         hilit-inhibit-hooks     nil
         hilit-inhibit-rebinding nil
         hilit-auto-highlight t
         hilit-face-check t
         hilit-auto-rehighlight 50
   )
)

; java mode
(add-hook
 'java-mode-hook
 (function
  (lambda ()
    (setq c-auto-newline nil
    c-basic-offset 2
    c-continued-statement-offset 4
    c-continued-brace-offset 0
    c-brace-offset 0
    c-brace-imaginary-offset 0
    c-argdecl-indent 2
    c-label-offset -2))))

; C mode.
(add-hook
 'c-mode-hook
 (function
  (lambda ()
    (setq c-auto-newline nil
    c-indent-level 2
    c-basic-offset 2
    c-continued-statement-offset 4
    c-continued-brace-offset 0
    c-brace-offset 0
    c-brace-imaginary-offset 0
    c-argdecl-indent 2
    c-label-offset -2)
    (define-key c-mode-map "\C-m" 'reindent-then-newline-and-indent))))

; Use C++ mode for all .C and .h files.
(setq auto-mode-alist
      (append '(("\\.C$" . c++-mode)
    ("\\.c$" . c++-mode)
    ("\\.cpp$" . c++-mode)
    ("\\.h$" . c++-mode)
    ) auto-mode-alist))

; Use my html hilighting for xml and pwflow
(setq auto-mode-alist (cons '("\\.xml$" . html-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pwflow$" . html-mode) auto-mode-alist))

; Lisp-mode for promax menus
(autoload 'lisp-mode "lisp-mode")
(setq auto-mode-alist (cons '("\\.menu$" . lisp-mode) auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set default appearance
(cond (window-system
      (set-default-font 
       "-adobe-courier-bold-r-normal--18-180-75-75-m-110-*-*")
      ;;    "-adobe-courier-bold-r-normal--18-*-iso8859-1")
      (setq baud-rate 153600) ; speed scrolling
      (transient-mark-mode 1) ; good for X highlighting
      (setq default-frame-alist '((height . 36) (width . 80))) ; frame size
      (menu-bar-mode 1) ; menus
      (set-background-color "black")
      (set-foreground-color "white")
      (set-border-color "white")
      (set-face-background 'region "lightgray")
      (set-face-foreground 'region "black")
      (set-face-background 'modeline "white")
      (set-face-foreground 'modeline "black")
      (set-face-background 'highlight "red")
      (set-face-foreground 'highlight "black")
      (set-face-background 'secondary-selection "cyan")
      (set-face-foreground 'secondary-selection "black")
      (set-cursor-color "white")
      (set-mouse-color "white")
      ;(setq x-pointer-shape x-pointer-left-ptr)
      ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



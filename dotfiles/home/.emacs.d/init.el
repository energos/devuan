;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PREFERENCES

;; font
(set-frame-font "Hack 10" nil t)

;; resize initial frame to 1/2 screen width
;; temporary ugly hack
(sleep-for 0.1)
(set-frame-width nil (if (= (default-font-width) 11) 173 146))
(set-frame-parameter nil 'energos/width 10)

(desktop-save-mode)                     ; restore desktop, except
(setq desktop-restore-frames nil)       ; for window and frame configuration
(savehist-mode)                         ; preserve minibuffer history
(recentf-mode)                          ; show recent files
(save-place-mode)                       ; remember last cursor position

(setq inhibit-startup-screen t)         ; disable 'splash screen'
(setq initial-buffer-choice t)          ; show *scratch* buffer at startup

(scroll-bar-mode -1)                    ; disable 'scrollbar'
(menu-bar-mode -1)                      ; disable 'menu'
(tool-bar-mode -1)                      ; disable 'tool-bar'
(tooltip-mode -1)                       ; disable 'tooltips'
(blink-cursor-mode -1)                  ; NON blinking cursor
(setq visible-cursor nil)               ; less annoying console cursor
(line-number-mode)                      ; display line number in 'mode-line'
(column-number-mode)                    ; display column number in 'mode-line'
(show-paren-mode)                       ; visualize matching parens

(setq frame-resize-pixelwise nil)       ; whole character frame resize
(setq-default truncate-lines nil)       ; wrap lines longer than the window width
(setq truncate-partial-width-windows 40)        ; except in "narrow" windows

(setq save-interprogram-paste-before-kill t)    ; ???
(delete-selection-mode)                 ; replace selection with typed text

(winner-mode)                           ; undo/redo window configuration

(prefer-coding-system 'utf-8-unix)      ; UTF-8, no crlf, please
(defalias 'yes-or-no-p 'y-or-n-p)       ; ask for "y or n"
(setq confirm-nonexistent-file-or-buffer t)     ; confirm file/buffer creation
(setq large-file-warning-threshold 100000000)   ; big file warning

(setq scroll-step 1)                    ; one line vertical scroll
(setq scroll-preserve-screen-position t); keep cursor position on PgUp/PgDown,
(setq scroll-error-top-bottom t)        ; except on first and last pages
(setq hscroll-step 1)                   ; one character horizontal scroll,
(setq hscroll-margin 0)                 ; on window edges

;; ediff: no control frame, side by side windows
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)

;; prefer horizontal split (side-by-side)
(setq split-width-threshold 128)
(setq split-height-threshold nil)

;; --- Enable some disabled commands ---
;; https://www.emacswiki.org/emacs/DisabledCommands
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; --- Do not expire passwords - DANGER! ---
(setq password-cache-expiry nil)
;; --- Do not save passwords ---
(setq auth-source-save-behavior nil)

;; --- Freaking TAB behaviour
(setq-default tab-always-indent 'complete)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq backward-delete-char-untabify-method nil)
;; TAB starts symbol completion in programming modes
(add-hook
 'prog-mode-hook
 (lambda ()
   (local-set-key (kbd "<tab>") #'indent-for-tab-command)))
(electric-indent-mode -1)

;; --- Initial message ---
(let ((command "fortune"))
  (if (executable-find command)
      (setq initial-scratch-message
            (let ((string "")
                  (list (split-string (shell-command-to-string command) "\n")))
              (dolist (line list)
                (setq string (concat string
                                     ";;"
                                     (if (= 0 (length line)) "" "  ")
                                     line
                                     "\n")))
              string))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LOCAL elisp FILES

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; framemove
;; https://github.com/emacsmirror/framemove
(require 'framemove)
(setq framemove-hook-into-windmove t)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGES
(add-to-list 'package-archives
             '("melpa-stbl" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa"      . "https://melpa.org/packages/") t)
(setq package-archive-priorities
      '(("melpa-stbl" .  0)
        ("gnu"        .  5)
        ("melpa"      . 10)))
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; pdf-tools
;; https://github.com/vedang/pdf-tools
(require 'pdf-tools)
(bind-keys :map pdf-view-mode-map
           ("<home>"   . image-bob)
           ("<end>"    . image-eob)
           ("<C-home>" . pdf-view-first-page)
           ("<C-end>"  . pdf-view-last-page))
(pdf-tools-install)
(setq-default pdf-view-display-size 'fit-page)
;; (setq pdf-view-midnight-colors '("#eaeaea" . "#181a26"))

;; It's Magit!
;; https://magit.vc/
;; https://github.com/magit/magit
(require 'magit)
(bind-keys ("C-x g"         . magit-status)
           ("H-m"           . magit-status)
           :map magit-hunk-section-map
           ("<return>"      . magit-diff-visit-file-other-window)
           ("<S-return>"    . magit-diff-visit-file)
           :map magit-mode-map
           ("<M-tab>"       . nil)
           :map magit-section-mode-map
           ("<M-tab>"       . nil))
;; https://magit.vc/manual/magit/The-mode_002dline-information-isn_0027t-always-up_002dto_002ddate.html
(setq auto-revert-check-vc-info t)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; THEMES

;; themes from the packages repository:
(use-package afternoon-theme    :defer t)

;; hand picked themes:
;; https://github.com/emacs-jp/replace-colorthemes
;; Please set your themes directory to 'custom-theme-load-path
(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))

;; choose one of them:
;; (load-theme 'charcoal-black t t)
;; (enable-theme 'charcoal-black)
(load-theme 'afternoon t t)
(enable-theme 'afternoon)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DEFUNs

;; https://www.emacswiki.org/emacs/NavigatingParentheses
(defun goto-match-paren ()
  "Go to the matching parenthesis if on parenthesis.
Else go to the opening parenthesis one level up."
  (interactive)
  (cond ((looking-at "\\s\(") (forward-list 1))
        (t
         (backward-char 1)
         (cond ((looking-at "\\s\)")
                (forward-char 1) (backward-list 1))
               (t
                (while (not (looking-at "\\s("))
                  (backward-char 1)
                  (cond ((looking-at "\\s\)")
                         (message "->> )")
                         (forward-char 1)
                         (backward-list 1)
                         (backward-char 1)))
                  ))))))

;; http://emacsblog.org/2007/01/17/indent-whole-buffer/
;; indent whole buffer, remove trailing spaces
(defun iwb ()
  "Indent whole buffer."
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(defun energos/inc-or-dec (n max &optional dec)
  "Increment or decrement N, limiting the result to the interval 0≤N≤MAX.
If DEC is t:             Return N-1 if 0<N≤MAX, 0 if N≤0, MAX if N>MAX.
If DEC is nil or absent: Return N+1 if 0≤N<MAX, 0 if N<0, MAX if N≥MAX."
  (or (integerp n) (setq n 0))                ; must be an integer
  (setq n (or (and dec (1- n)) (1+ n)))       ; increment or decrement
  (or (and (< n 0) 0) (and (> n max) max) n)) ; limit to the valid range

(defun energos/resize-frame (&optional dec)
  "If DEC is t, decrease current frame size, else increase current frame size."
  (interactive "P")
  (let* ((list11 [64 75 86 97 108 118 129 140 151 162 173 184 195 206 217 228 238 249 260 271 282 293 304 315 326 337 347])
         (list13 [54 63 72 82  91 100 109 119 128 137 146 156 165 174 183 192 202 211 220 230 239 248 257 266 276 285 294])
         (list (if (= (default-font-width) 11) list11 list13))
         (n (frame-parameter nil 'energos/width))
         (i (energos/inc-or-dec (if (integerp n) n 4) (1- (length list)) dec))
         (width (aref list i)))
    (set-frame-parameter nil 'energos/width i)
    (set-frame-width nil width)
    (message (format "Frame width resized to %d characters" width))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; KEYBOARD SHORTCUTS

;; --- Use hippie-expand instead of dabbrev-expand ---
(global-set-key (kbd "M-/") 'hippie-expand)

;; --- We don't need a freaking mouse wheel ---
(mouse-wheel-mode -1)
(global-set-key (kbd "<mouse-4>") 'ignore)
(global-set-key (kbd "<mouse-5>") 'ignore)
(global-set-key (kbd "<wheel-up>") 'ignore)
(global-set-key (kbd "<wheel-down>") 'ignore)

;; --- Translate Caps_Lock (via xmodmap) -> F13 -> Hyper ---
(global-set-key (kbd "<f13>") 'ignore)
(define-key key-translation-map (kbd "<f13>") 'event-apply-hyper-modifier)

(global-set-key (kbd "C-z") 'undo)

(global-set-key (kbd "C-<up>") (lambda () (interactive) (scroll-down 1)))
(global-set-key (kbd "C-<down>") (lambda () (interactive) (scroll-up 1)))
(global-set-key (kbd "C-<left>") (lambda () (interactive) (scroll-right 1)))
(global-set-key (kbd "C-<right>") (lambda () (interactive) (scroll-left 1)))

(global-set-key (kbd "M-<up>")
                (lambda () (interactive) (scroll-other-window-down 1)))
(global-set-key (kbd "M-<down>")
                (lambda () (interactive) (scroll-other-window 1)))

(windmove-default-keybindings 'hyper)

(global-set-key (kbd "<f12>") 'toggle-truncate-lines)

(global-set-key (kbd "C-<prior>")
                (lambda () (interactive) (move-to-window-line 0)))
(global-set-key (kbd "C-<next>")
                (lambda () (interactive) (move-to-window-line -1)))

(global-set-key (kbd "C-<tab>")
                (lambda (arg) "Insert TAB." (interactive "p") (insert-tab arg)))

;; https://www.emacswiki.org/emacs/SearchAtPoint
(global-set-key (kbd "M-b") (lambda (arg) "\
Move point to the previous position that is the beggining of a symbol."
                              (interactive "p") (forward-symbol (- arg))))
(global-set-key (kbd "M-f") 'forward-symbol)

(global-set-key (kbd "C-S-s") 'isearch-forward-symbol-at-point)

(global-set-key (kbd "C-c C-o") 'browse-url-at-point)
(setq browse-url-browser-function 'browse-url-xdg-open)

(global-set-key (kbd "M-]") 'goto-match-paren)

;; --- Mostrar arquivo correspondente ao buffer ---
(global-set-key (kbd "S-<f12>")
                (lambda () "Show current buffer file path."
                  (interactive)
                  (or (message buffer-file-name)
                      (message "This buffer is not a file!"))))

;; --- Recarregar buffer ---
(global-set-key (kbd "<f5>")
                (lambda () "Reload buffer from disk if modified."
                  (interactive)
                  (revert-buffer t (not (buffer-modified-p)) t)))

;; --- Frame resize ---
(global-set-key (kbd "<f11>") 'energos/resize-frame)
(global-set-key (kbd "S-<f11>")
                (lambda () (interactive) (energos/resize-frame t)))
(global-set-key (kbd "M-<f11>") 'toggle-frame-fullscreen)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; AREA 51

(let ((file (expand-file-name "experimental.el" user-emacs-directory)))
  (when (file-exists-p file)
    (load file)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; START SERVER!

(require 'server)
;; ~/bin/emacs-git needs to know which server to connect to
(setenv "EMACS_SERVER" server-name)
(unless (server-running-p)
  (server-start))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOMIZE
;; Keep this file free from customize data

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (with-temp-buffer (write-file custom-file)))
(load custom-file)

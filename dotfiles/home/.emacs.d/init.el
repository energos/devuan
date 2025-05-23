;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PREFERENCES

;; Override default font defined in ~/.Xresources
;; (set-frame-font "Hack 10" nil t)
;; (set-frame-font "Iosevka Term 10" nil t)

;; resize initial frame to 1/2 screen width
;; temporary ugly hack
(sleep-for 0.1)
(if (= (default-font-width) 11)
    (progn (set-frame-width nil 173)
           (set-frame-parameter nil 'energos/width 10))
  (set-frame-width nil 137)
  (set-frame-parameter nil 'energos/width 9))

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

;; ediff: no control frame, side by side windows, skip 'irrelevant' differences
(with-eval-after-load 'ediff
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq-default ediff-ignore-similar-regions t)
  )

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

;; --- webjump ---
(setq webjump-sites
      '(
        ("Emacs Home Page"      . "https://www.gnu.org/software/emacs/")
        ("Awesome Emacs"        . "https://github.com/emacs-tw/awesome-emacs")
        ("Emacs Wiki"           . "https://www.emacswiki.org")
        ("The other Emacs Wiki" . "https://wikemacs.org")
        ("Emacs Rocks!"         . "https://emacsrocks.com/")
        ("It's Magit!"          . "https://magit.vc/")
        ("Devuan Home Page"     . "https://www.devuan.org/")
        ("Devuan Forum"         . "https://dev1galaxy.org/")
        ("Devuan Packages"      . "https://pkginfo.devuan.org/")
        ("Common Lisp"          . "https://lisp-lang.org/")
        ("Awesome Common Lisp"  . "https://github.com/CodyReichert/awesome-cl")
        ))
(global-set-key (kbd "H-w") 'webjump)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LOCAL elisp FILES

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; framemove
;; https://github.com/emacsmirror/framemove
(require 'framemove)
(setq framemove-hook-into-windmove t)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGES
(require 'package)
(add-to-list 'package-archives
             '("melpa-stbl" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa"      . "https://melpa.org/packages/") t)
(setq package-archive-priorities
      '(("melpa-stbl" .  0)
        ("gnu"        .  5)
        ("melpa"      . 10)))
(package-initialize)

;; use-package
;; https://jwiegley.github.io/use-package/keywords/
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; which-key
;; included in Emacs version >= 30
(setq which-key-idle-delay 3.0)
(which-key-mode)

;; It's Magit!
;; https://magit.vc/
;; https://github.com/magit/magit
(use-package magit
  :hook ((magit-mode . (lambda () (setq truncate-lines nil))))
  :bind (("C-x g"      . magit-status)
         ("H-m"        . magit-status)
         :map magit-hunk-section-map
         ("<return>"   . magit-diff-visit-file-other-window)
         ("<S-return>" . magit-diff-visit-file)
         :map magit-mode-map
         ("<M-tab>"    . nil)
         :map magit-section-mode-map
         ("<M-tab>"    . nil))
  :init
  ;; https://magit.vc/manual/magit/The-mode_002dline-information-isn_0027t-always-up_002dto_002ddate.html
  (setq auto-revert-check-vc-info t))

;; expand-region
;; https://github.com/magnars/expand-region.el
(use-package expand-region
  :bind (("C-=" . er/expand-region)))

;; vertico
;; https://github.com/minad/vertico
(use-package vertico
  :custom
  (vertico-count 20)
  :config
  (vertico-mode))

;; orderless
;; https://github.com/oantolin/orderless
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))
                                   (eglot (styles orderless basic))
                                   (unicode-name (styles orderless basic substring)))))

;; marginalia
;; https://github.com/minad/marginalia
(use-package marginalia
  :config
  (marginalia-mode))

;; consult
;; https://github.com/minad/consult
(use-package consult
  :bind (("M-i"     . consult-line)
         ("M-y"     . consult-yank-from-kill-ring)
         ("C-x B"   . switch-to-buffer)
         ("C-x b"   . consult-buffer)
         ("H-b"     . consult-buffer)
         :map consult-narrow-map
         ("C-h"     . consult-narrow-help))
  :config
  ;; disable previews
  (consult-customize
   consult-buffer :preview-key nil)

  ;; <hack>
  ;; Shorten recent files in consult-buffer
  ;; https://github.com/minad/consult/wiki#shorten-recent-files-in-consult-buffer

  (defun my-consult--source-recentf-items-uniq ()
    (let ((ht (consult--buffer-file-hash))
          file-name-handler-alist ;; No Tramp slowdown please.
          items)
      (dolist (file (my-recentf-list-uniq) (nreverse items))
        ;; Emacs 29 abbreviates file paths by default, see
        ;; `recentf-filename-handlers'.
        (unless (eq (aref (cdr file) 0) ?/)
          (setcdr file (expand-file-name (cdr file))))
        (unless (gethash (cdr file) ht)
          (push (propertize
                 (car file)
                 'multi-category `(file . ,(cdr file)))
                items)))))

  (plist-put consult--source-recent-file
             :items #'my-consult--source-recentf-items-uniq)

  (defun my-recentf-list-uniq ()
    (let* ((proposed (mapcar (lambda (f)
                               (cons (file-name-nondirectory f) f))
                             recentf-list))
           (recentf-uniq proposed)
           conflicts resol file)
      ;; collect conflicts
      (while proposed
        (setq file (pop proposed))
        (if (assoc (car file) conflicts)
            (push (cdr file) (cdr (assoc (car file) conflicts)))
          (if (assoc (car file) proposed)
              (push (list (car file) (cdr file)) conflicts))))
      ;; resolve conflicts
      (dolist (name conflicts)
        (let* ((files (mapcar (lambda (f)
                                ;; (file remaining-path curr-propos)
                                (list f
                                      (file-name-directory f)
                                      (file-name-nondirectory f)))
                              (cdr name)))
               (curr-step (mapcar (lambda (f)
                                    (file-name-nondirectory
                                     (directory-file-name (cadr f))))
                                  files)))
          ;; Quick check, if there are no duplicates, we are done.
          (if (eq (length curr-step) (length (delete-dups curr-step)))
              (setq resol
                    (append resol
                            (mapcar (lambda (f)
                                      (cons (car f)
                                            (file-name-concat
                                             (file-name-nondirectory
                                              (directory-file-name (cadr f)))
                                             (file-name-nondirectory (car f)))))
                                    files)))
            (while files
              (let (files-remain)
                (dolist (file files)
                  (let ((curr-propos (caddr file))
                        (curr-part (file-name-nondirectory
                                    (directory-file-name (cadr file))))
                        (rest-path (file-name-directory
                                    (directory-file-name (cadr file))))
                        (curr-step
                         (mapcar (lambda (f)
                                   (file-name-nondirectory
                                    (directory-file-name (cadr f))))
                                 files)))
                    (if (member curr-part (cdr (member curr-part curr-step)))
                        ;; There is more than one curr-part in curr-step for
                        ;; this candidate.
                        (push (list (car file)
                                    rest-path
                                    (file-name-concat curr-part curr-propos))
                              files-remain)
                      ;; There is no repetition of curr-part in curr-step
                      ;; for this candidate.
                      (push (cons (car file)
                                  (file-name-concat curr-part curr-propos))
                            resol))))
                (setq files files-remain))))))
      ;; apply resolved conflicts
      (let (items)
        (dolist (file recentf-uniq (nreverse items))
          (let ((curr-resol (assoc (cdr file) resol)))
            (if curr-resol
                (push (cons (cdr curr-resol) (cdr file)) items)
              (push file items)))))))
  ;; </hack>
  )

;; corfu
;; https://github.com/minad/corfu
;; https://github.com/minad/corfu/blob/main/extensions/corfu-popupinfo.el
(use-package corfu
  ;; Optional customizations
  :custom
  ;; (corfu-cycle t)                  ;; Enable cycling for `corfu-next/previous'
  (corfu-auto nil)                    ;; Disable auto completion
  (corfu-separator ?\s)               ;; Orderless field separator
  (corfu-quit-at-boundary nil)        ;; Never quit at completion boundary
  (corfu-quit-no-match 'separator)    ;; Quit if there is no match and no separator
  ;; (corfu-preview-current nil)      ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)        ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)       ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)          ;; Use scroll margin
  :bind (:map corfu-map ("M-SPC" . corfu-insert-separator))
  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))
  ;;
  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since Dabbrev can be used globally (M-/).
  ;; See also 'corfu-excluded-modes'.
  :config
  (global-corfu-mode))

;; embark
;; https://github.com/oantolin/embark
(use-package embark
  :bind
  (("C-."     . embark-act)         ;; pick some comfortable binding
   ("H-."     . embark-act)
   ("C-;"     . embark-dwim)        ;; good alternative: M-.
   ("H-<f13>" . embark-dwim)
   ("C-h B"   . embark-bindings))   ;; alternative for 'describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (setq embark-cycle-key "C-.")
  ;; https://github.com/oantolin/embark#quitting-the-minibuffer-after-an-action
  ;; (setq embark-quit-after-action nil)
  (setq embark-quit-after-action '((kill-buffer . nil) (t . t)))
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; eglot
(require 'eglot)
;; https://clangd.llvm.org/installation#editor-plugins
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(add-hook 'c-ts-mode-hook #'eglot-ensure)
(add-hook 'c++-ts-mode-hook #'eglot-ensure)
(add-hook 'python-ts-mode-hook #'eglot-ensure)
(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (setq-local eldoc-echo-area-use-multiline-p nil)
            (eldoc-mode 1)))
(setq eglot-ignored-server-capabilities '(:documentHighlightProvider))

;; tree-sitter
(setq major-mode-remap-alist
      '(
        ;; (bash-mode   . bash-ts-mode)
        (c-mode      . c-ts-mode)
        (c++-mode    . c++-ts-mode)
        (python-mode . python-ts-mode)
        ))

;; flymake
(with-eval-after-load 'flymake
  (setq python-flymake-command "pyflakes3")
  (setq flymake-mode-line-lighter "")
  (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)
  (define-key flymake-mode-map (kbd "M-f") 'consult-flymake)
  )

;; pdf-tools
;; https://github.com/vedang/pdf-tools
(use-package pdf-tools
  :demand t
  :bind (:map pdf-view-mode-map
              ("<home>"   . image-bob)
              ("<end>"    . image-eob)
              ("<C-home>" . pdf-view-first-page)
              ("<C-end>"  . pdf-view-last-page))
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  ;; (setq pdf-view-midnight-colors '("#eaeaea" . "#181a26"))
  )

;; calibredb
;; https://github.com/chenyanming/calibredb.el
(use-package calibredb
  :demand t
  :config
  (require 'consult)
  (setq calibredb-root-dir "~/Library")
  (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
  (setq calibredb-library-alist '(("~/Library")))
  (setq calibredb-date-width 0))

;; vterm
;; https://github.com/akermu/emacs-libvterm
;; https://packages.gentoo.org/packages/app-emacs/vterm
(use-package vterm
  :config
  (setq vterm-min-window-width 54)
  (setq vterm-clear-scrollback-when-clearing t))

;; nerd-icons
;; https://github.com/rainstormstudio/nerd-icons.el
(use-package nerd-icons
  ;; :custom
  ;; The Nerd Font you want to use in GUI
  ;; https://www.nerdfonts.com/
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  ;; (nerd-icons-font-family "Symbols Nerd Font Mono")
  )

;; sly
;; https://github.com/joaotavora/sly
(use-package sly
  :defer t
  :config
  (setq inferior-lisp-program (executable-find "sbcl")
        org-babel-lisp-eval-fn #'sly-eval
        sly-symbol-completion-mode nil
        sly-mrepl-pop-sylvester nil)
  :bind (:map sly-mode-map
              ("H-<f13>" . sly-eval-last-expression)
              ("H-r"     . (lambda () (interactive)
                             (sly-mrepl-clear-repl)
                             (sleep-for 0.1)
                             (sly-restart-inferior-lisp)))))

;; auctex
(use-package auctex
  :defer t
  :config
  ;; (setq font-latex-fontify-script nil)
  (setq font-latex-fontify-sectioning 1.05)
  (setq TeX-engine 'xetex)
  (setq TeX-view-program-selection
        '((output-pdf "PDF Viewer")))
  (setq TeX-view-program-list
        '(("PDF Viewer" "okular --unique %o"))))

;; ebuku
;; https://github.com/flexibeast/ebuku
(use-package ebuku)

;; D Language
(use-package d-mode)

;; Tcl Language
(setq tcl-application "tclsh")
(defun tcl-eval-line()
  "Send the current region or line to the inferior Tcl process."
  (interactive)
  (unless (use-region-p)
    (push-mark (line-end-position))
    (goto-char (line-beginning-position))
    (setq mark-active t))
  (tcl-eval-region (region-beginning) (region-end))
  (deactivate-mark)
  )
(with-eval-after-load 'tcl
  (define-key tcl-mode-map (kbd "H-<f13>") 'tcl-eval-line))

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
;; increase selected line visibility in vertico
(set-face-attribute 'highlight nil :background "#294F6E")
;; https://github.com/ozanmakes/emacs-afternoon-theme/issues/1
(set-face-attribute 'mode-line nil :family 'unspecified)
;; https://www.gonsie.com/blorg/modeline.html
;; https://www.colorhexa.com/181a26-to-3366aa
(and t
     (let ((active   "#284673")
           (inactive "#1f2d47")
           (width    2))
       (set-face-attribute 'mode-line nil
                           :background active
                           :box `(:line-width ,width :color ,active))
       (set-face-attribute 'mode-line-inactive nil
                           :background inactive
                           :box `(:line-width ,width :color ,inactive))))

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

;; --- Symbol highlighting ---
;; https://stackoverflow.com/questions/23891638/emacs-highlight-symbol-in-multiple-windows
(require 'hi-lock)
(defun unhighlight ()
  "Unhighlight all."
  (interactive)
  (unhighlight-regexp t))

(defun unhighlight-all-windows ()
  "Unhighlight all in all windows."
  (interactive)
  (save-selected-window
    (cl-dolist (x (window-list))
      (select-window x)
      (unhighlight-regexp t))))

(defun highlight-symbol ()
  "Highlight symbol at point."
  (interactive)
  (let* ((regexp (hi-lock-regexp-okay (find-tag-default-as-symbol-regexp)))
         (hi-lock-auto-select-face t)
         (face (hi-lock-read-face-name)))
    (highlight-regexp regexp face)))

(defun unhighlight-symbol ()
  "Unhighlight symbol at point."
  (interactive)
  (let ((regexp (hi-lock-regexp-okay (find-tag-default-as-symbol-regexp))))
    (unhighlight-regexp regexp)))

(defun highlight-symbol-all-windows ()
  "Highlight symbol at point in all windows."
  (interactive)
  (let* ((regexp (hi-lock-regexp-okay (find-tag-default-as-symbol-regexp)))
         (hi-lock-auto-select-face t)
         (face (hi-lock-read-face-name)))
    (save-selected-window
      (cl-dolist (x (window-list))
        (select-window x)
        (highlight-regexp regexp face)))))

(defun unhighlight-symbol-all-windows ()
  "Highlight symbol at point in all windows."
  (interactive)
  (let ((regexp (hi-lock-regexp-okay (find-tag-default-as-symbol-regexp))))
    (save-selected-window
      (cl-dolist (x (window-list))
        (select-window x)
        (unhighlight-regexp regexp)))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ORG-MODE

;; --- preferences ---
(setq org-replace-disputed-keys t)

;; --- restore old shortcuts for structure templates ---
;; https://orgmode.org/manual/Structure-Templates.html
(require 'org-tempo)

;; --- org-babel ---
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (shell . t)
   (emacs-lisp . t)
   (C . t)
   (tcl . t)
   (python . t)
   (forth . t)
   (julia . t)
   (lisp . t)
   (forth . t)
   ))

;; --- DANGER! ---
;; Evaluate code without prompting
;; https://orgmode.org/manual/Code-Evaluation-Security.html
;; --- DANGER! ---
(setq org-confirm-babel-evaluate
      (lambda (lang body)
        (not (or
              ;; t                        ; ask nothing
              (string= lang "elisp")
              (string= lang "C")
              (string= lang "D")
              (string= lang "tcl")
              (string= lang "bash")
              (string= lang "python")
              (string= lang "julia")
              (string= lang "lisp")
              (string= lang "forth")
              ))))

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

;; --- Symbol highlighting ---
(global-set-key (kbd "H-H") 'highlight-symbol-all-windows)
(global-set-key (kbd "H-h") 'highlight-symbol)

(global-set-key (kbd "H-U") 'unhighlight-symbol-all-windows)
(global-set-key (kbd "H-u") 'unhighlight-symbol)

(global-set-key (kbd "H-A") 'unhighlight-all-windows)
(global-set-key (kbd "H-a") 'unhighlight)

;; --- Frequently used files ---
(global-set-key (kbd "\e\ei") (lambda () (interactive) (find-file (expand-file-name "init.el" user-emacs-directory))))
(global-set-key (kbd "\e\es") (lambda () (interactive) (switch-to-buffer "*scratch*")))

;; --- Insert key ---
;; I keep accidentally hitting that damn key
(global-set-key (kbd "<insert>") (lambda () (interactive) (overwrite-mode -1)))
(global-set-key (kbd "H-<insert>") 'overwrite-mode)

;; --- Kill buffers ---
(global-set-key (kbd "C-x k") 'kill-buffer)
(global-set-key (kbd "C-x K") 'kill-current-buffer)
(global-set-key (kbd "H-k") 'kill-buffer)
(global-set-key (kbd "H-K") 'kill-current-buffer)
;; Never kill *scratch* or *Messages*
(with-current-buffer "*scratch*"
  (emacs-lock-mode 'kill))
(with-current-buffer "*Messages*"
  (emacs-lock-mode 'kill))

;; --- find/save/exit ---
(global-set-key (kbd "H-s") 'save-buffer)
(global-set-key (kbd "H-f") 'find-file)
(global-set-key (kbd "H-Q") 'save-buffers-kill-terminal)

;; -- frames/windows --
(global-set-key (kbd "H-n") 'make-frame-command)
(global-set-key (kbd "H-0")
                (lambda () "Delete window or delete frame if there is only one window."
                  (interactive)
                  (if (one-window-p)
                      (delete-frame)
                    (delete-window))))
(global-set-key (kbd "H-1") 'delete-other-windows)
(global-set-key (kbd "H-2") 'split-window-below)
(global-set-key (kbd "H-3") 'split-window-horizontally)

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

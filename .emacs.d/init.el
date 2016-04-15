;;
;; 基本設定
;;

;; ロードパスの追加
;(add-to-list 'load-path "~/.emacs.d")

;; 起動時の画面はいらない
(setq inhibit-startup-message t)

;; Localeに合わせた環境の設定
(set-locale-environment nil)
;; 日本語環境
(set-language-environment 'Japanese)
;; 極力UTF-8とする
(prefer-coding-system 'utf-8)

;; キーバインド
(define-key global-map (kbd "M-?") 'help-for-help)        ; ヘルプ
(define-key global-map (kbd "C-z") 'undo)                 ; undo
(define-key global-map (kbd "C-c i") 'indent-region)      ; インデント
(define-key global-map (kbd "M-/") 'hippie-expand)    ; 補完
(define-key global-map (kbd "C-/") 'comment-dwim)       ; コメントアウト
(define-key global-map (kbd "M-C-g") 'grep)               ; grep
;(define-key global-map (kbd "C-[ M-C-g") 'goto-line)      ; 指定行へ移動
(define-key global-map (kbd "S-<f5>") 'revert-buffer)

;; バーを消す
(menu-bar-mode 1)
(tool-bar-mode -1)

;; カーソルの点滅を止める
(blink-cursor-mode 0)

;; 対応する括弧を光らせる。
(show-paren-mode 1)
;; ウィンドウ内に収まらないときだけ括弧内も光らせる。
(setq show-paren-style 'mixed)

;; 空白や長すぎる行を視覚化する。
(require 'whitespace)
;; 1行が80桁を超えたら長すぎると判断する。
(setq whitespace-line-column 80)
(setq whitespace-style '(face              ; faceを使って視覚化する。
                         trailing          ; 行末の空白を対象とする。
                         lines-tail        ; 長すぎる行のうち
                                           ; whitespace-line-column以降のみを
                                           ; 対象とする。
                         space-before-tab  ; タブの前にあるスペースを対象とする。
                         space-after-tab)) ; タブの後にあるスペースを対象とする。
;; デフォルトで視覚化を有効にする。
(global-whitespace-mode 1)

;;; 現在行を目立たせる
(global-hl-line-mode)

;;; カーソルの位置が何文字目かを表示する
(column-number-mode t)

;;; カーソルの位置が何行目かを表示する
(line-number-mode t)

;;; カーソルの場所を保存する
(require 'saveplace)
(setq-default save-place t)

;;; 行の先頭でC-kを一回押すだけで行全体を消去する
(setq kill-whole-line t)

;;; 最終行に必ず一行挿入する
(setq require-final-newline t)

;;; バッファの最後でnewlineで新規行を追加するのを禁止する
(setq next-line-add-newlines nil)

;; #* というバックアップファイルを作らない
(setq auto-save-default nil)

;; *.~ というバックアップファイルを作らない
(setq make-backup-files nil)

;;; バックアップファイルを作らない
(setq backup-inhibited t)

;;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)

;;; 履歴数を大きくする
(setq history-length 10000)

;;; ミニバッファの履歴を保存する
(savehist-mode 1)

;;; 最近開いたファイルを保存する数を増やす
(setq recentf-max-saved-items 10000)

;; 全てのバッファを削除
(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))
(global-set-key (kbd "C-x K") 'close-all-buffers)

;; ディレクトリを1階層ごと上がる
(defun my-minibuffer-delete-parent-directory ()
  "Delete one level of file path."
  (interactive)
  (let ((current-pt (point)))
    (when (re-search-backward "/[^/]+/?" nil t)
      (forward-char 1)
      (delete-region (point) current-pt))))
(define-key minibuffer-local-map (kbd "M-^") 'my-minibuffer-delete-parent-directory)

;; font
;(create-fontset-from-ascii-font "Ricty-14:weight=normal:slant=normal" nil "ricty")
;(set-fontset-font "fontset-ricty"
;                  'unicode
;                  (font-spec :family "Ricty" :size 14)
;                  nil
;                  'append)
;(add-to-list 'default-frame-alist '(font . "fontset-ricty"))

;; yes to y
(defalias 'yes-or-no-p 'y-or-n-p)

;;
;; package
;;
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(require 'cl)
(defvar installing-package-list
  '(
    ;; ここに使いたいパッケージを書く
    anything
    anything-config
    auto-complete
    hlinum
    magit
    magit-gitflow
    js2-mode
    php-mode
    python
    python-mode
    py-autopep8
;    python-django
;    flymake
;    flymake-cursor
    rainbow-delimiters
;    zen-coding
    zenburn-theme
    ))

(let ((not-installed (loop for x in installing-package-list
                            when (not (package-installed-p x))
                            collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
        (package-install pkg))))

;;
;; anything
;;
(require 'anything)
(require 'anything-config)
(require 'anything-match-plugin)
(setq anything-sources (list anything-c-source-buffers
anything-c-source-bookmarks
anything-c-source-recentf
anything-c-source-file-name-history
anything-c-source-locate))
(define-key anything-map (kbd "C-p") 'anything-previous-line)
(define-key anything-map (kbd "C-n") 'anything-next-line)
(define-key anything-map (kbd "C-v") 'anything-next-source)
(define-key anything-map (kbd "M-v") 'anything-previous-source)
(setq my-anything-keybind (kbd "C-]"))
(global-set-key my-anything-keybind 'anything-for-files)
(define-key anything-map my-anything-keybind 'abort-recursive-edit)

;;
;; auto-complete
;;
(require 'auto-complete)
(global-auto-complete-mode t)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-20131128.233/dict")
(require 'auto-complete-config)
(ac-config-default)
;; C-n/C-pで候補選択
(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)

;; hlinum
(require 'hlinum)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-linum-mode t)
 '(safe-local-variable-values (quote ((python-shell-completion-string-code . "';'.join(get_ipython().Completer.all_completions('''%s'''))
") (python-shell-completion-module-string-code . "';'.join(module_completion('''%s'''))
") (python-shell-completion-setup-code . "from IPython.core.completerlib import module_completion") (python-shell-interpreter-args . "~/Documents/workspace/menjo/src/menjo/manage.py shell") (python-shell-interpreter . "python")))))

;; javascript
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; php
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))

;; python
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))


;; python-django
(global-set-key (kbd "C-x j") 'python-django-open-project)


;; rainbow-delimiters
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; version controll
;; Ediff Control Panelを同じフレーム内に表示する(筆者のスクリーンショットと同じ)
;(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; 差分を横に分割して表示する
;(setq ediff-split-window-function 'split-window-horizontally)
;; 余計なバッファを(確認して)削除する
;(setq ediff-keep-variants nil)
;; 追加された行は緑で表示
;(set-face-attribute 'diff-added nil
;                    :foreground "white" :background "dark green")
;; 削除された行は赤で表示
;(set-face-attribute 'diff-removed nil
;                    :foreground "white" :background "dark red")
;; 文字単位での変更箇所は色を反転して強調
;(set-face-attribute 'diff-refine-change nil
;                    :foreground nil :background nil
;                    :weight 'bold :inverse-video t)
;; diffを表示したらすぐに文字単位での強調表示も行う
;(defun diff-mode-refine-automatically ()
;  (diff-auto-refine-mode t))
;(add-hook 'diff-mode-hook 'diff-mode-refine-automatically)

;; zen-coding
;(add-hook 'sgml-mode-hook 'zencoding-mode)

;; zenburn
(load-theme 'zenburn t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; pep8
;; http://qiita.com/fujimisakari/items/74e32eddb78dff4be585
(require 'py-autopep8)
;(define-key python-mode-map (kbd "C-c F") 'py-autopep8)          ; バッファ全体のコード整形
;(define-key python-mode-map (kbd "C-c f") 'py-autopep8-region)   ; 選択リジョン内のコード整形

;; 保存時にバッファ全体を自動整形する
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

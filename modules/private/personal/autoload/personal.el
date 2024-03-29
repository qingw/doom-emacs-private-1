;;; +functions.el -*- lexical-binding: t; -*-
;;;###autoload
(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))


;; from @bmag spacemacs
;;;###autoload
(defun doom/window-layout-toggle ()
  "Toggle between horizontal and vertical layout of two windows."
  (interactive)
  (if (= (count-windows) 2)
    (let* ((window-tree (car (window-tree)))
           (current-split-vertical-p (car window-tree))
           (first-window (nth 2 window-tree))
           (second-window (nth 3 window-tree))
           (second-window-state (window-state-get second-window))
           (splitter (if current-split-vertical-p
                         #'split-window-horizontally
                       #'split-window-vertically)))
      (delete-other-windows first-window)
      ;; `window-state-put' also re-selects the window if needed, so we don't
      ;; need to call `select-window'
      (window-state-put second-window-state (funcall splitter)))
    (error "Can't toggle window layout when the number of windows isn't two.")))

;;;###autoload
(defun doom/swiper-region-or-symbol ()
  "Run `swiper' with the selected region or the symbol
around point as the initial input."
  (interactive)
  (let ((input (if (region-active-p)
                   (buffer-substring-no-properties
                    (region-beginning) (region-end))
                 (thing-at-point 'symbol t))))
    (swiper input)))

;;;###autoload
(defun doom/swiper-all-region-or-symbol ()
  "Run `swiper-all' with the selected region or the symbol
around point as the initial input."
  (interactive)
  (let ((input (if (region-active-p)
                   (buffer-substring-no-properties
                    (region-beginning) (region-end))
                 (thing-at-point 'symbol t))))
    (swiper-all input)))

;;;###autoload
(defun doom/counsel-region-or-symbol ()
  "Run `counsel-ag' with the selected region or the symbol
around point as the initial input."
  (interactive)
  (let ((input (if (region-active-p)
                   (buffer-substring-no-properties
                    (region-beginning) (region-end))
                 (thing-at-point 'symbol t))))
    (counsel-ag input)))


;; Configure network proxy
(defvar proxy-server "127.0.0.1:8123")
;; (defvar proxy-server "127.0.0.1:1080")
(defvar socks-server '("Default server" "127.0.0.1" 1080 5))

;;;###autoload
(defun show-proxy ()
  "Show http/https proxy."
  (interactive)
  (if url-proxy-services
      (message "Current proxy is \"%s\"" proxy-server)
    (message "No proxy")))

;;;###autoload
(defun set-proxy ()
  "Set http/https proxy."
  (interactive)
  (setq url-proxy-services `(("http" . ,proxy-server)
                             ("https" . ,proxy-server)))
  (show-proxy))

;;;###autoload
(defun unset-proxy ()
  "Unset http/https proxy."
  (interactive)
  (setq url-proxy-services nil)
  (show-proxy))

;;;###autoload
(defun toggle-proxy ()
  "Toggle http/https proxy."
  (interactive)
  (if url-proxy-services
      (unset-proxy)
    (set-proxy)))

;; from http://stackoverflow.com/questions/9656311/conflict-resolution-with-emacs-ediff-how-can-i-take-the-changes-of-both-version
;;;###autoload
(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))

;;;###autoload
;; Dos2Unix/Unix2Dos
(defun dos2unix ()
  "Convert the current buffer to UNIX file format."
  (interactive)
  (set-buffer-file-coding-system 'undecided-unix nil))

;;;###autoload
(defun unix2dos ()
  "Convert the current buffer to DOS file format."
  (interactive)
  (set-buffer-file-coding-system 'undecided-dos nil))


;;;###autoload
(defun insert-key-then-command (key)
  "Ask for a key then insert its description.
Will work on both org-mode and any mode that accepts plain html."
  (interactive "kType key sequence: ")
  (let* ((orgp (derived-mode-p 'org-mode))
         (tag (if orgp "~%s~" "<kbd>%s</kbd>")))
    (insert (format tag (help-key-description key nil)))
    (kill-new  (symbol-name (cadr (help--analyze-key key nil))))
    (forward-char (if orgp -1 -6))))


;;;###autoload
(defun my-find-url (url)
  "Download URL and insert into current buffer at point."
  (interactive "sULR: ")
  (insert (my-url-retrieve url)))

(defun my-url-retrieve (url &optional no-headers)
  "Retrieve and return as string the content of URL.

If NO-HEADERS is non-nil, remove the HTTP headers first."
  (with-current-buffer (url-retrieve-synchronously url)
    (when no-headers
      (goto-char (point-min))
      (search-forward "\n\n")
      (delete-region (point-min) (point)))
    (prog1 (buffer-string)
      (kill-buffer))))

;;;###autoload
(defun my-insert-date-iso (date)
  "Insert timestamp."
  (interactive (list (org-read-date)))
  (insert date))

;;;###autoload
(defun my-md5-file (filename)
  "Open FILENAME, load it into a buffer and generate the md5 of its contents"
  (interactive "f")
  (with-temp-buffer
    (insert-file-contents filename)
    (let ((hash (md5 (current-buffer))))
      (when (called-interactively-p 'interactive)
        (message hash))
      hash)))


;;;###autoload
(defun create-scratch-buffer-current-mode ()
  "Create a new scratch buffer to work in and set its mode to current `major-mode'."
  (interactive)
  (create-scratch-buffer major-mode))

;;;###autoload
(defun save-macro (name)
    "save a macro. Take a name as argument
     and save the last defined macro under
     this name at the end of your .emacs"
     (interactive "SName of the macro :")  ; ask for the name of the macro
     (name-last-kbd-macro name)            ; use this name for the macro
     (find-file user-init-file)            ; open ~/.emacs or other user init file
     (goto-char (point-max))               ; go to the end of the .emacs
     (newline)                             ; insert a newline
     (insert-kbd-macro name)               ; copy the macro
     (newline)                             ; insert a newline
     (switch-to-buffer nil))               ; return to the initial buffer


;;;###autoload
(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: "
                                      (file-name-directory filename)
                                      (file-name-nondirectory filename)
                                      nil
                                      (file-name-nondirectory filename))))
        (cond ((get-buffer new-name)
               (error "A buffer named '%s' already exists!" new-name))
              (t
               (rename-file filename new-name 1)
               (rename-buffer new-name)
               (set-visited-file-name new-name)
               (set-buffer-modified-p nil)
               (message "File '%s' successfully renamed to '%s'" name (file-name-nondirectory new-name))))))))

;;;###autoload
(defun delete-current-buffer-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (ido-kill-buffer)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

;;;###autoload
(defun cleanup-buffer-safe ()
  "Perform a bunch of safe operations on the whitespace content of a buffer.
Does not indent buffer, because it is used for a before-save-hook, and that
might be bad."
  (interactive)
  ;;(let ((m-m major-mode))
  ;;(fundamental-mode)
  (untabify-buffer)
  (delete-trailing-whitespace)
  (set-buffer-file-coding-system 'utf-8)
  ;;(funcall m-m)
  ;;)
  )

;;;###autoload
(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Including indent-buffer, which should not be called automatically on save."
  (interactive)
  (cleanup-buffer-safe)
  (indent-buffer))

;;;###autoload
(defun toggle-mode-line-to-header ()
  "toggles the modeline to header"
  (interactive)
  (setq mode-line-format
        (if (equal mode-line-format nil)
            (progn
              (setq header-line-format (default-value 'header-line-format))
              (default-value 'mode-line-format))
          (let ((hlf header-line-format))
            (setq header-line-format mode-line-format)
            hlf)))
  (redraw-display))


(defun sk/toggle-letter-case ()
  "Toggle the letter case of current word or text selection.
Toggles from 3 cases: UPPER CASE, lower case, Title Case,
in that cyclic order."
  (interactive)
  (let (pos1 pos2 (deactivate-mark nil) (case-fold-search nil))
    (if (and transient-mark-mode mark-active)
        (setq pos1 (region-beginning)
              pos2 (region-end))
      (setq pos1 (car (bounds-of-thing-at-point 'word))
            pos2 (cdr (bounds-of-thing-at-point 'word))))

    (when (not (eq last-command this-command))
      (save-excursion
        (goto-char pos1)
        (cond
         ((looking-at "[[:lower:]][[:lower:]]") (put this-command 'state
                                                     "all lower"))
         ((looking-at "[[:upper:]][[:upper:]]") (put this-command 'state
                                                     "all caps") )
         ((looking-at "[[:upper:]][[:lower:]]") (put this-command 'state
                                                     "init caps") )
         (t (put this-command 'state "all lower") ))))

    (cond
     ((string= "all lower" (get this-command 'state))
      (upcase-initials-region pos1 pos2) (put this-command 'state "init caps"))
     ((string= "init caps" (get this-command 'state))
      (upcase-region pos1 pos2) (put this-command 'state "all caps"))
     ((string= "all caps" (get this-command 'state))
      (downcase-region pos1 pos2) (put this-command 'state "all lower")))))


(defun sk/replace-next-underscore-with-camel (arg)
  (interactive "p")
  (if (> arg 0)
 (setq arg (1+ arg))) ; 1-based index to get eternal loop with 0
  (let ((case-fold-search nil))
    (while (not (= arg 1))
      (search-forward-regexp "\\b_[a-z]")
      (forward-char -2)
      (delete-char 1)
      (capitalize-word 1)
      (setq arg (1- arg)))))


;;;###autoload
(defun +my-workspace/goto-main-window (pname frame)
    (let ((window (car (+my-doom-visible-windows))))
      (if (window-live-p window)
          (select-window window))))

;;;###autoload
(defun +my-doom-visible-windows (&optional window-list)
  "Return a list of the visible, non-popup windows."
  (cl-loop for window in (or window-list (window-list))
           unless (window-dedicated-p window)
           collect window))

;;;###autoload
(defun xah-convert-english-chinese-punctuation (@begin @end &optional @to-direction)
  "Convert punctuation from/to English/Chinese characters.

When called interactively, do current line or selection. The conversion direction is automatically determined.

If `universal-argument' is called, ask user for change direction.

When called in lisp code, *begin *end are region begin/end positions. *to-direction must be any of the following values: 「\"chinese\"」, 「\"english\"」, 「\"auto\"」.

See also: `xah-remove-punctuation-trailing-redundant-space'.

URL `http://ergoemacs.org/emacs/elisp_convert_chinese_punctuation.html'
Version 2015-10-05"
  (interactive
   (let ($p1 $p2)
     (if (use-region-p)
         (progn
           (setq $p1 (region-beginning))
           (setq $p2 (region-end)))
       (progn
         (setq $p1 (line-beginning-position))
         (setq $p2 (line-end-position))))
     (list
      $p1
      $p2
      (if current-prefix-arg
          (ido-completing-read
           "Change to: "
           '( "english"  "chinese")
           "PREDICATE"
           "REQUIRE-MATCH")
        "auto"
        ))))
  (let (
        ($input-str (buffer-substring-no-properties @begin @end))
        ($replacePairs
         [
          [". " "。"]
          [".\n" "。\n"]
          [", " "，"]
          [",\n" "，\n"]
          [": " "："]
          ["; " "；"]
          ["? " "？"] ; no space after
          ["! " "！"]

          ;; for inside HTML
          [".</" "。</"]
          ["?</" "？</"]
          [":</" "：</"]
          [" " "　"]
          ]
         ))

    (when (string= @to-direction "auto")
      (setq
       @to-direction
       (if
           (or
            (string-match "　" $input-str)
            (string-match "。" $input-str)
            (string-match "，" $input-str)
            (string-match "？" $input-str)
            (string-match "！" $input-str))
           "english"
         "chinese")))
    (save-excursion
      (save-restriction
        (narrow-to-region @begin @end)
        (mapc
         (lambda ($x)
           (progn
             (goto-char (point-min))
             (while (search-forward (aref $x 0) nil "noerror")
               (replace-match (aref $x 1)))))
         (cond
          ((string= @to-direction "chinese") $replacePairs)
          ((string= @to-direction "english") (mapcar (lambda (x) (vector (elt x 1) (elt x 0))) $replacePairs))
          (t (user-error "Your 3rd argument 「%s」 isn't valid" @to-direction))))))))

;;;###autoload
(defun xah-remove-punctuation-trailing-redundant-space (@begin @end)
  "Remove redundant whitespace after punctuation.
Works on current line or text selection.

When called in emacs lisp code, the *begin *end are cursor positions for region.

See also `xah-convert-english-chinese-punctuation'.

URL `http://ergoemacs.org/emacs/elisp_convert_chinese_punctuation.html'
version 2015-08-22"
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-end-position))))
  (require 'xah-replace-pairs)
  (xah-replace-regexp-pairs-region
   @begin @end
   [
    ;; clean up. Remove extra space.
    [" +," ","]
    [",  +" ", "]
    ["?  +" "? "]
    ["!  +" "! "]
    ["\\.  +" ". "]

    ;; fullwidth punctuations
    ["， +" "，"]
    ["。 +" "。"]
    ["： +" "："]
    ["？ +" "？"]
    ["； +" "；"]
    ["！ +" "！"]
    ["、 +" "、"]
    ]
   "FIXEDCASE" "LITERAL"))


;;;###autoload
(defun xah-convert-fullwidth-chars (@begin @end &optional @to-direction)
  "Convert ASCII chars to/from Unicode fullwidth version.
Works on current line or text selection.

The conversion direction is determined like this: if the command has been repeated, then toggle. Else, always do to-Unicode direction.

If `universal-argument' is called first:

 no C-u → Automatic.
 C-u → to ASCII
 C-u 1 → to ASCII
 C-u 2 → to Unicode

When called in lisp code, @begin @end are region begin/end positions. @to-direction must be any of the following values: 「\"unicode\"」, 「\"ascii\"」, 「\"auto\"」.

See also: `xah-remove-punctuation-trailing-redundant-space'.

URL `http://ergoemacs.org/emacs/elisp_convert_chinese_punctuation.html'
Version 2018-06-04"
  (interactive
   (let ($p1 $p2)
     (if (use-region-p)
         (progn
           (setq $p1 (region-beginning))
           (setq $p2 (region-end)))
       (progn
         (setq $p1 (line-beginning-position))
         (setq $p2 (line-end-position))))
     (list $p1 $p2
           (cond
            ((equal current-prefix-arg nil) "auto")
            ((equal current-prefix-arg '(4)) "ascii")
            ((equal current-prefix-arg 1) "ascii")
            ((equal current-prefix-arg 2) "unicode")
            (t "unicode")))))
  (let* (
         ($ascii-unicode-map
          [
           ["0" "０"] ["1" "１"] ["2" "２"] ["3" "３"] ["4" "４"] ["5" "５"] ["6" "６"] ["7" "７"] ["8" "８"] ["9" "９"]
           ["A" "Ａ"] ["B" "Ｂ"] ["C" "Ｃ"] ["D" "Ｄ"] ["E" "Ｅ"] ["F" "Ｆ"] ["G" "Ｇ"] ["H" "Ｈ"] ["I" "Ｉ"] ["J" "Ｊ"] ["K" "Ｋ"] ["L" "Ｌ"] ["M" "Ｍ"] ["N" "Ｎ"] ["O" "Ｏ"] ["P" "Ｐ"] ["Q" "Ｑ"] ["R" "Ｒ"] ["S" "Ｓ"] ["T" "Ｔ"] ["U" "Ｕ"] ["V" "Ｖ"] ["W" "Ｗ"] ["X" "Ｘ"] ["Y" "Ｙ"] ["Z" "Ｚ"]
           ["a" "ａ"] ["b" "ｂ"] ["c" "ｃ"] ["d" "ｄ"] ["e" "ｅ"] ["f" "ｆ"] ["g" "ｇ"] ["h" "ｈ"] ["i" "ｉ"] ["j" "ｊ"] ["k" "ｋ"] ["l" "ｌ"] ["m" "ｍ"] ["n" "ｎ"] ["o" "ｏ"] ["p" "ｐ"] ["q" "ｑ"] ["r" "ｒ"] ["s" "ｓ"] ["t" "ｔ"] ["u" "ｕ"] ["v" "ｖ"] ["w" "ｗ"] ["x" "ｘ"] ["y" "ｙ"] ["z" "ｚ"]
           ["," "，"] ["." "．"] [":" "："] [";" "；"] ["!" "！"] ["?" "？"] ["\"" "＂"] ["'" "＇"] ["`" "｀"] ["^" "＾"] ["~" "～"] ["¯" "￣"] ["_" "＿"]
           [" " "　"]
           ["&" "＆"] ["@" "＠"] ["#" "＃"] ["%" "％"] ["+" "＋"] ["-" "－"] ["*" "＊"] ["=" "＝"] ["<" "＜"] [">" "＞"] ["(" "（"] [")" "）"] ["[" "［"] ["]" "］"] ["{" "｛"] ["}" "｝"] ["(" "｟"] [")" "｠"] ["|" "｜"] ["¦" "￤"] ["/" "／"] ["\\" "＼"] ["¬" "￢"] ["$" "＄"] ["£" "￡"] ["¢" "￠"] ["₩" "￦"] ["¥" "￥"]
           ]
          )
         ($reverse-map
          (mapcar
           (lambda (x) (vector (elt x 1) (elt x 0)))
           $ascii-unicode-map))

         ($stateBefore
          (if (get 'xah-convert-fullwidth-chars 'state)
              (get 'xah-convert-fullwidth-chars 'state)
            (progn
              (put 'xah-convert-fullwidth-chars 'state 0)
              0
              )))
         ($stateAfter (if (eq $stateBefore 0) 1 0 )))

  ;"０\\|１\\|２\\|３\\|４\\|５\\|６\\|７\\|８\\|９\\|Ａ\\|Ｂ\\|Ｃ\\|Ｄ\\|Ｅ\\|Ｆ\\|Ｇ\\|Ｈ\\|Ｉ\\|Ｊ\\|Ｋ\\|Ｌ\\|Ｍ\\|Ｎ\\|Ｏ\\|Ｐ\\|Ｑ\\|Ｒ\\|Ｓ\\|Ｔ\\|Ｕ\\|Ｖ\\|Ｗ\\|Ｘ\\|Ｙ\\|Ｚ\\|ａ\\|ｂ\\|ｃ\\|ｄ\\|ｅ\\|ｆ\\|ｇ\\|ｈ\\|ｉ\\|ｊ\\|ｋ\\|ｌ\\|ｍ\\|ｎ\\|ｏ\\|ｐ\\|ｑ\\|ｒ\\|ｓ\\|ｔ\\|ｕ\\|ｖ\\|ｗ\\|ｘ\\|ｙ\\|ｚ"

  ;(message "before %s" $stateBefore)
  ;(message "after %s" $stateAfter)
  ;(message "@to-direction %s" @to-direction)
  ;(message "real-this-command  %s" this-command)
  ;(message "real-last-command %s" last-command)

    (let ((case-fold-search nil))
      (xah-replace-pairs-region
       @begin @end
       (cond
        ((string= @to-direction "unicode") $ascii-unicode-map)
        ((string= @to-direction "ascii") $reverse-map)
        ((string= @to-direction "auto")
         (if (eq last-command this-command)
             (if (eq $stateBefore 0)
                 $reverse-map
               $ascii-unicode-map )
           $ascii-unicode-map
           ))
        (t (user-error "Your 3rd argument 「%s」 isn't valid" @to-direction)))
       t t ))
    (put 'xah-convert-fullwidth-chars 'state $stateAfter)))

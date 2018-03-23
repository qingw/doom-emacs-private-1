;;; +macros.el -*- lexical-binding: t; -*-


(defmacro my-with-every-line (&rest forms)
  "Execute FORMS on each line following point to the end of buffer."
  (declare (indent 0))
  `(progn
     (beginning-of-line)
     (while (not (eobp))
       ,@forms
       (forward-line))))

(defmacro my-with-each-line (&rest body)
  "Execute BODY on each line in buffer."
  (declare (indent 0)
           (debug (body)))
  `(save-excursion
     (goto-char (point-min))
     ,@body
     (while (= (forward-line) 0)
       ,@body)))

;; Makes ; and , the universal repeat-keys in evil-mode
(defmacro do-repeat! (command next-func prev-func)
      "Repeat motions with ;/,"
      (let ((fn-sym (intern (format "+evil*repeat-%s" command))))
        `(progn
           (defun ,fn-sym (&rest _)
             (define-key evil-motion-state-map (kbd ";") ',next-func)
             (define-key evil-motion-state-map (kbd "'") ',prev-func))
           (advice-add #',command :before #',fn-sym))))

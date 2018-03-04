;;; org.el -*- lexical-binding: t; -*-

;;;###autoload
 (defun doom/org-brain-add-resource ()
   "Add a URL from the clipboard as an org-brain resource.
 Suggest the URL title as a description for resource."
   (interactive)
   (let* ((url (org-web-tools--get-first-url))
          (html (org-web-tools--get-url url))
          (title (org-web-tools--html-title html)))
     (org-brain-add-resource
      url
      title
      t)))

;;;###autoload
(defun org-agenda-show-daily (&optional arg)
  (interactive "P")
  (org-agenda arg "a"))



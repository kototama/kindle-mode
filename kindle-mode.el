;;; kindle-mode.el --- A minor mode for the Kindle 'My Clippings.txt' file

;; Copyright 2012 Kototama

;; Authors: Kototama <kototamo gmail com>
;; Version: 0.1.0
;; Package-version: 0.1.0
;; Keywords: kindle, org-mode, annotation, clipping
;; URL: http://github.com/kototama/cljsbuild-mode

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

(require 's)

(define-minor-mode kindle-mode
  "Kindle minor mode"
  :init-value nil
  :lighter " Kindle"
  :gkeymaproup 'kindle-mode)

(defun kindle-read-line
  ()
  "Returns the content of the current line a a string"
  (save-excursion
    (beginning-of-line)
    (let ((c (point)))
      (move-end-of-line 1)
      (buffer-substring-no-properties c (point)))))


(defun kindle-read-annotation
  ()
  "Returns the current kindle annotation as a sexp (book-title, annotation).
Assumes the point in on the title's line"
  (save-excursion
    (let ((title (kindle-read-line)))
      (next-line 3)
      (let ((c (point)))
        (re-search-forward "==========" nil t)
        (previous-line 1)
        (move-end-of-line 1)
        (list title (buffer-substring-no-properties c (point)))))))

(defun kindle-move-to-next-annotation
  ()
  "Moves the point to the next annotation"
  (interactive)
  (re-search-forward "==========" nil t)
  (next-line 1)
  (beginning-of-line))

(defun kindle-extract-annotations
  ()
  "Writes all annotations to files. Each file will have the name [book_title].org."
  (interactive)
  (beginning-of-buffer)
  (while (not (= (point) (point-max)))
    (let* ((ann (kindle-read-annotation))
           (title (car ann))
           (content (cadr ann))
           (filename (s-concat (s-replace " " "_" title) ".org")))
      (find-file filename)
      (end-of-buffer)
      (insert content "\n\n")
      (switch-to-buffer nil)
      (kindle-move-to-next-annotation))))


(provide 'kindle-mode)

;;; kindle-mode.el ends here

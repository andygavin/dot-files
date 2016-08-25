;;; transform.el --- org-table transpose function

;; Copyright (C) 2016 Free Software Foundation, Inc.
;;
;; Author: Andrew Gavin <andy@tangerine.local>
;; Maintainer: Andrew Gavin <andy@tangerine.local>
;; Created: 04 May 2016
;; Version: 0.01
;; Keywords

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;;

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'transform)

;;; Code:

(eval-when-compile
  (require 'cl))

(defun orgtbl-to-sqlinsert (table params)
  ""
  (let* (hdrlist
	 (alignment (mapconcat (lambda (x) (if x "r" "l"))
			       org-table-last-alignment ""))
	 (nowebname (plist-get params :nowebname))
	 (breakvals (plist-get params :breakvals))
         (firstheader t)
         (*orgtbl-default-fmt* 'orgtbl-sql-strip-and-quote)
	 (params2
	  (list
	   :table-name (plist-get params :table-name)
	   :hfmt (lambda (f) (progn (if firstheader (push f hdrlist) "")))
	   :hlfmt (lambda (&rest cells) (setq firstheader nil))
	   :lstart (lambda () (concat "UPDATE "
				      table-name " SET "
				      (mapconcat 'identity (reverse hdrlist)
						 ", ")
				      " )" (if breakvals "\n" " ")
				      "VALUES ( "))
	   :lend " );"
	   :sep " , "
	   :hline nil
	   :remove-nil-lines t))
	 (params (org-combine-plists params2 params))
         (sqlname (plist-get params :sqlname)))
    (orgtbl-to-generic table params)))


(provide 'transform)
;;; transform.el ends here

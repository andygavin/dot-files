;;; andy-fn.el --- General helper functions looking for a home

;; Copyright (C) 2016 Free Software Foundation, Inc.
;;
;; Author: Andrew Gavin <andy@tangerine.local>
;; Maintainer: Andrew Gavin <andy@tangerine.local>
;; Created: 14 Apr 2016
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
;;   (require 'andy-fn)

;;; Code:

(eval-when-compile
  (require 'cl)
  (require 's))


(defun andy/format-xml (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (nxml-mode)
    ;; split <foo><bar> or </foo><bar>, but not <foo></foo>
    (goto-char begin)
    (while (search-forward-regexp ">[ \t]*<[^/]" end t)
      (backward-char 2) (insert "\n") (incf end))
    ;; split <foo/></foo> and </foo></foo>
    (goto-char begin)
    (while (search-forward-regexp "<.*?/.*?>[ \t]*<" end t)
      (backward-char) (insert "\n") (incf end))
    ;; put xml namespace decls on newline
    (goto-char begin)
    (while (search-forward-regexp "\\(<\\([a-zA-Z][-:A-Za-z0-9]*\\)\\|['\"]\\) \\(xmlns[=:]\\)" end t)
      (goto-char (match-end 0))
      (backward-char 6) (insert "\n") (incf end))
    (indent-region begin end nil)
    (normal-mode))
  (message "All indented!"))

(defun andy/tmp-buffer (bufname)
  "Create a temporary buffer for working based on BUFNAME."
  (interactive "sBuffer name: ")
  (let* ((buf (if (s-starts-with? "*" bufname) bufname (concat "*" bufname "*"))))
    (switch-to-buffer buf)))

(defun andy/open-buffer-path ()
  "Run explorer on the directory of the current buffer."
  (interactive)
  (shell-command (concat "explorer" (replace-regexp-in-string "/" "\\" (file-name-directory (file-buffer-name)) t t))))

(defun andy/resolve-svn (verbose)
  "Resolve a set of svn conflicts when selected in the dir view."
  (interactive "P")
  (let* ((files-state (cdr (vc-deduce-fileset nil t 'state-model-only-files)))
         (state (nth 2 files-state))
         (files (nth 1 files-state)))
    (cond
     ((eq state 'conflict)
      (vc-svn-command nil 0 files "resolved"))
     (t (message state)))
    ))
;; from http://emacs.stackexchange.com/questions/8166/encode-non-html-characters-to-html-equivalent

(setq web-mode-html-entities
  '(("quot" . 34)
     ("amp" . 38)
     ("apos" . 39)
     ("lt" . 60)
     ("gt" . 62)
     ("nbsp" . 160)
     ("iexcl" . 161)
     ("cent" . 162)
     ("pound" . 163)
     ("curren" . 164)
     ("yen" . 165)
     ("brvbar" . 166)
     ("sect" . 167)
     ("uml" . 168)
     ("copy" . 169)
     ("ordf" . 170)
     ("laquo" . 171)
     ("not" . 172)
     ("shy" . 173)
     ("reg" . 174)
     ("macr" . 175)
     ("deg" . 176)
     ("plusmn" . 177)
     ("sup2" . 178)
     ("sup3" . 179)
     ("acute" . 180)
     ("micro" . 181)
     ("para" . 182)
     ("middot" . 183)
     ("cedil" . 184)
     ("sup1" . 185)
     ("ordm" . 186)
     ("raquo" . 187)
     ("frac14" . 188)
     ("frac12" . 189)
     ("frac34" . 190)
     ("iquest" . 191)
     ("Agrave" . 192)
     ("Aacute" . 193)
     ("Acirc" . 194)
     ("Atilde" . 195)
     ("Auml" . 196)
     ("Aring" . 197)
     ("AElig" . 198)
     ("Ccedil" . 199)
     ("Egrave" . 200)
     ("Eacute" . 201)
     ("Ecirc" . 202)
     ("Euml" . 203)
     ("Igrave" . 204)
     ("Iacute" . 205)
     ("Icirc" . 206)
     ("Iuml" . 207)
     ("ETH" . 208)
     ("Ntilde" . 209)
     ("Ograve" . 210)
     ("Oacute" . 211)
     ("Ocirc" . 212)
     ("Otilde" . 213)
     ("Ouml" . 214)
     ("times" . 215)
     ("Oslash" . 216)
     ("Ugrave" . 217)
     ("Uacute" . 218)
     ("Ucirc" . 219)
     ("Uuml" . 220)
     ("Yacute" . 221)
     ("THORN" . 222)
     ("szlig" . 223)
     ("agrave" . 224)
     ("aacute" . 225)
     ("acirc" . 226)
     ("atilde" . 227)
     ("auml" . 228)
     ("aring" . 229)
     ("aelig" . 230)
     ("ccedil" . 231)
     ("egrave" . 232)
     ("eacute" . 233)
     ("ecirc" . 234)
     ("euml" . 235)
     ("igrave" . 236)
     ("iacute" . 237)
     ("icirc" . 238)
     ("iuml" . 239)
     ("eth" . 240)
     ("ntilde" . 241)
     ("ograve" . 242)
     ("oacute" . 243)
     ("ocirc" . 244)
     ("otilde" . 245)
     ("ouml" . 246)
     ("divide" . 247)
     ("oslash" . 248)
     ("Ugrave" . 249)
     ("Uacute" . 250)
     ("Ucirc" . 251)
     ("Uuml" . 252)
     ("yacute" . 253)
     ("thorn" . 254)
     ("yuml" . 255)
     ("OElig" . 338)
     ("oelig" . 339)
     ("Scaron" . 352)
     ("scaron" . 353)
     ("Yuml" . 376)
     ("fnof" . 402)
     ("circ" . 710)
     ("tilde" . 732)
     ("Alpha" . 913)
     ("Beta" . 914)
     ("Gamma" . 915)
     ("Delta" . 916)
     ("Epsilon" . 917)
     ("Zeta" . 918)
     ("Eta" . 919)
     ("Theta" . 920)
     ("Iota" . 921)
     ("Kappa" . 922)
     ("Lambda" . 923)
     ("Mu" . 924)
     ("Nu" . 925)
     ("Xi" . 926)
     ("Omicron" . 927)
     ("Pi" . 928)
     ("Rho" . 929)
     ("Sigma" . 931)
     ("Tau" . 932)
     ("Upsilon" . 933)
     ("Phi" . 934)
     ("Chi" . 935)
     ("Psi" . 936)
     ("Omega" . 937)
     ("alpha" . 945)
     ("beta" . 946)
     ("gamma" . 947)
     ("delta" . 948)
     ("epsilon" . 949)
     ("zeta" . 950)
     ("eta" . 951)
     ("theta" . 952)
     ("iota" . 953)
     ("kappa" . 954)
     ("lambda" . 955)
     ("mu" . 956)
     ("nu" . 957)
     ("xi" . 958)
     ("omicron" . 959)
     ("pi" . 960)
     ("rho" . 961)
     ("sigmaf" . 962)
     ("sigma" . 963)
     ("tau" . 964)
     ("upsilon" . 965)
     ("phi" . 966)
     ("chi" . 967)
     ("psi" . 968)
     ("omega" . 969)
     ("thetasym" . 977)
     ("Upsih" . 978)
     ("piv" . 982)
     ("ensp" . 8194)
     ("emsp" . 8195)
     ("thinsp" . 8201)
     ("zwnj" . 8204)
     ("zwj" . 8205)
     ("lrm" . 8206)
     ("rlm" . 8207)
     ("ndash" . 8211)
     ("mdash" . 8212)
     ("lsquo" . 8216)
     ("rsquo" . 8217)
     ("sbquo" . 8218)
     ("ldquo" . 8220)
     ("rdquo" . 8221)
     ("bdquo" . 8222)
     ("dagger" . 8224)
     ("Dagger" . 8225)
     ("bull" . 8226)
     ("hellip" . 8230)
     ("permil" . 8240)
     ("prime" . 8242)
     ("Prime" . 8243)
     ("lsaquo" . 8249)
     ("rsaquo" . 8250)
     ("oline" . 8254)
     ("frasl" . 8260)
     ("euro" . 8364)
     ("image" . 8465)
     ("weierp" . 8472)
     ("real" . 8476)
     ("trade" . 8482)
     ("alefsym" . 8501)
     ("larr" . 8592)
     ("uarr" . 8593)
     ("rarr" . 8594)
     ("darr" . 8595)
     ("harr" . 8596)
     ("crarr" . 8629)
     ("lArr" . 8656)
     ("UArr" . 8657)
     ("rArr" . 8658)
     ("dArr" . 8659)
     ("hArr" . 8660)
     ("forall" . 8704)
     ("part" . 8706)
     ("exist" . 8707)
     ("empty" . 8709)
     ("nabla" . 8711)
     ("isin" . 8712)
     ("notin" . 8713)
     ("ni" . 8715)
     ("prod" . 8719)
     ("sum" . 8721)
     ("minus" . 8722)
     ("lowast" . 8727)
     ("radic" . 8730)
     ("prop" . 8733)
     ("infin" . 8734)
     ("ang" . 8736)
     ("and" . 8743)
     ("or" . 8744)
     ("cap" . 8745)
     ("cup" . 8746)
     ("int" . 8747)
     ("there4" . 8756)
     ("sim" . 8764)
     ("cong" . 8773)
     ("asymp" . 8776)
     ("ne" . 8800)
     ("equiv" . 8801)
     ("le" . 8804)
     ("ge" . 8805)
     ("sub" . 8834)
     ("sup" . 8835)
     ("nsub" . 8836)
     ("sube" . 8838)
     ("supe" . 8839)
     ("oplus" . 8853)
     ("otimes" . 8855)
     ("perp" . 8869)
     ("sdot" . 8901)
     ("lceil" . 8968)
     ("rceil" . 8969)
     ("lfloor" . 8970)
     ("rfloor" . 8971)
     ("lang" . 9001)
     ("rang" . 9002)
     ("loz" . 9674)
     ("spades" . 9824)
     ("clubs" . 9827)
     ("hearts" . 9829)
     ("diams" . 9830)))

(defun my-replace-symbols-with-entity-names (start end)
  "Replace symbols with html escape in region from START to END."
  (interactive "r")
  (let ((count (count-matches "&")))
    (replace-string "&" "&amp;" nil start end)
    (setq end (+ end (* count 4))))
  (dolist (pair web-mode-html-entities)
    (unless (= (cdr pair) 38)
      (let* ((str (char-to-string (cdr pair)))
              (count (count-matches str start end)))
        (setq end (+ end (* count (1+ (length (car pair))))))
        (replace-string str
          (concat "&" (car pair) ";")
          nil start end)))))

(defun untabify-buffer ()
  "Canvienience function to untabify buffer."
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  "Canvienience function to indent buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun yas-expand-in-buffer (buffer snippet)
  "crude attempt at yas expansion of SNIPPET in BUFFER."
  (interactive "bBuffer:\nsSnippet:")
  (with-current-buffer buffer
    (insert snippet)
    (yas-expand))
  )

;;TODO COMPLETE
(defun to-java-builder (start end)
  "Convert fields in region delimited by START and END to simple builder."
  (interactive "r")
  (goto-char begin)
  (while (search-forward-regexp "" end t)
    (backward-char 2) (insert "\n") (incf end))
  )
;; Prototype

(defun andy--extract-elements (elem from)
  "Extact column numbers ELEM from seq FROM."
  (let ((a elem)
        (f from)
        (v))
    (dolist (elt a v)
      (setq v (cons (nth elt f) v)))))

(defun andy--pair-val-cols (c v joiner)
  (mapcar* (lambda (x y) (concat x joiner y)) c v))

(defun andy--collect-cols (selection names joiner cols)
  (andy--extract-elements selection (andy--pair-val-cols names cols joiner)))

(defun orgtbl-to-sqlupdate (table params)
  "Convert TABLE to sql update statements, PARAMS is the parameter list of parameters from the table as a plist."
  (let* (
         (*orgtbl-default-fmt* 'orgtbl-sql-strip-and-quote)
         (table-name (plist-get params :db-table))
         (colnames (plist-get params :col-names))
         (where-cols (plist-get params :where-cols))
         (set-cols (plist-get params :set-cols))
         (update-statement (concat "UPDATE " table-name " SET ")))
    (orgtbl-to-generic table
                       (org-combine-plists (list
                                            :hlfmt ""
                                            :lfmt (lambda (&rest cols)
                                                    (concat update-statement
                                                            (mapconcat #'identity (andy--collect-cols set-cols colnames "=" cols) ",")
                                                            " WHERE "
                                                            (mapconcat #'identity (andy--collect-cols where-cols colnames "=" cols) " AND ")
                                                            ";"))
                                            :remove-newlines t)
                                           params))))

;;copy from orgtbl-sqlinsert
(defun orgtbl-sql-quote (str)
  "Convert single ticks to doubled single ticks and wrap in single ticks."
  (concat "'" (mapconcat 'identity (split-string str "'") "''") "'"))

(defun orgtbl-sql-strip-dollars-escapes-tildes (str)
  "Strip dollarsigns and backslash escapes, replace tildes with spaces."
  (mapconcat 'identity
	     (split-string (mapconcat 'identity
				      (split-string str "\\$\\|\\\\")
				      "")
			   "~")
	     " "))

(defun orgtbl-sql-strip-and-quote (str)
  "Apply ORGBTL-SQL-QUOTE and ORGTBL-SQL-STRIP-DOLLARS-ESCAPES-TILDES
to sanitize STR for use in SQL statements."
  (cond ((stringp str)
         (orgtbl-sql-quote (orgtbl-sql-strip-dollars-escapes-tildes str)))
        ((sequencep str) (mapcar 'orgtbl-sql-strip-and-quote str))
        (t nil)))

(defun andy-insert-yas (template &optional start end params)
  (yas-expand-snippet (yas-lookup-snippet template) start end params))


(provide 'andy-fn)
;;; andy-fn.el ends here

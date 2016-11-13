(defun enigma (x)
  (and (not (null x))
       (or (null (car x))
	   (enigma (cdr x)))))
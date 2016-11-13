;;Dave Van
;;CMSC 471
;;Homework 1

;;Problem 3b
(defun fact (n)
  (cond
   ((eql n 0) 1)
   (T (* n (fact (- n 1))))))

;;Problem 4a
(defun my-third (l)
  (car(cdr(cdr l))))

;;Problem 3a
(defun lesstwo (n)
  (- n 2))

;;Problem 5
(defun hello ()
  (format t "Enter text: ")
  (let ((s (read)))
    (format t "Hello ~s" s)))

;;Problem 4c
(defun flatten-list (l)
  (cond
   ((null l) l)
   ((atom l) (list l))
   ((list (first l))  
    (append (flatten-list (first l))
	    (flatten-list (cdr  l))))
   (t (append (list (first l))
	      (flatten-list (cdr  l))))))

;;Problem 4b1
(defun posint1 (l)
  (setq l (flatten-list l))
  (remove-if 'null (mapcar 'positive l)))

;;Problem 4b2
(defun posint2 (l)
  (setq l (flatten-list l))
  (loop for element in l
	when (integerp element)
	when (> element 0)
	collect element ))

;;Problem 4b3
(defun posint3 (l)
  (setq l (flatten-list l))
  (cond
   ((integerp (first l))
      (if(> (first l) 0)
	  (cons (first l) (posint3 (cdr l)))
	(posint3 (cdr l))))))

;;helper function
(defun positive (x)
  (if (integerp x)
      (if (> x 0) x)))
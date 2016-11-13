(defun fact (n)
  (cond
   ((eql n 0) 1)
   (T (* n (fact (- n 1))))))

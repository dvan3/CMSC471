(defun flatten-list (l)
  (cond
    ((null l) l)
    ((atom l) (list l))
    ((list (first l))  (append (flatten-list (first l))
                                  (flatten-list (cdr  l))))
    (t                    (append (list (first l))
                                  (flatten-list (cdr  l))))))
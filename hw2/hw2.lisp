;;Author: Dave Van
;;CMSC 471
;;Homework 2 - Rush Hour Game
;;Date 9/24/12

(defvar PASS)
(defvar *EXPANDED*)
(defvar *CREATED*)

(defun initiate ()
  (load "rush-hour-basics.lisp"))

(defun driver (file) 
   (setq gamestate(load-game file)))

(defun goalp (state)
   (eq (aref (game-board state) 2 (- MAXY 1)) GOAL))

(defun move-up (x y state)
   ;;if there is a possible car
   (if (>= (- x 2) 0)
      (progn
         (setq pos1 (aref (game-board state) (- x 1) y)) 
         (setq pos2 (aref (game-board state) (- x 2) y))
	 ;;check if there is a car
         (if (and (not (eq pos1 nil))(eq pos1 pos2))
               (if (>= (- x 3) 0) 
                  (if (eq pos1 (aref (game-board state) (- x 3) y))
		     ;;car with length of 3
                     (list pos1 (- x 3) y)
		     ;;car with length of 2
                     (list pos1 (- x 2) y))
		  ;;car with length of 2
                  (list pos1 (- x 2) y))))))

(defun move-down (x y state)
   ;;if there is a possible car
   (if(< (+ x 2) MAXX)
      (progn
         (setq pos1 (aref (game-board state) (+ x 1) y)) 
         (setq pos2 (aref (game-board state) (+ x 2) y))
	 ;;check if there is a car
         (if (and (not (eq pos1 nil)) (eq pos1 pos2))
               (if (< (+ x 3) MAXX) 
                  (if (eq pos1 (aref (game-board state) (+ x 3) y))
		     ;;car with length of 3
                     (list pos1 (+ x 3) y) 
		     ;;car with length of 2
                     (list pos1 (+ x 2) y))
		  ;;car with length of 2
                  (list pos1 (+ x 2) y))))))

(defun move-left (x y state)
   ;;if there is a possible car
   (if (>= (- y 2) 0)
      (progn
         (setq pos1 (aref (game-board state) x (- y 1))) 
         (setq pos2 (aref (game-board state) x (- y 2)))
	 ;;check if there is a car
         (if (and (not (eq pos1 nil)) (eq pos1 pos2))
               (if (>= (- y 3) 0) 
                  (if (eq pos1 (aref (game-board state) x(- y 3)))
		     ;;car with length of 3
                     (list pos1 x (- y 3)) 
		     ;;car with length of 2
                     (list pos1 x (- y 2)))
		  ;;car with length of 2
                  (list pos1 x (- y 2)))))))

(defun move-right (x y state)
   ;;if there is a possible car
   (if (< (+ y 2) MAXY)
      (progn
         (setq pos1 (aref (game-board state) x (+ y 1))) 
         (setq pos2 (aref (game-board state) x (+ y 2)))
	 ;;check if there is a car
         (if (and (not (eq pos1 nil)) (eq pos1 pos2))
               (if (< (+ y 3) MAXY) 
                  (if (eq pos1 (aref (game-board state) x (+ y 3)))
		     ;;car with length of 3
                     (list pos1 x (+ y 3)) 
		     ;;car with length of 2
                     (list pos1 x (+ y 2)))
		  ;;car with length of 2
                  (list pos1 x (+ y 2)))))))

(defun legal-moves (state)
   (setq moves())
   ;;loop through all of the spaces
   (loop for x from 0 to (- MAXX 1) do
      (loop for y from 0 to (- MAXY 1) do
         (if (empty (game-board state) x y)
            (progn 
               (setf mu (move-up x y state))
               (setf md (move-down x y state))
               (setf ml (move-left x y state))
               (setf mr (move-right x y state))
               (if (not (eq mu nil))
                  (setf moves (append moves(list (flatten-list 
						   (list mu x y))))))
               (if (not (eq md nil))
                  (setf moves (append moves(list (flatten-list 
						  (list md x y))))))
               (if(not (eq ml nil))
                  (setf moves (append moves(list (flatten-list 
						  (list ml x y))))))
               (if (not (eq mr nil))
                  (setf moves (append moves(list (flatten-list 
						  (list mr x y))))))
            )
         )
      )
   )
   moves 
)

(defun flatten-list (l)
  (cond
    ((null l) l)
    ((atom l) (list l))
    ((list (first l))  (append (flatten-list (first l))
                                  (flatten-list (cdr  l))))
    (t                    (append (list (first l))
                                  (flatten-list (cdr  l))))))

(defun apply-move (vehicle x y prex prey state)
   (setf board (copy-array (game-board state)))
   (if (not (= prey y)) 
      (if (> prey y) 
         (progn 
            (loop for y from (+ y 1) to prey do 
               (setf (aref board prex y) vehicle))
            (setf (aref board x y) nil))
         (progn
            (loop for y from prey to (- y 1) do 
               (setf (aref board prex y) vehicle))
            (setf (aref board x y) nil)))
      (if (> prex x)
         (progn 
            (loop for x from (+ 1 x) to prex do 
               (setf (aref board x prey) vehicle))
            (setf( aref board x y) nil))
         (progn 
            (loop for x from prex to (- x 1) do 
               (setf (aref board x prey) vehicle))
            (setf (aref board x y) nil))))
 
   (setf name(gensym))
   (set name
      (make-instance 'game
         :name name
         :board board
         :parent state
         :depth (+ 1 (game-depth state)))))

(defun basic-search (state q-fn &key depth (PASS nil) (passed nil))
  (setf nodes (list state) )
  (loop do
    (progn
      (if (null nodes) (return-from basic-search 'failure))
      (setf node (car nodes))
      (setf nodes (cdr nodes))
      (unless (member node passed :test #'game-eq)
        (if (goalp node)
            (return-from basic-search (list 'success node 
					    (length passed) 
					    (length nodes)))
          (progn 
            (push node passed)
            (setf nodes (funcall q-fn nodes (expand node)))))))))

(defun expand (state)
   (setf moves (legal-moves state))
   (setf pm())
   (loop for move in moves do 
      (setq poss (apply-move (first move) (second move) (third move) 
			       (fourth move) (fifth move) state))
      (unless (member poss PASS :test #'game-eq) 
         (push poss pm)))
   (setq PASS (nconc pm PASS))
   (return-from expand (list pm)))

(defun game-eq (state1 state2)
   (array-equal (game-board state1) (game-board state2)))

(defun q-bfs (nodes new-nodes)
  (nconc nodes (flatten-list new-nodes)))

;;wrapper function
(defun bfs (state)
   (basic-search state #'q-bfs))

(defun q-dfs (nodes new-nodes)
  (nconc (flatten-list new-nodes) nodes))

;;wrapper function
(defun dfs (state)
   (basic-search state #'q-dfs))

(defun a* (state)
  (basic-search state #'q-a*))
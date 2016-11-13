(defvar VISITS)

;;=======================================================================
;; Function: GOALP
;; Arguments: gamestate (game object)
;; Returns: T or F
;; Purpose: test board for goal state
" test board for goal state "
( defun goalp ( gamestate )
   ( eq ( aref ( game-board gamestate ) 2 (- MAXY 1) )  GOAL ) 
)

;;=======================================================================
;; Function: MOVE-UP 
;; Arguments: (x,y) position to test, gamestate 
;; Returns: vehicle name to be moved, and position freed (x,y)
;; Purpose: test empty square for possible vehicle movement up
( defun move-up ( posx posy gamestate )
"  test empty square for possible vehicle movement up "   
   ;; possible vehicle locations
   ( if ( >= ( - posx 2 ) 0 ) ;; if position in bounds
      ( progn
         ( setq pos1 ( aref ( game-board gamestate ) (- posx 1) posy ) ) 
         ( setq pos2 ( aref ( game-board gamestate ) (- posx 2) posy ) ) 
         ;; check for non-nil and equality... if true we have a valid car
         ( if ( and ( not ( eq pos1 nil ) ) ( eq pos1 pos2 ) )
               ( if ( >= ( - posx 3 ) 0 ) 
                  ;; 3rd car element possible
                  ( if ( eq pos1 ( aref ( game-board gamestate ) ( - posx 3 ) posy ) )
                     ;; we have a 3 element car
                     ( list pos1 (- posx 3) posy)  
                     ;; else we have a 2 element car
                     ( list pos1 (- posx 2) posy)  
                  )
                  ;; else 2 element car found
                  ( list pos1 (- posx 2 ) posy) 
               )
         )
      )
   )
)

;;=======================================================================
;; Function: MOVE-DOWN 
;; Arguments: (x,y) position to test, gamestate 
;; Returns: vehicle name to be moved, and position freed (x,y)
;; Purpose: test empty square for possible vehicle movement down
( defun move-down ( posx posy gamestate )
" test empty square for possible vehicle movement down "
   ;; possible vehicle locations
   ( if ( < ( + posx 2 ) MAXX ) ;; if position in bounds
      ( progn
         ( setq pos1 ( aref ( game-board gamestate ) (+ posx 1) posy ) ) 
         ( setq pos2 ( aref ( game-board gamestate ) (+ posx 2) posy ) ) 
         ;; check for non-nil and equality... if true we have a valid car
         ( if ( and ( not ( eq pos1 nil ) ) ( eq pos1 pos2 ) )
               ( if ( < ( + posx 3 ) MAXX ) 
                  ;; 3rd car element possible
                  ( if ( eq pos1 ( aref ( game-board gamestate ) ( + posx 3 ) posy ) )
                     ;; we have a 3 element car
                     ( list pos1 (+ posx 3) posy)  
                     ;; else we have a 2 element car
                     ( list pos1 (+ posx 2) posy)  
                  )
                  ;; else 2 element car found
                  ( list pos1 (+ posx 2 ) posy) 
               )
         )
      )
   )
)

;;=======================================================================
;; Function: MOVE-LEFT 
;; Arguments: (x,y) position to test, gamestate 
;; Returns: vehicle name to be moved, and position freed (x,y)
;; Purpose: test empty square for possible vehicle movement left
( defun move-left ( posx posy gamestate )
" test empty square for possible vehicle movement left "
   ;; possible vehicle locations
   ( if ( >= ( - posy 2 ) 0 ) ;; if position in bounds
      ( progn
         ( setq pos1 ( aref ( game-board gamestate ) posx (- posy 1)) ) 
         ( setq pos2 ( aref ( game-board gamestate ) posx (- posy 2)) ) 
         ;; check for non-nil and equality... if true we have a valid car
         ( if ( and ( not ( eq pos1 nil ) ) ( eq pos1 pos2 ) )
               ( if ( >= ( - posy 3 ) 0 ) 
                  ;; 3rd car element possible
                  ( if ( eq pos1 ( aref ( game-board gamestate ) posx ( - posy 3 ) ) )
                     ;; we have a 3 element car
                     ( list pos1 posx (- posy 3) )  
                     ;; else we have a 2 element car
                     ( list pos1 posx (- posy 2) )    
                  )
                  ;; else 2 element car found
                  ( list pos1 posx (- posy 2 ) )  
               )
         )
      )
   )
)

;;=======================================================================
;; Function: MOVE-RIGHT 
;; Arguments: (x,y) position to test, gamestate 
;; Returns: vehicle name to be moved, and position freed (x,y)
;; Purpose: test empty square for possible vehicle movement right
( defun move-right ( posx posy gamestate )
"test empty square for possible vehicle movement right "
   ;; possible vehicle locations
   ( if ( < ( + posy 2 ) MAXY ) ;; if position in bounds
      ( progn
         ( setq pos1 ( aref ( game-board gamestate ) posx (+ posy 1)) ) 
         ( setq pos2 ( aref ( game-board gamestate ) posx (+ posy 2)) ) 
         ;; check for non-nil and equality... if true we have a valid car
         ( if ( and ( not ( eq pos1 nil ) ) ( eq pos1 pos2 ) )
               ( if ( < ( + posy 3 ) MAXY ) 
                  ;; 3rd car element possible
                  ( if ( eq pos1 ( aref ( game-board gamestate ) posx ( + posy 3 ) ) )
                     ;; we have a 3 element car
                     ( list pos1 posx (+ posy 3) )  
                     ;; else we have a 2 element car
                     ( list pos1 posx (+ posy 2) )  
                  )
                  ;; else 2 element car found
                  ( list pos1 posx (+ posy 2 ) ) 
               )
         )
      )
   )
)

;;=======================================================================
;; Function: LEGAL-MOVES
;; Arguments: game-board 
;; Returns: a list of legal moves or nil if none
;; Purpose: find all possible legal moves given current game state
( defun legal-moves ( gamestate )
" find all possible legal moves given current game state " 
   ( setq moves () )
   ; iterate across empty game board squares
   ( loop for x from 0 to ( - MAXX 1 ) do
      ( loop for y from 0 to ( - MAXY 1 ) do
         ( if ( empty ( game-board gamestate ) x y )
            ( progn 
               ; mark current position and any possible moves
               ( setf mu ( move-up x y gamestate ) )
               ( setf md ( move-down x y gamestate ) )
               ( setf ml ( move-left x y gamestate ) )
               ( setf mr ( move-right x y gamestate ) )
               ( if ( not ( eq mu nil ) )
                  ( setf moves ( append moves (list (flatten-list (list mu x y )  ) ) ) )
               )
               ( if ( not ( eq md nil ) )
                  ( setf moves ( append moves ( list (flatten-list (list md x y ) )  ) ) )
               )
               ( if ( not ( eq ml nil ) )
                  ( setf moves ( append moves ( list (flatten-list (list ml x y ) ) ) ) )
               )
               ( if ( not ( eq mr nil ) )
                  ( setf moves ( append moves ( list (flatten-list (list mr x y )  ) ) ) )
               )
            )
         )
      )

   )
   moves 
)

;;=======================================================================
;; Function: flatten-list
;; Arguments:  list
;; Returns: flattened list
;; Purpose: flatten list used to reduce lists of lists to lists as needed
( defun flatten-list ( l )
"flatten list used to reduce lists of lists to lists as needed"
   ( if ( null l )
      nil ; if-then
      ( progn ; else
         ( if ( listp ( first l ) )
            ( append ( flatten-list ( first l ) ) ( flatten-list ( rest l ) ) ) ;; if-then
            ( cons (first l) ( flatten-list ( rest l ) ) ) ;; else
         )
      )
   )
)


;;=======================================================================
;; Function: APPLY-MOVE
;; Arguments: game-board, (x,y) empty square, vehicle to move, (x,y) square 
;;            emptied by move
;; Returns: a game-board node w/ link back parent & depth
;; Purpose: apply a move to a game-board by creating a new instance
( defun apply-move ( veh postx posty prex prey gamestate )
" apply a move to a game-board by creating a new instance "
   ; alter gameboard to reflect move
   ( setf board ( copy-array (game-board gamestate ) ) )

   ( if ( not ( = prey posty ) ) 
   ; if left/right movement
      ( if ( > prey posty )
      ; move right to left 
         ( progn 
            ( loop for y from ( + posty 1) to prey do 
               ( setf ( aref board prex y ) veh )
            )
            ( setf ( aref board postx posty ) nil )
         )
      ; else left to right
         ( progn
            ( loop for y from prey to ( - posty 1 ) do 
               ( setf ( aref board prex y ) veh )
            )
            ( setf ( aref board postx posty ) nil )
         )
      )
   ; else up/down movement
      ( if ( > prex postx )
      ; move down  to up
         ( progn 
            ( loop for x from ( + 1 postx) to prex do 
               ( setf ( aref board x prey ) veh )
            )
            ( setf ( aref board postx posty ) nil )
         )
      ; else up to down
         ( progn 
            ( loop for x from prex to ( - postx 1 ) do 
               ( setf ( aref board x prey ) veh )
            )
            ( setf ( aref board postx posty ) nil )
         )
      )
   )

   ; create new gamestate and mirror original gamestate
   (setf name (gensym) )
   (set name
      (make-instance 'game
         :name name
         :board board
         :parent gamestate
         :depth ( + 1 ( game-depth gamestate ) )
      )
   )
)

;;=======================================================================
;; Function: BASIC-SEARCH
;; Arguments: gamestate, queueing function, optional args (depth limit)
;; Returns: success/failure, # visited nodes, # opened nodes
;; Purpose: perform uninformed search for goal state
;; Note: Prof. desJardins 8puzzle used as a reference for this function
(defun basic-search (gamestate q-fn &aux depth (VISITS nil) (visited nil))
" perform uninformed search for goal state "
  (setf nodes (list gamestate) )
  (loop do
    (progn
      (if (null nodes) (return-from basic-search 'failure))
      (setf node (car nodes))
      (setf nodes (cdr nodes))
      ;; Don't test an already visited node; just loop again
      ( unless (member node visited :test #'game-eq )
;; uncomment for DEBUG
;;        (format t "Testing ~s (~s nodes visited, ~s nodes open)~%"
;;                (game-name node) (length visited) (length nodes))
        (if (goalp node)
            (return-from basic-search (list 'success node (length visited) (length nodes)))
          (progn 
            (push node visited)
            (setf nodes (funcall q-fn nodes (expand node) ) )
          )
        )
      )
   )
  )
)


;;=======================================================================
;; Function: q-bfs
;; Arguments: current gamestate and list of expanded moves to enqueue 
;; Returns:
;; Purpose: enqueue gamestates in breadth-first fashion 
( defun q-bfs (nodes new-nodes)
  (nconc nodes (flatten-list new-nodes) )
)


;;=======================================================================
;; Function: bfs
;; Arguments: gamestate 
;; Returns:
;; Purpose: wrapper function to invoke basic-search w/ q-bfs 
( defun bfs ( gamestate )
   ( basic-search gamestate #'q-bfs )
)

;;=======================================================================
;; Function: Q-DFS
;; Arguments: current gamestate and list of expanded moves to enqueue 
;; Returns:
;; Purpose: enqueue games in depth-first fashion
( defun q-dfs (nodes new-nodes)
  (nconc (flatten-list new-nodes) nodes)
)

;;=======================================================================
;; Function: dfs
;; Arguments: gamestate 
;; Returns:
;; Purpose: wrapper function to invoke basic-search w/ q-dfs 
( defun dfs ( gamestate )
   ( basic-search gamestate #'q-dfs )
)

;;=======================================================================
;; Function: expand 
;; Arguments: gamestate as node 
;; Returns: a list of expanded gamestates based on legal moves
;; Purpose: expand a gamestate into a set of gamtestates based upon game rules 
( defun expand ( gamestate )
" expand a gamestate into a set of gamtestates based upon game rules "
   ; obtain list of legal moves
   ( setf moves ( legal-moves gamestate ) )
   ; list of possible moves (after visited check)
   ( setf pm () )
   ; for each legal move
   ( loop for move in moves do 
      ; apply move
      ( setq poss ( apply-move ( first move ) ( second move ) ( third move ) ( fourth move ) (fifth move ) gamestate ) )
      ; test for visited
      ( unless (member poss VISITS :test #'game-eq ) 
         (push poss pm )
      )
   )
   ( setq VISITS (nconc pm VISITS ) )
   ;VISITS
   (return-from expand (list pm) )
)

;;=======================================================================
;; Function: game-eq
;; Arguments: gamestate, gamestate
;; Returns: true if games are equal
;; Purpose: test gameboards for equality
( defun game-eq ( gs1 gs2 )
   (array-equal (game-board gs1) (game-board gs2 ) )
)
   
;; START CODE EXECUTION 
(defun init ( )
   ( load "rush-hour-basics.lisp" ) 
)

(defun driver ( file ) 
   (setq gamestate ( load-game file ) )
   ;;(goalp gamestate)
)
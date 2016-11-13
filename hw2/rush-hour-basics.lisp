;;==============================================================
;; RUSH HOUR CODE
;; CMSC 471 HOMEWORK #2
;; PROVIDED BY PROF. MARIE desJARDINS
;; SEPTEMBER 2011
;;

;;==============================================================
;; CONSTANTS AND GLOBAL VARIABLES

(defconstant GOAL 'g
  "Name of car to move off board -- does not change")

(defvar MAXX 0
  "Maximum X dimension [1-based] of the current game")
(defvar MAXY 0
  "Maximum Y dimension [1-based] of the current game")
(defvar DEPTH-LIMIT 20
  "Default depth limit for search")


;;==============================================================
;; DEBUGGING AND LOGGING

(defvar *DEBUG* t
  "Output stream for printing debugging and logging messages;
default is stdout (T)")

;; Open a log file.
;; Use (format *DEBUG* FORMAT-STRING ARG ...) to record debugging
;; and logging information into the logging file.  If no log file
;; is open, these messages will be written to the terminal screen.
(defun open-debug (file)
  (setf *DEBUG* (open file :direction :output :if-exists :overwrite
		          :if-does-not-exist :create)))

;; Close the log file, and reset *DEBUG* to standard output (T)
(defun close-debug ()
  (when (not (eq *DEBUG* t))
    (close *DEBUG*)
    (setf *DEBUG* t)))


;;==============================================================
;; DATA STRUCTURES

;; A game (i.e., a node in the search tree) is a board (i.e., game
;; state) plus some bookkeeping information

(defclass game ()
  ((name :accessor game-name
	  :initarg :name)
   ;; The board is a MAXXxMAXY array (x=0..MAXX-1, y=0..MAXY-1)
   ;; Each location on the board contains a symbol representing
   ;; a vehicle, or nil
   (board :accessor game-board
	    :initarg :board
	      :initform nil)
   ;; Parent of this node in the search tree
   (parent :accessor game-parent
	      :initarg :parent
	         :initform nil)
   ;; Depth of this node in the search tree
   (depth :accessor game-depth
	     :initarg :depth
	        :initform 0)
   ))


;;==============================================================
;; UTILITY FUNCTIONS

(defmacro x-coord (loc)
  "Extract the x coordinate from an (x y) list"
  `(first ,loc))
(defmacro y-coord (loc)
  "Extract the y coordinate from an (x y) list"
  `(second ,loc))


;; EMPTY: Check to see if an (x y) position on the board exists
;; and is empty.
(defun empty (board x y)
  "Returns T if x,y is in range and the board position at x,y is empty"
  (and (not (< x 0)) (not (< y 0))
       (not (>= x MAXX)) (not (>= y MAXY))
       (not (aref board x y))))


;; COPY-ARRAY:  Make a copy of a 2-D array that is EQUAL but
;; not EQ to the original array.  Will be used by EXPAND.
(defun copy-array (a)
  "Copy a 2-D array"
  (let* ((dims (array-dimensions a))
	  (b (make-array dims)))
    (loop for x from 0 to (- (first dims) 1) do
      (loop for y from 0 to (- (second dims) 1) do
	    (setf (aref b x y) (aref a x y))))
    b))


;; ARRAY-EQUAL:  Return T if two 2-D arrays are EQUAL (that
;; is, if they are EQ at every array position).  Will be used
;; in CHECK-REPEATED.
(defun array-equal (a1 a2)
  "Check to see whether two 2-D arrays are EQUAL,
i.e., are EQ at every array position"
  (let* ((dims1 (array-dimensions a1))
	  (dims2 (array-dimensions a2)))
    (when (equal dims1 dims2)
      (loop for x from 0 to (- (first dims1) 1) do
	    (loop for y from 0 to (- (second dims1) 1) do
		        ;; If any position isn't EQ, return nil
		    (if (not (eq (aref a1 x y) (aref a2 x y)))
			      (return-from array-equal nil))))
      ;; If we got this far, then the array is EQ everywhere
      (return-from array-equal t)))
  ;; If we got here, the dimensions didn't match
  nil)


;;==============================================================
;; INITIALIZATION FUNCTION

;; LOAD-GAME:  Load a game from a file, and create a game instance
;; to record all of the information.  Also creates a new variable
;; that refers to the game structure; so, for example, when you load
;; the test file "test0", in which the first line specifies the
;; name "test0", after calling this function, the global variable
;; TEST0 will point to the new game structure.
(defun load-game (file &aux token line array name)
  "Load a Rush Hour game from a file."
  (with-open-file          ;; Inside this loop, STR reads from FILE
   (str file :direction :input
	:if-does-not-exist :error)
   ;; Read the game name
   (setf name (read str))
   ;; Read the maximum X and Y values for the board, check for
   ;; legality, and set global MAXX and MAXY values
   (setf token (read str))
   (if (integerp token)
       (setf MAXX token)
     (error "Illegal value of MAXX (~s) in file ~s~%" token file))
   (setf token (read str))
   (if (integerp token)
       (setf MAXY token)
     (error "Illegal value of MAXY (~s) in file ~s~%" token file))
   ;; Initialize and read in the board array, line by line
   (setf array nil)
   (loop for i from 1 to MAXX do
     (setf line (read-token-line str))
     (if (not (eql (length line) MAXY))
	  (error "Illegal line in ~s (should have ~s entries)~%:  ~s~%"
		 file MAXY line))
     (setf array (nconc array (list line))))
   ;; Create an instance, and a global variable with the name of the
   ;; instance.  This value will also be returned from LOAD-GAME, since
   ;; it's the last line in the function.
   (set name
	(make-instance 'game
		              :name name
			             :board (make-array `(,MAXX ,MAXY)
							  :initial-contents array)))))


;;==============================================================
;; I/O FUNCTIONS

;; Method for printing an object of class GAME to an output stream
(defmethod print-object ((g game) str)
  "Print an object of class GAME to an output stream"
  (format str "Game ~s:~%" (game-name g))
  (print-board (game-board g) str))

;; Print a game board, neatly formatted with 4-space columns. 
;; See ~< ~> formatting string and behold the power of FORMAT! 
(defun print-board (b str)
  "Print a formatted Rush Hour game board"
  (loop for x from 0 to (- MAXX 1) do
    (loop for y from 0 to (- MAXY 1) do
      (format str "~4<~s~>" (or (aref b x y)
				'-)))
    (format str "~%")))



;; Read a line of tokens from an input stream
(defun read-token-line (str &aux line (next t) (start 0)
			        (tokens nil))
  "Read a line of tokens into a list"
  ;; First input the line into a string
  (setf line (read-line str))
  (loop while (not (eq next :done))
    do (progn
	  (multiple-value-setq
	        (next start)
		     ;; Loop, reading tokens sequentially from the string
		   (read-from-string line nil :done :start start))
	   (if (not (eq next :done))
	            (setf tokens (nconc tokens (list next))))))
  tokens)

 
;; PRINT-SEARCH-INFO:  Given an argument GAME-RESULTS (a 4-tuple
;; list containing a result ('success or 'fail), the goal node if
;; one was found, the number of nodes created, and the number of
;; nodes expanded, print a summary of the search to STR
(defun print-search-info (game-results str)
  "Print final search summary to an output stream"
  (let ((result (first game-results))
	(last (second game-results))
	(created (third game-results))
	(expanded (fourth game-results)))
    (format str "~s~%~s nodes created~%~s nodes expanded~%~%"
	        result created expanded)
    (when last
      (format str "Search path (depth ~s):~%" (game-depth last))
      (print-path-recursive last str))))

;; PRINT-PATH-RECURSIVE:  Given a game node, print the path from
;; the root node to this node.  Operates by recursively following
;; the PARENT slots up to the root, then printing each node as
;; the recursion unwinds.
(defun print-path-recursive (node str)
  "Print the path from the root to the given node, recursing and then unwinding"
  (if (not (typep node 'game))
      (error "~s is not a game node" node))
  (if (game-parent node)
      (print-path-recursive (game-parent node) str))
  (format *DEBUG* "~%")
  (print-board (game-board node) str))
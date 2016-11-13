(format t "Enter text: ")
(let ((s (read)))
  (format t "Hello ~s" s))
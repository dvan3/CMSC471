Name: Dave Van
Date: 10/4/12
Class: CMSC471

*********TEST1********
**********BFS*********
(driver 'test1)(print-search-info (bfs test1) t)
Game TEST1:
   -   -   -   -   -   -
   -   -   -   -   -   -
   -   -   -   G   G   -
   -   -   -   -   -   -
   -   -   -   -   -   -
   -   -   -   -   -   -

[4]> SUCCESS
1 nodes created
1 nodes expanded

Search path (depth 1):

**********DFS*********
(driver 'test1)(print-search-info (dfs test1) t)
Game TEST1:
   -   -   -   -   -   -
   -   -   -   -   -   -
   -   -   -   G   G   -
   -   -   -   -   -   -
   -   -   -   -   -   -
   -   -   -   -   -   -

[6]> SUCCESS
1 nodes created
1 nodes expanded

*********TEST2********
**********BFS*********
(driver 'test2)(print-search-info (bfs test2) t)
Game TEST2:
   -   -   -   -   -   -
   -   -   -   -   -   -
   -   -   -   G   G  V1
   -   -   -   -   -  V1
   -   -   -   -   -  V1
   -   -   -   -   -   -

[8]> SUCCESS
4 nodes created
22 nodes expanded

Search path (depth 2):

**********DFS*********
(driver 'test2)(print-search-info (dfs test2) t)
Game TEST2:
   -   -   -   -   -   -
   -   -   -   -   -   -
   -   -   -   G   G  V1
   -   -   -   -   -  V1
   -   -   -   -   -  V1
   -   -   -   -   -   -

[10]> SUCCESS
2 nodes created
7 nodes expanded

Search path (depth 2):

*********TEST3********
**********BFS*********
(driver 'test3)(print-search-info (bfs test3) t)
Game TEST3:
   -   -   -   -   -   -
   -   -   -  V1   -   -
  V3   G   G  V1   -   -
  V3   -   -  V1   -   -
  V3  V2  V2  V2   -   -
   -   -   -   -   -   -

[12]> SUCCESS
41 nodes created
42 nodes expanded

Search path (depth 7):

**********DFS*********
(driver 'test3)(print-search-info (dfs test3) t)
Game TEST3:
   -   -   -   -   -   -
   -   -   -  V1   -   -
  V3   G   G  V1   -   -
  V3   -   -  V1   -   -
  V3  V2  V2  V2   -   -
   -   -   -   -   -   -

[14]> SUCCESS
19 nodes created
400 nodes expanded

Search path (depth 15):

*********TEST4********
**********BFS*********
(driver 'test4)(print-search-info (bfs test4) t)
Game TEST4:
  V1  V1   -   -   -  V2
  V3   -   -  V4   -  V2
  V3   G   G  V4   -  V2
  V3   -   -  V4   -   -
  V5   -   -   -  V6  V6
  V5   -  V7  V7  V7   -

[12]> SUCCESS
1068 nodes created
7503 nodes expanded

Search path (depth 16):

**********DFS*********
(driver 'test4)(print-search-info (dfs test4) t)
Game TEST4:
  V1  V1   -   -   -  V2
  V3   -   -  V4   -  V2
  V3   G   G  V4   -  V2
  V3   -   -  V4   -   -
  V5   -   -   -  V6  V6
  V5   -  V7  V7  V7   -

[16]> SUCCESS
120 nodes created
26816 nodes expanded

Search path (depth 119):


2. Homework 2 AI WRITTEN PART:

	 Breadth-first search, from the test, seems to have less nodes 
expanded, but it has created more nodes. From the test, it seems that 
depth-first search is much more efficient when creating nodes and expanding. 
It solves the game a lot faster than breadth-first search. When the tests get 
more difficult, it seems the run time of each search takes longer. 
Breadth-first search takes the longest and depth-first search takes the 
shortest time. Creating nodes seems to be the reason for the long run time 
for breadth-first search. Seems that expanding nodes doesn.t really affect 
the run time.
	 The length of the solution increases based on the number of expanded 
nodes in breadth-first. With depth-first search the solution isn.t based on 
the number of expanded nodes. 
	 When testing TEST1, both breadth-first search and depth-first search 
ran with constant time because there was only one node created and expanded 
in both. This was the case because in this test, there were no cars in the 
path of the goal. The goal car was also one space away from the goal. So it 
only needed to create and expand one node to reach it.s goal.
	 When testing TEST2, depth-first search was superior when it comes to 
run-time. Depth-first search only created two nodes and expanded seven nodes. 
While breadth-first search created four nodes and expanded twenty-two nodes. 
The depth of the solution path for both searches was two.
	 When testing TEST3, this was the time where you could tell the 
difference between the run times. Breadth-first search created forty-one nodes
 and expanded forty-two nodes. While depth-first search created nineteen nodes
 and expanded four hundred nodes. The depth of the solution for breadth-first 
search was seven and the depth of the solution for depth-first search was 
fifteen.
	 When testing TEST4, my breadth-first search was not working. I ran it
for a several minutes and it didn.t finish running it. When I ran depth-first
search, it took a little bit for it to finish running it. When it finished 
running, it created 120 nodes and expanded 26816 nodes. The solution depth of 
the test for depth-first search was 119.

3. There are five legal states in test1. In test2, there are seventeen legal 
states. For test3, since there are more car than test2, it was more difficult 
to count all the legal states. So how I estimated each state was this. If a 
car of length 3 was vertical and horizontal, each car has 4 states. So I 
multiplied each car times each other. In test3, there were 3 cars with length 
of 3 and a goal car that was length of 2. The goal car has 5 states. 
So 4 * 4 * 4 * 5 = 320 legal states.  For test4, I did the exact same thing. 
There are 4 cars with length of 2, and 4 cars length of 3. 5^4 * 4^4 = 160000 
states.

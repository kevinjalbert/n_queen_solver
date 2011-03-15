N-Queen Solver
==============
Purpose
-------
The [8-Queen Problem](http://en.wikipedia.org/wiki/Eight_queens_puzzle,"8-Queen Problem") is a classic algorithmic challenge in computer science. This project aims to solve the more generalized *N-Queen Problem* (mainly because the class assignment asked for the 4-Queen problem). 

The following tasks were the minimum requirements for this assignment. Additional features were added just to learn [Ruby](http://www.ruby-lang.org,"Ruby") more as this was the first time coding in the language.

Tasks
-----
### Searching for the solutions
* How many states does your simple search algorithm have to go through to find the first solution?
* Use your search algorithm to find all the solutions.  
* How many different solutions are there for the 4-queen problem?

### Constraint Propagation
* How many states does your search with constraint propagation have to go through to find the first solution?
* Use your search algorithm to find all the solutions.  
* Verify that your improved search has the same number of solutions before.

Features
--------
* Able to specify any number of queens over 3.
* Able to use *Depth-First Search* or *Breath-First Search* strategies.
* Able to specify the usage of ordering search (each queen belongs to a row).
* Able to specify the usage of constraint satisfaction problem in the algorithm.

Solution
========

Problem Definition
------------------
*To answer the assignment, a 4-queen problem will be used*

A 4-queen problem requires a 4 by 4 chessboard. This chessboard is structured so that we have index 0 in the top-left of the board, which extends outwards incrementally. The board is encoded using bitsets though, so each row is a bitset.

Four queens must be placed within this chessboard. The queens must be placed such that none of them can be captured by each other.

State Space
-----------
Given that four queens must be placed on the chessboard, we have 4 by 4 chessboard with 4 queens to place on it. We are not concerned with the order of the queens, so we are only concerned with the combinations of queens on the chessboard.

    number of states = 4*4 Choose 4
                     = 16 Choose 4
                     = 1820

Initial State
-------------
The search for a goal state requires an initial state for the queens. Queens will be placed down on the board one at a time, until a goal state is found, or that an invalid state is discovered. The chessboard initially looks like the following: (0 = No Queen, 1 = Queen)
<table>
    <tr>
        <td>0</td><td>0</td><td>0</td><td>0</td>
    </tr>
    <tr>
        <td>0</td><td>0</td><td>0</td><td>0</td>
    </tr>
    <tr>
        <td>0</td><td>0</td><td>0</td><td>0</td>
    </tr>
    <tr>
        <td>0</td><td>0</td><td>0</td><td>0</td>
    </tr>
</table>
A state is represented in this manner, where each row is a bitset: 
  `state = ["0000","0011","0010","1000"]`

So the initial state is therefore represented as: 
  `initial state = ["0000","0000","0000","0000"]`

Action
------
To transition from one state to another state a single queen has to be added to the chessboard. An example action to move from one state to a new state is:

    state_1 -------------------------action-------------------------> state_2
    ["0000","0000","0000","0000"] --add queen--> ["0010","0000","0000","0000"]

Goal
----
The goal is to achieve a state where none of the queens are in a conflict with each other. Thus, there must be only one queen in each row, column and diagonal. An example goal state is shown:
<table>
    <tr>
        <td>0</td><td>1</td><td>0</td><td>0</td>
    </tr>
    <tr>
        <td>0</td><td>0</td><td>0</td><td>1</td>
    </tr>
    <tr>
        <td>1</td><td>0</td><td>0</td><td>0</td>
    </tr>
    <tr>
        <td>0</td><td>0</td><td>1</td><td>0</td>
    </tr>
</table>

Cost
----
Every action has a cost associated to it. In this problem every action has the same cost of *1*. Thus, the cost of a path is the number of actions taken. `cost of path = number of states`

Minimizing the cost indicates that the goal state was discovered efficiently.

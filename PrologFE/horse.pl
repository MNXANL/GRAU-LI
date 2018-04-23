/*Consider an n × n chessboard (for any natural number n > 3, not necessarily 8), where n is
defined by a Prolog clause boardSize(n). (for example, boardSize(14) if if n = 14). Define a Prolog
predicate horse(I1,J1,I2,J2) that writes the shortest possible sequence of positions that a horse of
chess traverses to go from initial position I1,J1 to final position I2,J2 on the board (positions are
(row,column), each one in 1..n). It must write the sequence in the right order, the first position being
[I1,J1], and write “no solution” if no such a sequence exists.*/


horse(I1,J1,I2,J2):-
	boardSize(N), NumSquares is N*N,
	between(0,NumSquares,K),
	path( [I1,J1], [I2,J2], [[I1,J1]], Path ),
	length(Path,K),
	reverse(Path,Path1),
	write(Path1).
	horse(_,_,_,_):- write(’no solution’).

path( E,E, C,C ).
path( CurrentState, FinalState, PathSoFar, TotalPath ):-
	oneStep( CurrentState, NextState ),
	\+member(NextState,PathSoFar),
	path( NextState, FinalState, [NextState|PathSoFar], TotalPath ).

reverse([],[]).
reverse([X|L],L1):- 
	reverse(L,L2), 
	append(L2,[X],L1),!.

exists(I,J):- 
	boardSize(N), 
	between(1,N,I), 
	between(1,N,J).

oneStep( [I1,J1], [I2,J2] ):- I2 is I1+1, J2 is J1+2, exists(I2,J2).
oneStep( [I1,J1], [I2,J2] ):- I2 is I1-1, J2 is J1+2, exists(I2,J2).
oneStep( [I1,J1], [I2,J2] ):- I2 is I1+1, J2 is J1-2, exists(I2,J2).
oneStep( [I1,J1], [I2,J2] ):- I2 is I1-1, J2 is J1-2, exists(I2,J2).
oneStep( [I1,J1], [I2,J2] ):- J2 is J1+1, I2 is I1+2, exists(I2,J2).
oneStep( [I1,J1], [I2,J2] ):- J2 is J1-1, I2 is I1+2, exists(I2,J2).
oneStep( [I1,J1], [I2,J2] ):- J2 is J1+1, I2 is I1-2, exists(I2,J2).
oneStep( [I1,J1], [I2,J2] ):- J2 is J1-1, I2 is I1-2, exists(I2,J2).
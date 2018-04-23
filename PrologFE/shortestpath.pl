/*
Write a Prolog predicate shortest([I1,J1], [I2,J2]) that writes to the output the shortest
path on a chess board a horse needs to go from square [I1,J2] to square[I2,J2]. Coordinates I,J
are in 1..8. The path is the list of intermediate board squares. Your solution should be short, clean
and simple, without any comments.
*/

path( E,E, C,C ).
path( CurrentState, FinalState, PathUntilNow, TotalPath ):-
	oneStep( CurrentState, NextState ),
	\+member(NextState,PathUntilNow),
	path( NextState, FinalState, [NextState|PathUntilNow], TotalPath ).

oneStep([I1,J1],[I2,J2]):- member( [A,B], [[1,2],[2,1]] ),
	member( SignA, [1,-1] ), I2 is I1 + A*SignA,
	member( SignB, [1,-1] ), J2 is J1 + B*SignB, between(1,8,I2), between(1,8,J2).

shortest([I1,J1],[I2,J2]):- between(1,64,N),
	path( [I1,J1], [I2,J2], [[I1,J1]], Path ), length( Path, N ), write(path), nl.

% Main program to evaluate.
creciente_suma([], _, []).
creciente_suma(L, K, S):-
    subset(L, S),
    increasingList(S),
    suma(S, K).
    


%%%%%%%%%%%%%%%%%%%% AUXILIARY STUFF %%%%%%%%%%%%%%%%%%%%%%%%


% subset(L, S) returns a subset S of a list L
subset([], []). 
subset([X|L], [X|S]) :- subset(L, S). 
subset([_|L],   S  ) :- subset(L, S). 
  

% Checks if a list is in non-strict increasingly order
increasingList([]).
increasingList([First|List]):- increasingList_imm(First, List).


% Immersion function for increasingList so that it accumulates 
% the previous value, which we need to make the comparison(s).
increasingList_imm(_, []).
increasingList_imm(Prev, [First|List]):-
    Prev =< First,
    increasingList_imm(First, List).
  

% Sum of all the elements of a list.
suma([], 0).
suma([X|L], Num):-
    suma(L, N1),
    Num is N1 + X.


  


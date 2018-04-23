% Main program to evaluate.
igual_particion([], [], []).
igual_particion(L, S1, S2):-
    subset_compl(L, S1, S2),
    sum(S1, Value),
    sum(S2, Value). 
    
%Value has to be the same; this way we save a comparison.



%%%%%%%%%%%%%%%%%%%% AUXILIARY STUFF %%%%%%%%%%%%%%%%%%%%%%%%

% Sum of all the elements of a list.
sum([], 0).
sum([X|L], N):-
    sum(L, N1),
    N is N1+X.

    
% subset_compl(L, S, C) returns the subset S 
%   and its complementary C of a list L
subset_compl([], [], []). 
subset_compl([X|L], [X|S], C) :- subset_compl(L, S, C). 
subset_compl([X|L], S, [X|C]) :- subset_compl(L, S, C). 

:- use_module(library(clpfd)).

%ejemplo(_, Big, [S1...SN]): how to fit all squares of sizes S1...SN in a square of size Big?
ejemplo(0,  3, [2,1,1,1,1,1]).
ejemplo(1,  4, [2,2,2,1,1,1,1]).
ejemplo(2,  5, [3,2,2,2,1,1,1,1]).
ejemplo(3, 19, [10,9,7,6,4,4,3,3,3,3,3,2,2,2,1,1,1,1,1,1]).
ejemplo(4,112, [50,42,37,35,33,29,27,25,24,19,18,17,16,15,11,9,8,7,6,4,2]).
ejemplo(5,175, [81,64,56,55,51,43,39,38,35,33,31,30,29,20,18,16,14,9,8,5,4,3,2,1]).





insideBigSquare(_, Big, [S|Sides], [V|Vars]):- 
    V #=< (Big-S+1),    
    insideBigSquare(_, Big, Sides, Vars).
insideBigSquare(_, _, [], []).

/*
% HACK: Using disjoint2/1 predicate to prevent overlaps
Let us define disjoint2(L):
    - True iff rectangles don't overlap
    - Rectangles are i-th elements of L of the form [Xi, Wi,  Yi, Hi] where (Xi, Yi) represent 
      2D coordinates and (Wi, Hi) size in width and height.

We set a recursion-generating call to generate such list, using (Xi, Yi) as Rows and Columns, and 
Size as the size of the square (it is trivial that Wi=Hi!)
*/
setPositions([Size|Sides], [R|RowVars], [C|ColVars], [L|List]):-
    L = rec(R, Size, C, Size), % recursion call
    %write('L -> '), write(L), nl, DEBUG
    setPositions(Sides, RowVars, ColVars, List),
    true.
setPositions(_, [], [], []).


nonoverlapping(_, Sides, RowVars, ColVars):- 
    setPositions(Sides, RowVars, ColVars, List),
    disjoint2(List).

main:- 
    NEx is 3,
    ejemplo(NEx, Big, Sides),
    nl, write('Fitting all squares of size '), write(Sides), 
    write(' into big square of size '), write(Big), nl,nl,
    
    % Domains
    length(Sides, N),   % get list of N prolog vars:
    length(RowVars, N), %  -> Row coordinates of each small square
    length(ColVars, N), %  -> Col coordinates of each small square
    RowVars ins 1..Big,
    ColVars ins 1..Big,
    
    % Constraints
    insideBigSquare(N, Big, Sides, RowVars),
    insideBigSquare(N, Big, Sides, ColVars),
    nonoverlapping(N, Sides, RowVars, ColVars),
    
    % Labeling and output
    append(RowVars, ColVars, ALL), labeling([ff], ALL),
    displaySol(N, Sides, RowVars, ColVars). % ,halt.


displaySol(N, Sides, RowVars, ColVars):- 
    between(1,N,Row), nl, 
    between(1,N,Col), %nl,
    nth1(K,Sides,S),    
    nth1(K,RowVars,RV),    RVS is RV+S-1,     between(RV,RVS,Row),
    nth1(K,ColVars,CV),    CVS is CV+S-1,     between(CV,CVS,Col),
    writeSide(S), fail.
displaySol(_,_,_,_):- nl,nl,!.

writeSide(S):- S<10, write('  '),write(S),!.
writeSide(S):-       write(' ' ),write(S),!.


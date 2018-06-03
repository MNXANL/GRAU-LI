:- use_module(library(clpfd)).

%        ID NxN  [S1² .. SN²]
%ejemplo(_, Big, [S1...SN]): 
%how to fit all squares of sizes S1...SN in a square of size Big?

ejemplo(0,   3, [2, 1, 1, 1, 1, 1]).
ejemplo(1,   4, [2, 2, 2, 1, 1, 1,1]).
ejemplo(2,   5, [3, 2, 2, 2, 1, 1 ,1, 1]).
ejemplo(3,  19, [10, 9, 7,6,4,4,3,3,3,3,3,2,2,2,1,1,1,1,1,1]).
ejemplo(4, 112, [50, 42, 37,35,33,29,27,25,24,19,18,17,16,15,11,9,8,7,6,4,2]).
ejemplo(5, 175, [81, 64, 56,55,51,43,39,38,35,33,31,30,29,20,18,16,14,9,8,5,4,3,2,1]).

% Emplace in second list all posible 
insideBigSquare(N, BigSq, [Hs|Ts], [Hv|Tv]):-
    FS is (BigSq - Hs) + 1, % Free space we have to move a piece to big square
    Hv in 1..FS,            % Possible values of the moved piece
    insideBigSquare(N, BigSq, Ts, Tv).
insideBigSquare(_, _, [], []).




noIndividualOL(Sd, Row, Col,   [Sd2|Sides], [Row2|Rows], [Col2|Cols]):-
    RowUpperBound #= Row + Sd,   ColUpperBound #= Col + Sd,
    RowLowerBound #= Row - Sd2,  ColLowerBound #= Col - Sd2,
    % Target: be sure that row is under the first side's bound and over the next side's bound, so it will not overlap.
    #\ (    Row2 #< RowUpperBound  
        #/\ Row2 #> RowLowerBound  
        
        #/\ Col2 #< ColUpperBound  
        #/\ Col2 #> ColLowerBound 
    ),  
    noIndividualOL(Sd, Row, Col,   Sides, Rows, Cols).
noIndividualOL(_, _, _, [], [], []).


% Generate combinations that forbid overlapping pieces
nonoverlapping(N, [Hs|Ts], [Hr|Tr], [Hc|Tc]):-
    noIndividualOL(Hs, Hr, Hc,   Ts, Tr, Tc),
    nonoverlapping(N,  Ts, Tr, Tc).
nonoverlapping(_, [], [], []).

main:- 
    ejemplo(1, Big, Sides),
    nl, write('Fitting all squares of size '), write(Sides), write(' into big square of size '), write(Big), nl,nl,
    length(Sides,N), 
    length(RowVars,N), % get list of N prolog vars: Row coordinates of each small square
    insideBigSquare(N,Big,Sides,RowVars),
    insideBigSquare(N,Big,Sides,ColVars),
    nonoverlapping(N,Sides,RowVars,ColVars),
    label(RowVars),
    label(ColVars),
    %% write(RowVars), nl,
    %% write(ColVars), nl,

    displaySol(N,Sides,RowVars,ColVars), halt.


displaySol(N,Sides,RowVars,ColVars):- 
    between(1,N,Row), nl, between(1,N,Col),
    nth1(K,Sides,S),    
    nth1(K,RowVars,RV),    RVS is RV+S-1,     between(RV,RVS,Row),
    nth1(K,ColVars,CV),    CVS is CV+S-1,     between(CV,CVS,Col),
    writeSide(S), fail.
displaySol(_,_,_,_):- nl,nl,!.

writeSide(S):- S<10, write('  '),write(S),!.
writeSide(S):-       write(' ' ),write(S),!.


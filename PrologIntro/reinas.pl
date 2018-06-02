%% 3. Haz un programa prolog que escriba la manera de colocar sobre un tablero de
%%    ajedrez ocho reinas sin que éstas se ataquen entre sí.
%%    Por ejemplo, ésta sería una solucion:
         
%%       . . x . . . . .
%%       . . . . . x . .
%%       . . . x . . . .
%%       . x . . . . . .
%%       . . . . . . . x
%%       . . . . x . . .
%%       . . . . . . x .
%%       x . . . . . . .
%%      [8,4,1,3,6,2,7,5]

%%  NOP  . . x . . . . .
%%       . . . . . x . .
%%       . . . x . . . .
%%       . . . . . . x .
%%       . . . . . . . x
%%       . . . . x . . .
%%       . x . . . . . .
%%       x . . . . . . .
%%      [8,7,1,3,6,2,4,5]

noDiagKills(_, [], _).
noDiagKills(Head, [Tail|More], Size):-
    K is abs(Head - Tail),
    K \= Size,
    
    S1 is Size + 1, 
    noDiagKills(Head, More, S1).


attack([_]).
attack([Lhead|Ltail]):-
    noDiagKills(Lhead, Ltail, 1),
    attack(Ltail).

reinas:-
    permutation([1,2,3,4,5,6,7,8], L), 
    attack(L),
    write('RESULT: '), write(L), nl.
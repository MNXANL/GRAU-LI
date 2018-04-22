main:- 

    F = -(1 * -2) + 3 * (2+1),  

    assertz(nextvarNum(4)), % necesario para utilizar newvar

    tseitin(F,RootVar), writec([RootVar]), nl, !.

tseitin(F*G, X):- 
    tseitin(F, A), 
    tseitin(G, B), 
    newvar(X),
    writeClauses(X=A*B),
    !.

tseitin(F+G, X):-  
    tseitin(F, A), 
    tseitin(G, B), 
    newvar(X),
    writeClauses(X=A+B),
    !.

tseitin(-F,-X):- 
    tseitin(F,X), !.

tseitin(P,P).

writeClauses( Z=X*Y ):- 
    writec([-Z, X]),
    writec([-Z, Y]),
    writec([Z, -X, -Y]),
    !.

writeClauses( Z=X+Y ):- 
    writec([Z, -X]),
    writec([Z, -Y]),
    writec([-Z, X, Y]),
    !.

writec( []    ):- 
    write('0'), 
    nl,!.

writec( [X|C] ):- 
    Lit is X, 
    write(Lit), 
    write(' '), 
    writec(C),!.

newvar(X):- 
    retract(nextvarNum(X)), 
    X1 is X+1, 
    assertz(nextvarNum(X1)),!.

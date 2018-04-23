p:- readclauses(F), dpll([],F).
p:- write(’UNSAT’),nl.

dpll(I,[]):- write(’IT IS SATISFIABLE. Model: ’), write(I),nl,!.
dpll(I,F):-
	decision_lit(F,Lit),
	simplif(Lit,F,F1),
	dpll( [Lit|I], F1 ).

decision_lit(F,Lit):- member([Lit],F),!. % unit propagation if possible
decision_lit([[Lit|_]|_],Lit). % otherwise, select 1st lit of 1st clause of F
decision_lit([[Lit|_]|_],Lit1):- Lit1 is -Lit. % or its negation!

simplif(_,[],[]).
simplif(Lit, [C|S], S1 ):- % remove true clause (clause containing Lit)
	member( Lit, C ), !,
	simplif(Lit,S,S1), !.
simplif(Lit, [C|F], [C1|F1] ):- % remove false lit -Lit from clause
	Lit1 is -Lit,
	memberAndRest( Lit1, C, C1 ),!,
	C1 \= [], % causes failure if empty clause detected
	simplif(Lit,F,F1),!.
	simplif(Lit, [C|F], [C|F1] ):- % nothing to simplify in 1st clause
	simplif(Lit,F,F1),!.

memberAndRest(X,[X|L],L).
memberAndRest(X,[Y|L],[Y|L1]):- memberAndRest(X,L,L1).
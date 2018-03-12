%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Basic functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pert(X,[X|_]).
pert(X,[_|L]):- pert(X,L).
 
concat([],L,L).
concat([X|L1],L2,[X|L3]):- concat(L1,L2,L3). 	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 2. (dificultad 1) Escribe un predicado Prolog prod(L,P) que signifique “P es el
%% producto de los elementos de la lista de enteros dada L”. Debe poder generar la
%% P y también   comprobar una P dada.

prod([], 1).
prod([X|L], P):-
	prod(L, P1),
	P is P1 * X.

%% 3. (dificultad 1) Escribe un predicado Prolog pescalar(L1,L2,P) que signifique
%% “P es el producto escalar de los dos vectores L1 y L2”. Los dos vectores vienen
%% dados por las dos listas de enteros L1 y L2. El predicado debe fallar si los dos
%% vectores tienen una longitud distinta.


pescalar([], [], 0).
pescalar([X|L1], [Y|L2], P):-
	length(L1) == length(L2),
	pescalar(L1, L2, P1),
	P is (X*Y) + P1.



%% 4. (dificultad 2) Representando conjuntos con listas sin repeticiones, escribe predi-
%% cados para las operaciones de intersección y unión de conjuntos dados.

unio([], L, L):- !.
unio([X|L1], L2, U) :- 
	member(X, L2), !, 
	unio(L1, L2, U).
unio([X|L1], L2, [X|U]) :-
	unio(L1, L2, U). 

interseccio([], _, []):- !.
interseccio([X|L1], L2, [X|I]) :-
	member(X, L2), !, 
	interseccio(L1, L2, I).
interseccio([_|L1], L2, I) :- 
	interseccio(L1, L2, I).

%% 5. (dificultad 2) Usando el concat, escribe predicados para el último de una lista
%% dada, y para el inverso de una lista dada.

ultimo([Last], Last).
ultimo(List, Last) :-
	concat(_, [Last], List), !.
	
reverso([], []):- !.
reverso(List, LRev):-
	length(Fst, 1), 
	concat(Fst, Tail, List),
	reverso(Tail, SL),
	concat(SL, Fst, LRev).

%% 6. (dificultad 3) Escribe un predicado Prolog fib(N,F) que signifique “F es el N-
%% ésimo número de Fibonacci para la N dada”. Estos números se definen como:
%% fib(1) = 1, fib(2) = 1, y, si N > 2, como: fib(N) = fib(N − 1) + fib(N − 2).

fib(1, 1):- !.
fib(2, 1):- !.
fib(N, F):-
	N > 2,	N1 is N-1, fib(N1, F1),
			N2 is N-2, fib(N2, F2),
	F is F1 + F2.

%% 7. (dificultad 3) Escribe un predicado Prolog dados(P,N,L) que signifique “la lista
%% L expresa una manera de sumar P puntos lanzando N dados”. Por ejemplo: si P es
%% 5, y N es 2, una solución sería [1,4]. (Nótese que la longitud de L es N). Tanto
%% P como N vienen instanciados. El predicado debe ser capaz de generar todas las
%% soluciones posibles.

sum([], 0).
sum([X|L], P):-
	sum(L, P1),
	P is P1+X.

dados(_, 0, []).

dados(P, N, L):-
	sum(L, P),
	length(L, N).

dados(P1, N1, L):-
	between(1, 6, X),
	Px is P1 - X,
	dados(Px, N, [X|L]).


%% 8. (dificultad 2) Escribe un predicado suma_demas(L) que, dada una lista de en-
%% teros L, se satisface si existe algún elemento en L que es igual a la suma de los
%% demás elementos de L, y falla en caso contrario.

suma_demas(L, X):- 
	concat(L1, [X|L2], L),
	sum(L1, Y),	sum(L2, Z),
	X = Y+Z.

%% 9. (dificultad 2) Escribe un predicado suma ants(L) que, dada una lista de ente-
%% ros L, se satisface si existe algún elemento en L que es igual a la suma de los
%% elementos anteriores a él en L, y falla en caso contrario.

suma_ants(L):-
	concat(L1, [X|_], L),
	sum(L1, Y), X = Y.

%% 10. (dificultad 2) Escribe un predicado card(L) que, dada una lista de enteros L,
%% escriba la lista que, para cada elemento de L, dice cuántas veces aparece este
%% elemento en L. Por ejemplo, card( [1,2,1,5,1,3,3,7] ) escribirá
%% [[1,3],[2,1],[5,1],[3,2],[7,1]].



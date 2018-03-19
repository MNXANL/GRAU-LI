%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Basic functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pert(X,[X|_]).
pert(X,[_|L]):- pert(X,L).
 
concat([],L,L).
concat([X|L1], L2, [X|L3]):- concat(L1, L2, L3). 	

pert_con_resto(X,L,Resto):- 
	concat(L1,[X|L2], L ),
	concat(L1, L2, Resto).

long([],0). % longitud de una lista
long([_|L],M):- 
	long(L,N), M is N+1.

factores_primos(1,[]) :- !.
factores_primos(N,[F|L]):- 
	nat(F), F>1, 0 is N mod F,
	N1 is N // F, 
	factores_primos(N1,L),!.

permutacion([],[]).
permutacion(L,[X|P]) :- 	
	pert_con_resto(X,L,R), 
	permutacion(R,P).

subcjto([],[]). %subcjto(L,S) es: "S es un subconjunto de L".
subcjto([X|C],[X|S]):-subcjto(C,S).
subcjto([_|C],S):-subcjto(C,S).

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

% % % % % % % % % % 

dados(P, N, L):-
	P > 0,
	between(1, 6, X),
	Px is P - X,
	Px >= 0,
	dados(Px, N, [X|L]).
dados(0, N, L):-
	length(L, N), 
	write(L), nl.
dados(_, 0, []).


%% 8. (dificultad 2) Escribe un predicado suma_demas(L) que, dada una lista de en-
%% teros L, se satisface si existe algún elemento en L que es igual a la suma de los
%% demás elementos de L, y falla en caso contrario.

suma_demas(L):- 
	concat(L1, [X|L2], L),
	sum(L1, Y),	sum(L2, Z),
	X = Y+Z.

%% 9. (dificultad 2) Escribe un predicado suma_ants(L) que, dada una lista de ente-
%% ros L, se satisface si existe algún elemento en L que es igual a la suma de los
%% elementos anteriores a él en L, y falla en caso contrario.

suma_ants(L):-
	concat(L1, [X|_], L),
	sum(L1, Y), X = Y.

%% 10. (dificultad 2) Escribe un predicado card(L) que, dada una lista de enteros L,
%% escriba la lista que, para cada elemento de L, dice cuántas veces aparece este
%% elemento en L. Por ejemplo, card( [1,2,1,5,1,3,3,7] ) escribirá
%% [[1,3],[2,1],[5,1],[3,2],[7,1]].

no_dups(_, [], []).
no_dups(X, [X|L], LS):- no_dups(X, L, LS).
no_dups(X, [Y|L], [Y|LS]) :-
	X \= Y,
	no_dups(X, L, LS).


card(L) :- carderino(L, Res), write(Res), nl, !.

carderino([], []).
carderino([X|L], [[X, N]|Res]):-
	findall(X, member(X, [X|L]), Nums),
	length(Nums, N),
	no_dups(X, L, Lnr),
	carderino(Lnr, Res).


%% 11. (dificultad 2) Escribe un predicado Prolog esta_ordenada(L) que signifique
%% “la lista L de numeros enteros está ordenada de menor a mayor”. Por ejemplo, ´
%% con ?-esta_ordenada([3,45,67,83]). dice yes
%% Con ?-esta_ordenada([3,67,45]). dice no.

esta_ordenada([X|L]) :- esta_ordenada_imm(L, X).

esta_ordenada_imm([], _):- !.
esta_ordenada_imm([Y], X) :- Y >= X, !.
esta_ordenada_imm([Y|L], X) :- 
	Y >= X,
	esta_ordenada_imm(L, Y).

%% 12. (dificultad 2) Escribe un predicado Prolog ordenacion(L1,L2) que signifique
%% “L2 es la lista de enteros L1 ordenada de menor a mayor”. Por ejemplo: si L1 es
%% [8,4,5,3,3,2], L2 sera´ [2,3,3,4,5,8]. Hazlo en una l´ınea, utilizando solo ´
%% los predicados permutaci´on y est´a ordenada.

ordenacion(L1, L2):- 
	permutacion(L1, L2), 
	esta_ordenada(L2), !.


%% 14. (dificultad 3) Escribe un predicado Prolog ordenacion(L1,L2) basado en el
%% metodo de la inserci ´ on, usando un predicado ´ insercion(X,L1,L2) que signi-
%% fique: “L2 es la lista obtenida al insertar X en su sitio en la lista de enteros L1 que
%% esta ordenada de menor a mayor”. ´

insercion(X, L, Lins):-
	concat(L1, L2, L),
	concat(L1, [X|L2], Lins),
	esta_ordenada(Lins).

insertsort([], []).
insertsort([X|L], Lsort) :-
	insercion(X, [X|L]).

%% 16. (dificultad 3) Escribe un predicado Prolog ordenaci´on(L1,L2) basado en el
%% metodo de la fusi ´ on ( ´ merge sort): si la lista tiene longitud mayor que 1, con
%% concat divide la lista en dos mitades, ordena cada una de ellas (llamada recursiva)
%% y despues fusiona las dos partes ordenadas en una sola (como una “crema- ´
%% llera”). Nota: este algoritmo puede llegar a hacer como mucho n log n comparaciones
%% (donde n es el tamano de la lista), lo cual es demostrablemente ˜ optimo. ´


concatsort([], L, L).
concatsort([X|L1], [Y|L2], [X|L3]):- 
	concatsort(L1, [Y|L2], L3).
concatsort([X|L1], [Y|L2], [X|L3]):- 
	concatsort(L1, [Y|L2], L3).

% Predicate that splits an N in two (a)symmetrical halves.
twohalves(N, N1, N2):-
	N1 is N // 2, 
	N2 is N - N1.


mergesort([X], [X]).
mergesort(L, Lsorted):-
	concat(L1, L2, L),
	length(L, N), 
	twohalves(N, N1, N2),
	length(L1, N1), length(L2, N2),
	
	mergesort(L1, Ls1),
	mergesort(L2, Ls2),
	concatsort(Ls1, Ls2, Lsorted),
	esta_ordenada(Lsorted).


%% 17. (dificultad 4) Escribe un predicado diccionario(A,N) que, dado un alfabeto
%% A de s´ımbolos y un natural N, escriba todas las palabras de N s´ımbolos, por
%% orden alfabetico (el orden alfab ´ etico es seg ´ un el alfabeto ´ A dado). Ejemplo:
%% diccionario( [ga,chu,le],2) escribira:´
%% gaga gachu gale chuga chuchu chule lega lechu lele.
%% Ayuda: define un predicado nmembers(A,N,L), que utiliza el pert para obtener
%% una lista L de N s´ımbolos, escr´ıbe los s´ımbolos de L todos pegados, y provoca
%% backtracking.



%% 18. (dificultad 3) Escribe un predicado palindromos(L) que, dada una lista de letras
%% L, escriba todas las permutaciones de sus elementos que sean pal´ındromos
%% (capicuas). ´
%% Ex: palindromos([a,a,c,c]) escribe [a,c,c,a] y [c,a,a,c].

tail([], []).
tail([_|L], [L]).

palindromos(L) :-
	permutacion(L, Lx),
	length(L, N),
	0 is N mod 2,
	twohalves(N, N1, N2), 
	concat(L1, L2, Lx),
	length(L1, N1), 
	length(L2, N2),
	reverso(L1, L2), 
	write(Lx), nl.
palindromos(L) :-
	permutacion(L, Lx),
	length(L, N),
	1 is N mod 2,
	twohalves(N, N1, _), 
	concat(L1, [_|L2], Lx),
	length(L1, N1), 	length(L2, N1),
	reverso(L1, L2), 
	write(Lx), nl.



%% 19. (dificultad 4) ¿Que 8 d ´ ´ıgitos diferentes tenemos que asignar a las letras
%% S,E,N,D,M,O,R,Y, de manera que se cumpla la suma SEND+MORE=MONEY? Resuelve
%% el problema en Prolog con un predicado suma que sume listas de d´ıgitos.
%% El programa debe decir “no” si no existe solucion. ´

join_verse(Verse) :-
	permutacion([1, 2, 3, 4,  5, 6, 7, 8], [S,E,N,D, M,O,R,Y]),
	Join is 1000*(S+M) + 100*(E+O) + 10*(N+R) + (D+E),
	Verse is 10000*M + 1000*O + 100*N + 10*E + Y,
	Join = Verse, !.



%% 20. (dificultad 4) Escribe el predicado simplifica que se ha usado con el programa
%% de calcular derivadas.

der(X,X,1):-!.
der(C,_,0):- number(C).
der(A+B,X,DA+DB):- der(A,X,DA),der(B,X,DB).
der(A-B,X,DA-DB):- der(A,X,DA),der(B,X,DB).
der(A*B,X,A*DB+B*DA):- der(A,X,DA),der(B,X,DB).
der(sin(A),X,cos(A)*DA):- der(A,X,DA).
der(cos(A),X,-sin(A)*DA):- der(A,X,DA).
der(eˆA,X,DA*eˆA):- der(A,X,DA).
der(ln(A),X,DA*1/A):- der(A,X,DA).

%% ?-der( 2*x*x + 3*x, x, D), simplifica(D,D1).
%% 	  D  = 2*x*1+x*(2*1 + x*0)+(3*1 + x*0)
%%    D1 = 4*x + 3
%% yes


%% 21. (dificultad 4) Tres misioneros y tres can´ıbales desean cruzar un r´ıo. Solamente
%% se dispone de una canoa que puede ser utilizada por 1 o 2 personas: misioneros ´
%% o can ´ ´ıbales. Si los misioneros quedan en minor´ıa en cualquier orilla, los can´ıbales
%% se los comeran. Escribe un programa Prolog que halle la estrategia para que todos ´
%% lleguen sanos y salvos a la otra orilla.
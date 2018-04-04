%% 1. Dado un natural N, definimos la secuencia de naturales que empieza
%%    por N y en la que cada número es igual a la suma de los cuadrados
%%    de los dígitos del número anterior. Ejemplo: 44, 32, 13, 10, 1.

%%    Escribe un predicado Prolog que, dado un número N, determine si
%%    dicha secuencia converge a 1. Nota: el predicado debería detectar
%%    ciclos que no contienen el uno para evitar la no-terminación del
%%    programa.

numberToList(N, [N]):- N >= 0, 10 > N, !.
numberToList(N, [X|L]):-
    number(N), N >= 10,    N1 is N // 10,    X is N mod 10,
    numberToList(N1, L),
    true.

numToList(N, L):- numberToList(N, Lr), reverse(Lr, L).


sumSquare([], 0).
sumSquare([X|L], N):-
    sumSquare(L, N1),
    N2 is X*X,
    N is N1 + N2,
    true.

conv(N):-
  numToList(N, L),
  sumSquare(L, N1),
  N1 >= 10,
  conv(N1), !.
  
conv(N):-
  numToList(N, L),
  sumSquare(L, N1),
  N1 = 1, !.
  







%% 2. Tenemos una fila de cinco casas, con cinco vecinos con casas de
%% colores diferentes, y cinco profesiones, animales, bebidas y
%% nacionalidades diferentes, y sabiendo que:

%%     1 + El que vive en la casa roja es de Peru
%%     2 + Al frances le gusta el perro
%%     3 + El pintor es japones
%%     4 + Al chino le gusta el ron
%%     5 + El hungaro vive en la primera casa
%%     6 + Al de la casa verde le gusta el coñac
%%     7 + La casa verde esta a la izquierda de la blanca
%%     8 + El escultor cría caracoles
%%     9 + El de la casa amarilla es actor
%%    10 + El de la tercera casa bebe cava
%%    11 + El que vive al lado del actor tiene un caballo
%%    12 + El hungaro vive al lado de la casa azul
%%    13 + Al notario la gusta el whisky
%%    14 + El que vive al lado del medico tiene un ardilla,
%                       
%% Escribe un programa Prolog que averigue para cada persona todas sus 
%% caracteristicas de la forma:
% [num_casa, color, profesion, animal, bebida, pais] 
%% averiguables. No todas las características se pueden averiguar.

%% Ayuda: sigue el siguiente esquema:

casaVerdeBlanca(Verde, Blanca):- vecinoLeft(Verde, Blanca).

vecinos(A, B):- vecinoLeft(A, B).
vecinos(A, B):- vecinoRight(A, B).

vecinoLeft(A, B):-
  between(1, 4, A),
  between(2, 5, B),
  A is B-1.

vecinoRight(A, B):-
  between(2, 5, A),
  between(1, 4, B),
  A is B+1.

casas:-	
    Sol = [	
        [1,A1,B1,C1,D1,E1],
  		[2,A2,B2,C2,D2,E2],
  		[3,A3,B3,C3,D3,E3],
  		[4,A4,B4,C4,D4,E4],
  		[5,A5,B5,C5,D5,E5] 
    ],
    
    % member(  [1, A, B, C, D, E] , Sol),
    member( [_, roja,     _,        _,       _,      peru] ,    Sol),
    member( [_, _,        _,        perro,   _,      francia] , Sol),
    member( [_, _,        pintor,   _,       _,      japon] ,   Sol),
    member( [_, _,        _,        _,       ron,    china] ,   Sol),
    member( [1, _,        _,        _,       _,      hungria] , Sol),
    member( [G, verde,    _,        _,       cognac, _] ,       Sol),
    member( [W, blanca,   _,        _,       _,      _] ,       Sol), casaVerdeBlanca(G, W),
    member( [_, _,        escultor, caracol, _,      _] ,       Sol),
    member( [X, amarilla, actor,    _,       _,      _] ,       Sol),
    member( [3, _,        _,        _,       cava,   _] ,       Sol),
    member( [Y, _,        _,        caballo, _,      _] ,       Sol), vecinos(X, Y),
    member( [2, azul,     _,        _,       _,      _] ,       Sol),
    member( [_, _,        notario,  _,       whisky, _] ,       Sol),
    member( [A, _,        medico,   _,       _,      _] ,       Sol),
    member(  [B, _,        _,        ardilla, _,      _] ,       Sol), vecinos(A, B),
	
    write(Sol), nl,!.


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

cabeza([Fst], Fst):- !.
cabeza(Lst, Fst):- append([Fst], _, Lst), !.

ultimo([Last], Last):- !.
ultimo(List, Last) :-
    append(_, [Last], List), !.

notAttack(L):-
    between(2, 8, Len),
    append(Lx, Partition, Ly), append(Ly, Lz, L),
    length(Lx, A), length(Lz, B), length(Partition, Len),
    write(Partition), nl,
    8 is A+Len+B,
    cabeza(Partition, X), ultimo(Partition, Y),
    L1 is Len-1,
    L1 \= abs(X-Y),
    write(L),
    fail.


reinas:-
    permutation([1,2,3,4,5,6,7,8], L),
    notAttack(L),
    fail.
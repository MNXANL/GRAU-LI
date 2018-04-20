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
  




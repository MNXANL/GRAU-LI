NOTA: para los ejercicios 1 y 2 no pueden usarse predicados predefinidos de Prolog.  Implementa todo los predicados que necesites.

1.- [3 puntos] Construye un predicado Prolog creciente_suma(L,K,S) tal que dada una lista de enteros L y un número K, determine si existe dentro de L una subsecuencia creciente (no estrictamente) de números S que sume K. Bajo backtrack debería calcular todas las subsecuencias L posibles. Ejemplo:

?- creciente_suma([3,5,2,8,3,10],21,S).

S = [3, 8, 10] ;

false.

?- creciente_suma([3,5,2,8,3,10],7,S).

false.

?- creciente_suma([3,5,2,8,3,10],13,S).

S = [3, 10] ;

S = [5, 8] ;

S = [3, 10] ;

false.

Envía un archivo con el nombre p1.pl (exactamente este nombre, no se admitirán cambios!)

2.- [3 puntos] Construye un predicado Prolog igual_particion(L,S1,S2)

tal que dada una lista de enteros L, determine si se puede partir L en dos partes S1 y S2 tales que sumen igual. Bajo backtrack debería calcular todas las posibles S1 y S2. Ejemplo:

?- igual_particion([1,5,2,3,4,7],S1,S2).

S1 = [1, 5, 2, 3],

S2 = [4, 7] ;

S1 = [1, 3, 7],

S2 = [5, 2, 4] ;

S1 = [5, 2, 4],

S2 = [1, 3, 7] ;

S1 = [4, 7],

S2 = [1, 5, 2, 3] ;

false.

Envía un archivo con el nombre p2.pl (exactamente este nombre, no se admitirán cambios!)

3.- [4 puntos] Completa el programa de Prolog roads.pl que encontrarás dentro del archivo adjunto ej3.tgz.

Envía un archivo con el nombre roads.pl (exactamente este nombre, no

se admitirán cambios!)

%%%%%%%%%%%%%% case 1: stations.pl:
writeClauses(K):-    eachCityCovered, atMostKStations(K).

eachCityCovered:- city(_,L), findall(used-S, member(S,L), Lits), writeClause(Lits), fail.
eachCityCovered.

atMostKStations(K):- numStations(N), findall(used-S, between(1,N,S), Lits), atMost(K,Lits), fail.
atMostKStations(_).

% Prolog predicates to be implemented: Given a model M, Cost is its cost:
cost(M,Cost):-  findall(S,member(used-S,M),L), length(L,Cost),!.
displaySol(M):- findall(S,member(used-S,M),L), sort(L,L1), member(S,L1), write(S), write(' '), fail.
displaySol(_).

%%%%%%%%%%%%%% case 2: important.pl; add this to writeClauses:
importantCities:- city(C,L), member(C,[1,5,10,20]), findall(used-S, member(S,L), Lits), atLeast(2,Lits), fail.
importantCities.
%%%%%%%%%%%%%% case 3: costs.pl; add/replace this:
costVars:- between( 1, 5,S), writeClause([\+used-S,cost-S-1]), writeClause([\+used-S,cost-S-2]), fail.
costVars.

atMostCostK(K):- findall( used-S,   between(11,20,S), Lits1), %cost-1 stations 
                 findall( cost-S-1, between( 1, 5,S), Lits2), %cost-2 
                 findall( cost-S-2, between( 1, 5,S), Lits3), %cost-2 
                 append(Lits1,Lits2,Lits12), append(Lits12,Lits3,Lits), atMost(K,Lits), fail.
atMostCostK(_).

cost(M,Cost):-  findall(S, (member(used-S,M),between(11,20,S)), L1), length(L1,N1),
                findall(S, (member(used-S,M),between( 1, 5,S)), L2), length(L2,N2),  Cost is N1 + 2*N2,!. 
%%%%%%%%%%%%%%%%

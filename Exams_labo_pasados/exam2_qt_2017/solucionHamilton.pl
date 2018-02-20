writeClauses(K):-init, eachNodeVisited, noTrajectIfThereIsNoCorrespondingEdge,
                 exactlyOnePthNodeVisited, urgentNodeNotAfterPositionK(K).

init:- numNodes(N),  writeClause([ visited-1-0 ]),  writeClause([ visited-1-N ]), fail.
init.

eachNodeVisited:-  node(Node),  findall(visited-Node-P, position(P), Lits),  writeClause(Lits), fail.
eachNodeVisited.

noTrajectIfThereIsNoCorrespondingEdge:- node(Node1), node(Node2), adjacency(Node1,L), \+member(Node2,L),
                                        position(P1),  position(P2), P2 is P1+1,
                                        writeClause([ \+visited-Node1-P1, \+visited-Node2-P2 ]), fail.
noTrajectIfThereIsNoCorrespondingEdge.

exactlyOnePthNodeVisited:- position(P), findall(visited-Node-P,node(Node),Lits), exactly(1,Lits), fail.
exactlyOnePthNodeVisited.

urgentNodeNotAfterPositionK(K):- urgentNode(UNode), position(P), P>K, writeClause([ \+visited-UNode-P ]), fail.
urgentNodeNotAfterPositionK(_).

% Given model M, computes its cost: 
cost(M,Cost):- urgentNode(UNode), member( visited-UNode-Cost, M ), !.

displaySol(M):- position(P), member(visited-Node-P,M), write(Node), write(' '), fail.
displaySol(_):- nl.

%%%%%%% add/replace this for extension shortest.pl:
costVars:-    node(Node1), adjacency(Node1,L), member(Node2,L), 1 is (Node1+Node2) mod 2,
              position(P1), position(P2), P2 is P1+1,
              writeClause([ \+visited-Node1-P1, \+visited-Node2-P2, costTraject-P2 ]), fail.
costVars:-    node(Node1), adjacency(Node1,L), member(Node2,L), 0 is (Node1+Node2) mod 2,
              position(P1), position(P2), P2 is P1+1,
              writeClause([ \+visited-Node1-P1, \+visited-Node2-P2, \+costTraject-P2 ]), fail.
costVars.

sumCostsAtMost(K):- findall( costTraject-P, position(P), Lits ), atMost(K,Lits), fail.
sumCostsAtMost(_).

cost(M,Cost):- findall( P, member( costTraject-P, M ), L), length(L,Cost), !.
%%%%%%%

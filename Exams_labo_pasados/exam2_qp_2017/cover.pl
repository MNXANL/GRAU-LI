:-use_module(library(clpfd)).

nVertices(5).
edge(1,2).
edge(1,3).
edge(2,3).
edge(3,4).
edge(4,5).
edge(5,1).
edge(5,2).

coverEdges(Vars) :-
    nVertices(N),
    between(1, N, V),
    nth1(V, Vars, X),
    
    
    
    coverEdges(Tv).
coverEdges([]).

atMostKVertices([_|Tv], K) :-
    K1 is K - 1,
    atMostKVertices(Tv, K1),
    sum(Tv, #=, K1).
atMostKVertices([], 0).


displaySolCover(Vars):-
    nVertices(N),
    between(1, N, V),
    nth1(V, Vars, X), %% X is the V-th element of the list Vars (first element has index 1)
    write('Chosen('), write(V), write(') = '), write(X), nl, fail.
displaySolCover(_).

cover(K):-
    nVertices(N),
    length(Vars, N),
    
    Vars ins 0..1,
    coverEdges(Vars),   %each edge has A. L. 1 of its extreme points chosen (implement)
    atMostKVertices(Vars, K), % we choose at most K vertices (implement)
    
    label(Vars), !,
    displaySolCover(Vars).


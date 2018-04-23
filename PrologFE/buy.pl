/*
In order to have a nice studying place at home, we decide to build a table. After some investigation,
we know that we need the following tools:

E = [screws,hammer,saw,screwdriver,wood,paint,brush].

Once we go to the appropriate shop, we realize that in order to save money we must buy packs of
tools. The following packs, all with the same price, are available (Matrix P)

Construct a Prolog predicate buy(E,P) that, given a set of tools E and a pack list P, writes the
minimum number of packs that one needs to buy in order to have all necessary tools.
In this case, a possible output would be:
Number of packs: 3
[[screws,screwdriver],[wood,brush,paint],[hammer,saw,screwdriver]]


*/

P =  [
	[screws,screwdriver],
	[wood,brush,paint],
	[hammer,wood],
	[saw,screws],
	[paint,brush],
	[hammer,saw,screwdriver] 
].


buy(E,P):- 
	nat(N), subset(P,S), length(S,N), coveredBy(E,S),
	write(’Number of packs: ’), write(N), nl, write(S), nl.

% coveredBy(E,S): "each tool of E is in some pack of S"
coveredBy( [], _ ).
coveredBy( [X|L], S ):- member(P,S), member(X,P), coveredBy(L,S).

nat(0).
nat(N):- nat(N1), N is N1+1.

subset( [], [] ).
subset( [X|L], [X|S] ):- subset(L,S).
subset( [_|L], S ):- subset(L,S).
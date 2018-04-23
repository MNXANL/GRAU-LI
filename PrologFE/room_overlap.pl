initialHour(10).
finalHour(22).
meeting( 1, [7,28,180,235], 3). % meeting 1: these four people, during 3 hours
meeting( 2, [6,7,8], 2). % meeting 2: these three people, during 2 hours
% more clauses for meeting

blocking(28,17). % person 28 cannot attend meetings at 17 o’clock
% more clauses for blockings
numSmallRooms(8). % rooms 1-8
numLargeRooms(5). % rooms 9-13

solution:- findall([N,S,D], meeting(N,S,D), L), schedule(L,Sol), write(Sol), nl.
schedule( [], [] ).
schedule( [[N,S,D]|L], [[N,S,D,Hour,Room]|Sched] ):-
	schedule(L,Sched),
	initialHour(IH), finalHour(FH), FH1 is FH-D, between(IH,FH1,Hour),
	\+blockingProblem(Hour,S,D), % no blocking problem
	length(S,Num), room(Num,Room), % Room is a adequate for Num people
	\+roomsOverlap(D,Hour,Room, Sched), % no room overlapping problem
	\+attendantsOverlap(S,D,Hour, Sched). % no attendants overlapping problem
	% Sched contains some overlapping meeting in the same room:


% Sched contains some overlapping meeting in the same room:
roomsOverlap( D,H,R, Sched):- member([_, _,D2,H2,R],Sched),
End is H+D-1, End2 is H2+D2-1, between(H,End,X), between(H2,End2,X).

% some attendant is blocked during this period:
blockingProblem(H,S,D):- End is H+D-1, member(J,S), blocking(J,X), between(H,End,X).

% some attendant has another meeting overlapping with this one
attendantsOverlap(S,D,H, Sched):- member([_,S2,D2,H2,_],Sched), member(J,S),member(J,S2),
End is H+D-1, End2 is H2+D2-1, between(H,End,X), between(H2,End2,X).


% Aux vars for rooms

room(N,R):-N<26,!,numSmallRooms(S),numLargeRooms(L), T is S+L, between(1,T,R).
room(N,R):-N<51, numSmallRooms(S),numLargeRooms(L), T is S+L, K is S+1, between(K,T,R).
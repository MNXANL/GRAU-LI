:-include(entradaPacking1).
:-dynamic(varNumber/3).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% We are given a large rectangular piece of cloth from which we want
%% to cut a set of smaller rectangular pieces. The goal of this problem
%% is to decide how to cut those small pieces from the large cloth, i.e.
%% how to place them. 
%%
%% Note 1: The smaller pieces cannot be rotated.
%% 
%% Note 2: All dimensions are integer numbers and are given in
%% meters. Additionally, the larger piece of cloth is divided into
%% square cells of dimension 1m x 1m, and every small piece must
%% obtained exactly by choosing some of these cells
%% 
%% Extend this file to do this using a SAT solver, following the
%% example of sudoku.pl:
%% - implement writeClauses so that it computes the solution, and
%% - implement displaySol so that it outputs the solution in the
%%   format shown in entradapacking5.pl.

%%%%%% Some helpful definitions to make the code cleaner:
rect(B) :- 
    rect(B, _, _).

xCoord(X) :- 
    width(W),  
    between(1, W, X).

yCoord(Y) :- 
    height(H), 
    between(1, H, Y).

width(B, W) :-   
	rect(B, W, _).

height(B, H) :- 
    rect(B, _, H).

insideTable(X, Y) :- 
    width(W), 
    height(H), 
    between(1, W, X), 
    between(1, H, Y).


checkBoundaries(B, X, Y):- %admissible start -> Coger el otro extremo
	rect(B),
	width(W),
	height(H),
	width(B, Wi),
	height(B, Hi),
	Ex is W - Wi + 1,		% Extreme X
	Ey is H - Hi + 1,		% Extreme Y
	insideTable(Ex, Ey),
    between(1, Ex, X), 
    between(1, Ey, Y).

ocupa(B, Xo, Yo, Xp, Yp) :- 
	rect(B),
	width(B, W),
	height(B, H),
	Xe is Xo + W - 1,		
	Ye is Yo + H - 1,	
	insideTable(Xe, Ye),	
    between(Xo, Xe, Xp), 
    between(Yo, Ye, Yp).

%%%%%%  Variables: They might be useful
% starts-B-X-Y:   box B has its left-bottom cell with upper-right coordinates (X,Y)
%  fills-B-X-Y:   box B fills cell with upper-right coordinates (X,Y)
%
%   Exam var
% vec-B1-B2:      B1 and B2 are both neighbours
% forbidden-B1-B2:      B1 and B2 are both neighbours

insideRect(B, X, Y) :- 
    width(B, W), 
    height(B, H), 
    between(1, W, X), 
    between(1, H, Y).

neigh(B1, B2):-
    rect(B1), 
    width(B1, W1), 
    height(B1, H1), 
    Ax is W1 + 1,
    Ay is H1 + 1,
    between(0, W1, Ax),
    between(0, H1, Ay),
    not(insideRect(B1, Ax, Ay)),    %Remove positions inside rectangle
    rect(B2),     
    !.

writeClauses:-
	start_rect_admissible, 	% Begin rectangle between allowed positions [1.. W-X+1], [1.. H-Y+1]
	fill_by_start,			% Using start clauses, fill rectangles
	amo_pos_fill,			% At Most One position of a box in the rect (no dups!)
	get_neighbours,         % Find all neighbours given a B
	rm_forbidden,           % No forbidden piece should have such neighbours
	true.

 
start_rect_admissible :- 
	rect(B),	
	findall(starts-B-X-Y, checkBoundaries(B, X, Y), L),
    exactly(1, L),
	fail.
start_rect_admissible.


fill_by_start:-
	checkBoundaries(B, X, Y), %
	ocupa(B, X, Y, Xp, Yp),
	writeClause([\+starts-B-X-Y, fills-B-Xp-Yp]),
	fail.
fill_by_start.


amo_pos_fill:-
	xCoord(X),	
	yCoord(Y),
	findall(fills-B-X-Y, rect(B), L),
	atMost(1, L),
	writeClause(L),
	fail.
amo_pos_fill.

get_neighbours :-
    rect(B1),
    rect(B2),
    findall(vec-B1-B2, neigh(B1, B2), L),
    atMost(8, L), 
    fail.
get_neighbours.
    
rm_forbidden:-
    rect(B1),
	xCoord(X),	yCoord(Y),
    rect(B2),
    findall(fills-B1-X-Y, not(forbidden(B1, B2)), L),
    atMost(1, L),
    fail.
rm_forbidden.

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% show the solution. Here M contains the literals that are true in the model:

spaces(B) :-	number(B),	B >= 10, write(" ").
spaces(B) :-	number(B),	B < 10,	 write("  ").


write2([A|B]) :- write(A), nl, write2(B).

displaySol(M):-
	yCoord(Y), nl,
	xCoord(X), 
	rect(B),
	member(fills-B-X-Y, M),
	spaces(B),
	write(B),
	fail.
displaySol(_).



%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Express that Var is equivalent to the disjunction of Lits:
expressOr( Var, Lits ):- 
	member(Lit,Lits), 
	negate(Lit,NLit), 
	writeClause([ NLit, Var ]), 
	fail.

expressOr( Var, Lits ):- 
	negate(Var,NVar), 
	writeClause([ NVar | Lits ]), !.


%%%%%% Cardinality constraints on arbitrary sets of literals Lits:

exactly(K,Lits):- atLeast(K,Lits), atMost(K,Lits),!.

atMost(K,Lits):-   % l1+...+ln <= k:  in all subsets of size k+1, at least one is false:
	negateAll(Lits,NLits),
	K1 is K+1,    subsetOfSize(K1,NLits,Clause), writeClause(Clause),fail.
atMost(_,_).

atLeast(K,Lits):-  % l1+...+ln >= k: in all subsets of size n-k+1, at least one is true:
	length(Lits,N),
	K1 is N-K+1,  subsetOfSize(K1, Lits,Clause), writeClause(Clause),fail.
atLeast(_,_).

negateAll( [], [] ).
negateAll( [Lit|Lits], [NLit|NLits] ):- negate(Lit,NLit), negateAll( Lits, NLits ),!.

negate(\+Lit,  Lit):-!.
negate(  Lit,\+Lit):-!.

subsetOfSize(0,_,[]):-!.
subsetOfSize(N,[X|L],[X|S]):- N1 is N-1, length(L,Leng), Leng>=N1, subsetOfSize(N1,L,S).
subsetOfSize(N,[_|L],   S ):-            length(L,Leng), Leng>=N,  subsetOfSize( N,L,S).


%%%%%% main:

main:-  symbolicOutput(1), !, writeClauses, halt.   % print the clauses in symbolic form and halt
main:-  
	initClauseGeneration,
	tell(clauses),
	writeClauses, 
	told,          % generate the (numeric) SAT clauses and call the solver
	tell(header),  
	writeHeader,  
	told,
	numVars(N), 
	numClauses(C),
	write('Generated '), write(C), write(' clauses over '), write(N), write(' variables. '),nl,
	shell('cat header clauses > infile.cnf',_),
	write('Calling solver....'), nl,
	shell('picosat -v -o model infile.cnf', Result),  % if sat: Result=10; if unsat: Result=20.
	treatResult(Result), !.

treatResult(20):- write('Unsatisfiable'), nl, halt.
treatResult(10):- write('Solution found: '), nl, see(model), symbolicModel(M), seen, displaySol(M), nl,nl,halt.

initClauseGeneration:-  %initialize all info about variables and clauses:
	retractall(numClauses(   _)),
	retractall(numVars(      _)),
	retractall(varNumber(_,_,_)),
	assert(numClauses( 0 )),
	assert(numVars(    0 )),     !.

writeClause([]):- symbolicOutput(1),!, nl.
writeClause([]):- countClause, write(0), nl.
writeClause([Lit|C]):- w(Lit), writeClause(C),!.
w( Lit ):- symbolicOutput(1), write(Lit), write(' '),!.
w(\+Var):- var2num(Var,N), write(-), write(N), write(' '),!.
w(  Var):- var2num(Var,N),           write(N), write(' '),!.


% given the symbolic variable V, find its variable number N in the SAT solver:
var2num(V,N):- hash_term(V,Key), existsOrCreate(V,Key,N),!.
existsOrCreate(V,Key,N):- varNumber(Key,V,N),!.                            % V already existed with num N
existsOrCreate(V,Key,N):- newVarNumber(N), assert(varNumber(Key,V,N)), !.  % otherwise, introduce new N for V

writeHeader:- numVars(N),numClauses(C), write('p cnf '),write(N), write(' '),write(C),nl.

countClause:-     retract( numClauses(N0) ), N is N0+1, assert( numClauses(N) ),!.
newVarNumber(N):- retract( numVars(   N0) ), N is N0+1, assert(    numVars(N) ),!.

% Getting the symbolic model M from the output file:
symbolicModel(M):- 
	get_code(Char), 
	readWord(Char,W), 
	symbolicModel(M1), 
	addIfPositiveInt(W,M1,M),!.
symbolicModel([]).

addIfPositiveInt(W,L,[Var|L]):- W = [C|_], between(48,57,C), number_codes(N,W), N>0, varNumber(_,Var,N),!.

addIfPositiveInt(_,L,L).

readWord( 99,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ c

readWord(115,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ s
readWord(-1,_):-!, fail. %end of file
readWord(C,[]):- member(C,[10,32]), !. % newline or white space marks end of word
readWord(Char,[Char|W]):- get_code(Char1), readWord(Char1,W), !.
%========================================================================================

:-include(entradaFlow14).
:-include(display).
:-dynamic(varNumber/3).

symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cell(X,Y):-size(N), between(1,N,X), between(1,N,Y).
color(C):-c(C,_,_,_,_).

initialCellColor(X,Y,C):-c(C,X,Y,_,_).
finalCellColor(X,Y,C):-c(C,_,_,X,Y).

initial(X,Y):-c(_,X,Y,_,_).
final(X,Y):-c(_,_,_,X,Y).

maxNum(M):- size(N), M is N*N.
num(N):-maxNum(M), between(1,M,N).

successors(X,Y,L):-
    XP1 is X+1,     XM1 is X-1, 
    YP1 is Y+1,     YM1 is Y-1, 
    findall([X1,Y1],( member([X1,Y1],   [ [XP1,Y], [XM1,Y], [X, YP1], [X, YM1] ]), cell(X1,Y1) ), L).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% VARS TO BE USED:
% col-I-J-C --> cell (I,J) has color C
% s-X1-Y1-X2-Y2 --> (X2,Y2) is the successor of (X1-Y1)

% num-X-Y-N --> cell (X,Y) has num N
writeClauses:-
    eachCellExactlyOneColor,
    predefinedColors,
    eachCellExactlyOneSuccessor,
    successorsPreserveColors,
    eachCellExactlyOneNum,
    initialCellsNumberOne,
    successorsIncreaseNumbers,
    true.

eachCellExactlyOneColor:-
    cell(X,Y), findall(col-X-Y-C,color(C),L),
    exactly(1,L), fail.
eachCellExactlyOneColor.

eachCellExactlyOneNum:-
    cell(X,Y), findall(num-X-Y-N, num(N) ,L),
    exactly(1,L), fail.
eachCellExactlyOneNum.
    
predefinedColors:-
    initialCellColor(X,Y,C), writeClause([col-X-Y-C]), fail.
predefinedColors:-
    finalCellColor(X,Y,C), writeClause([col-X-Y-C]), fail.
predefinedColors.

eachCellExactlyOneSuccessor:-
    cell(X,Y), \+final(X,Y), 
    findall(s-X-Y-X1-Y1,  (successors(X,Y,L),   member([X1,Y1],L) )       , Lits),
    exactly(1,Lits), fail.
eachCellExactlyOneSuccessor:-
    cell(X,Y), final(X,Y),
    findall(s-X-Y-X1-Y1, cell(X1,Y1), Lits),
    exactly(0,Lits), fail.
eachCellExactlyOneSuccessor.

successorsPreserveColors:-
    cell(X,Y), \+final(X,Y), color(C), successors(X,Y,L), member([X1,Y1],L), 
    writeClause([ \+s-X-Y-X1-Y1, \+col-X-Y-C, col-X1-Y1-C]), fail.
successorsPreserveColors.

initialCellsNumberOne:-
    initial(X,Y), writeClause([num-X-Y-1]), fail.
initialCellsNumberOne.

successorsIncreaseNumbers:-
    cell(X,Y), \+final(X,Y), num(N), successors(X,Y,L), member([X1,Y1],L), 
    N1 is N+1, num(N1),
    writeClause([ \+s-X-Y-X1-Y1, \+num-X-Y-N, num-X1-Y1-N1]), fail.
successorsIncreaseNumbers.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Everything below is given as a standard library, reusable for solving 
%    with SAT many different problems.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Express that Var is equivalent to the disjunction of Lits:
expressOr( Var, Lits ):- member(Lit,Lits), negate(Lit,NLit), writeClause([ NLit, Var ]), fail.
expressOr( Var, Lits ):- negate(Var,NVar), writeClause([ NVar | Lits ]),!.


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN:

main:-  symbolicOutput(1), !, writeClauses, halt.   % print the clauses in symbolic form and halt
main:-  initClauseGeneration,
	tell(clauses), writeClauses, told,          % generate the (numeric) SAT clauses and call the solver
	tell(header),  writeHeader,  told,
	numVars(N), numClauses(C),
	write('Generated '), write(C), write(' clauses over '), write(N), write(' variables. '),nl,
	shell('cat header clauses > infile.cnf',_),
	write('Calling solver....'), nl,
	shell('picosat -v -o model infile.cnf', Result),  % if sat: Result=10; if unsat: Result=20.
	treatResult(Result),!.

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
symbolicModel(M):- get_code(Char), readWord(Char,W), symbolicModel(M1), addIfPositiveInt(W,M1,M),!.
symbolicModel([]).
addIfPositiveInt(W,L,[Var|L]):- W = [C|_], between(48,57,C), number_codes(N,W), N>0, varNumber(_,Var,N),!.
addIfPositiveInt(_,L,L).
readWord( 99,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ c
readWord(115,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ s
readWord(-1,_):-!, fail. %end of file
readWord(C,[]):- member(C,[10,32]), !. % newline or white space marks end of word
readWord(Char,[Char|W]):- get_code(Char1), readWord(Char1,W), !.
%========================================================================================

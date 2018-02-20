:-dynamic(varNumber / 3).
symbolicOutput(0).  % set to 1 to see symbolic output only; 0 otherwise.

%%%% Input example: %%%%%%%%%%%%%%%%%%%%%%%%%%%

nurseIDandBlocking( nurse01,  6, 14 ). % cannot work between 06:00 and 14:00
nurseIDandBlocking( nurse02,  6, 14 ).
nurseIDandBlocking( nurse03,  6, 14 ).
nurseIDandBlocking( nurse04, 14, 22 ).
nurseIDandBlocking( nurse05, 14, 22 ).
nurseIDandBlocking( nurse06, 14, 22 ).
nurseIDandBlocking( nurse07, 22,  6 ). % cannot work between 22:00 - 23:59 and 00:00 - 06:00
nurseIDandBlocking( nurse08, 22,  6 ).
nurseIDandBlocking( nurse09, 22,  6 ).
nurseIDandBlocking( nurse10, 22,  6 ).
nurseIDandBlocking( nurse11,  6, 14 ).
nurseIDandBlocking( nurse12,  6, 14 ).
nurseIDandBlocking( nurse13,  6, 14 ).
nurseIDandBlocking( nurse14, 14, 22 ).

% each H-N means "N nurses needed during the hour starting at H".  E.g. 17-3: at 17:00-18:00, 3 nurses.
needs([ 0-1,  1-2,  2-1,  3-1,  4-2,  5-2,  6-3,  7-3,  
        8-4,  9-4, 10-4, 11-3, 12-3, 13-3, 14-3, 15-4, 
       16-3, 17-3, 18-3, 19-4, 20-3, 21-2, 22-2, 23-1 ]).

%%%% End Input example. %%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%% We will be using the following SAT variables:
% startsNH-N-H         "nurse N starts at hour H"  (N is a nurseID and H is an hour (in 0..23).
% worksNH-N-H          "nurse N works  at hour H"
% nurseType-N-Type     "nurse N has type T"        (if Type=1: WWWRWWW, if Type=2: WWWRRWWW)

%%%%%%%%% Some helpful definitions to make the code cleaner:

nurse(N):- nurseIDandBlocking(N, _, _).
hour(H):- between(0, 23, H).
type(T):- between(1, 2, T). %Resting type per nurse: we arbitrarily chose which one can we use per nurse.
needed(H, N):- needs(L), member(H-N, L).

workingHourForTypeAndStartH(1,StartH,H):- %Type=1: WWWRWWW
    between(0,2,I), 
    H is (StartH+I) mod 24.
workingHourForTypeAndStartH(1,StartH,H):- 
    between(4,6,I), 
    H is (StartH+I) mod 24.

workingHourForTypeAndStartH(2,StartH,H):- %Type=2: WWWRRWWW
    between(0,2,I), 
    H is (StartH+I) mod 24. 
workingHourForTypeAndStartH(2,StartH,H):- 
    between(5,7,I), 
    H is (StartH+I) mod 24.

hourInRange(Start,End,H):- 
    Start<End, 
    End1 is End-1,    
    between(Start,End1,H).
hourInRange(Start,End,H):- 
    Start>End, 
    End1 is End+23, %ez hax: 24-1, 
    between(Start,End1,H1), 
    H is H1 mod 24.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
writeContents([X|L]):-
    write(X), write(" "), writeContents(L).
writeContents([]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%We want to schedule the nurses working in a hospital.

%% [X] For each hour, we know the minimum number (each day the same) of nurses needed.
eachHourMinNurses:-
    hour(H),
    needed(H, Num),
    findall(worksNH-N-H, nurse(N), Literals),
    atLeast(Num, Literals),
    fail.
eachHourMinNurses.



%% [] Each nurse every day has the same schedule: start working XX:00, then work for three consecutive hours, 
%%     rest for one or two hours, and then work three hours again, for example: {work 23-02, rest 02-03, work 03-06}.

fillNurseScheduled:- % Get all working hours (redundant ??? )
    nurse(N), 
    type(T), 
    hour(SH),
    findall(Hs, ( hour(Hs), workingHourForTypeAndStartH(T, SH, Hs)), WorkingHours),
    member(H, WorkingHours),
    workingHourForTypeAndStartH(T, SH, H),
    writeClause([\+startsNH-N-SH, \+nurseType-N-T, worksNH-N-H]),
    fail.
fillNurseScheduled:- % Get all NON-working hours
    nurse(N), 
    type(T), 
    hour(SH),
    findall(H, ( hour(H), \+workingHourForTypeAndStartH(T, SH, H)), NonWorkingHours),
    member(H1, NonWorkingHours),
    writeClause([\+startsNH-N-SH, \+nurseType-N-T, \+worksNH-N-H1]),
    fail.    
fillNurseScheduled. 

%% [X] Also, each nurse has a range of hours (s)he cannot work.
blockHours:-  %version with findall
    nurseIDandBlocking(N, SB, EB), % Start blocking, end blocking
    findall(\+worksNH-N-H, hourInRange(SB, EB, H), BlockHours),
    exactly(8, BlockHours), %all nurses have 8h of rest (hardcoded!)
    %writeClause([\+worksNH-N-H]), % version with WC
    fail.
blockHours.



%% Force each nurse to have exactly 1 of 2 types.
eachNurseAtLeastOneType:- 
    nurse(N), 
    findall(nurseType-N-T, type(T), Lit),
    atLeast(1, Lit),
    fail.    
eachNurseAtLeastOneType. 

%% Force each nurse to start working at least once.
eachNurseAtLeastOneStart:- 
    nurse(N), 
    findall(startsNH-N-H, hour(H), Lit),
    atLeast(1, Lit),
    fail.    
eachNurseAtLeastOneStart. 
   

%% Find working hours for each nurse given all constraints.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


writeClauses:-
    eachHourMinNurses,
    fillNurseScheduled,   % also fills vars!
    blockHours,
    eachNurseAtLeastOneType,
    eachNurseAtLeastOneStart,
    true.

% =====================================================================

displaySol(M):- nl, write('        00-01-02-03-04-05-06-07-08-09-10-11-12-13-14-15-16-17-18-19-20-21-22-23-24'), nl,
                nurse(N), format('~n~s:',[N]), hour(H), writeHour(M, N, H), fail.
displaySol(M):- nl, write('Total:  '), hour(H), findall(N, member(worksNH-N-H, M),L),length(L, K),format(' ~d ',[ K]),fail.
displaySol(_):- nl, write('Needed: '), hour(H), needed(H,N),                                   format(' ~d ', [N]),fail.
displaySol(_).

writeHour(M,N,H):- member(worksNH-N-H, M), write(' X '), !.
writeHour(_,_,_):-                         write('   '), !.
%writeHour(_,_,_):-                        write(' . '), !.


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


%%%%%% main:

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

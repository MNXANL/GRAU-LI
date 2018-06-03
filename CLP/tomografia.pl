% A matrix which contains zeroes and ones gets "x-rayed" vertically and
% horizontally, giving the total number of ones in each row and column.
% The problem is to reconstruct the contents of the matrix from this
% information. Sample run:
%
%	?- p.
%	    0 0 7 1 6 3 4 5 2 7 0 0
%	 0                         
%	 0                         
%	 8      * * * * * * * *    
%	 2      *             *    
%	 6      *   * * * *   *    
%	 4      *   *     *   *    
%	 5      *   *   * *   *    
%	 3      *   *         *    
%	 7      *   * * * * * *    
%	 0                         
%	 0                         
%	

/* POSSIBLE SOLUTION FOR THIS ONE
      3  2  3  1  1  1  1  2  3  2  1 

 11   *  *  *  *  *  *  *  *  *  *  *  
  5   *     *              *  *  *     
  4   *  *  *                 *        

  
*/


:-use_module(library(clpfd)).

ejemplo(1, [0,0,8,2,6,4,5,3,7,0,0], [0,0,7,1,6,3,4,5,2,7,0,0] ).
ejemplo(2, [10,4,8,5,6], [5,3,4,0,5,0,5,2,2,0,1,5,1] ).
ejemplo(3, [11,5,4], [3,2,3,1,1,1,1,2,3,2,1] ).



listVars(N, L):- length(L, N).

matrixByRows([], _, []).
matrixByRows(List, NC, [Col|Cols]):-
	append(Col, Residual, List),
	length(Col, NC),
	matrixByRows(Residual, NC, Cols),
	true.
	
% Constraint -> get as many dots as Sum
getDots([Line|Matrix], [Sum|MoreSums]):-
	sum(Line, #=, Sum),
	getDots(Matrix, MoreSums),
	true.
getDots([], _).


% MOD: it throws every possible case for every example!
p:-	
    between(1, 3, N), 
    nl,nl,write('###################################################'),
    nl, write('#################### Ejemplo '), write(N), write(' ####################'), 
    nl, write('###################################################'), nl,
    nl,
    ejemplo(N, RowSums,ColSums),
	length(RowSums,NumRows),
	length(ColSums,NumCols),
	NVars is NumRows*NumCols,
	listVars(NVars,L),  % generate a list of Prolog vars (their names do not matter)
	
	% Domain and variables
	L ins 0..1,
	matrixByRows(L,NumCols,MatrixByRows),
	transpose(MatrixByRows, MatrixByCols),
	
	% Constraints
    getDots(MatrixByRows, RowSums),
	getDots(MatrixByCols, ColSums),
	
	% Output and labeling
	label(L), nl,nl,
	pretty_print(RowSums,ColSums,MatrixByRows), fail.


pretty_print(_,ColSums,_):- 
    write('     '), 
    member(S,ColSums), 
    writef('%2r ',[S]), 
    fail.
pretty_print(RowSums,_,M):- 
    nl, nth1(N,M,Row), 
    nth1(N,RowSums,S), nl, 
    writef('%3r   ',[S]), 
    member(B,Row), wbit(B), 
    fail.
pretty_print(_,_,_).

wbit(1):- write('*  '),!.
wbit(0):- write('   '),!.


return(L,A):- between(0,A,N), coins(N,L,A), write(N), nl.
coins(0,[],0).
coins(N,[C|Cs],A):- N>0,A>0, between(0,N,K), N1 is N-K, A1 is A-K*C, coins(N1,Cs,A1).
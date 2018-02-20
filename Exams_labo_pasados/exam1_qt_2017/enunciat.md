    The exam consists in implementing two modifications of the nurses problem. You should submit two files: ex1.pl and ex2.pl. IMPORTANT: modifications do not accumulate. That is, they both represent a modification of the original problem.

    1.- Let us consider that all nurses follow the same working pattern:

        WW R WW R WW    (W means works and R means rest).
        
        

    2.- Let us now consider that there are pairs of nurses whose schedules only differ in a one-hour shift. Those pairs are given as clauses 
    
        shifted(N1,N2), 
    
    where N1 and N2 are nurse identifiers, meaning that N2 has the same schedule as N1 but shifted one hour to the  right.

    As an example, the following two patterns satisfy the condition

        shifted(N1,N2).

        N1 --> RRRRRW WWRWWW RRRRRR RRRRRRR
        N2 --> RRRRRR WWWRWW WRRRRR RRRRRRR
                    ^
        
        N1 --> WRRRRR RRRRRR RRRRRR RWWWRWW
        N2 --> WWRRRR RRRRRR RRRRRR RRWWWRW
                                     ^
        
        (spaces added for easier reading. [^] marks starting hour of N1)

        
    Add the following two clauses to your file:    

        shifted(nurse01,nurse02).

        shifted(nurse13,nurse14).

    (IMPORTANT: remember that here you are considering the 2 original working patterns).

file1 = machines
file2 = machines_malo

all: one two 

one: $(file1).pl 
	swipl -quiet -O -g main --stand_alone=true -o $(file1) -c $(file1).pl
two: $(file2).pl 
	swipl -quiet -O -g main --stand_alone=true -o $(file2) -c $(file2).pl

clean: 
	rm -f machines clauses *.cnf header model

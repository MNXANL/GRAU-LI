all: ex1 ex2
file1 = ex1
file2 = ex2

$(file1): $(file1).pl
	swipl -O -q -g main --stand_alone=true -o $(file1) -c $(file1).pl

	
$(file2): $(file2).pl
	swipl -O -q -g main --stand_alone=true -o $(file2) -c $(file2).pl
clean: rm ex1 ex2

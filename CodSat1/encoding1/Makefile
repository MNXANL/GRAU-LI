file1 = sudoku
file2 = groups
file3 = antennas
file4 = tsp

$(file1): $(file1).pl 
	swipl -quiet -O -g main --stand_alone=true -o $(file1) -c $(file1).pl


$(file2): $(file2).pl 
	swipl -quiet -O -g main --stand_alone=true -o $(file2) -c $(file2).pl

$(file3): $(file3).pl 
	swipl -quiet -O -g main --stand_alone=true -o $(file3) -c $(file3).pl

$(file4): $(file4).pl 
	swipl -quiet -O -g main --stand_alone=true -o $(file4) -c $(file4).pl

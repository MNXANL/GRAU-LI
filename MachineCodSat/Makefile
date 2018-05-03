file1 = machines

all: file1 

$(file1): $(file1).pl 
	swipl -quiet -O -g main --stand_alone=true -o $(file1) -c $(file1).pl

clean: rm *f file1
all: calc

test: calc.o  Source.o 
	g++ calc.o  Source.o -o calc  

calc.o:
	g++ -c calc.cpp -o Source.o
Source.o:
	g++ -c Source.cpp -o calc.o -c 
	
run:
	calc

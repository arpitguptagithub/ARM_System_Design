# Define variables for the filenames
FNAME = $(fname)
INPUTFILE = $(inputfile)

# Rule to compile lex and yacc files and redirect terminal output to terminaloutput.txt
parser: y.tab.c lex.yy.c y.tab.h
	g++ -w y.tab.c lex.yy.c -ll -ly -o parser

lex.yy.c: $(FNAME).l
	lex $(FNAME).l

y.tab.c: $(FNAME).y
	yacc -v -d -t $(FNAME).y 

# Rule to compile input file and generate TAC output
compile: parser
	@if [ -f $(INPUTFILE).ppc ]; then \
		./parser < $(INPUTFILE).ppc | tee tac.txt; \
	else \
		./parser < $(INPUTFILE).h | tee tac.txt; \
	fi

# Rule to run global_header_addition.py on tac.txt
header_addition: compile
	python3 global_header_addition.py
	cp tac.txt $(INPUTFILE).tac

# Rule to compile TAC-VM.cpp and run TAC-VM if executable is not present
run_vm: header_addition
	@if [ ! -f TAC-VM ]; then \
		g++ TAC-VM.cpp -o TAC-VM; \
	fi
	./TAC-VM tac.txt $(INPUTFILE).vm

# Rule to clean up generated files
clean:
	rm -f parser y.tab.c lex.yy.c y.tab.h y.output terminaloutput.txt tac.txt $(INPUTFILE).tac $(INPUTFILE).vm

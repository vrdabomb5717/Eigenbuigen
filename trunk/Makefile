# IMPORTANT: Change MacFramework to LinuxFramework when necessary.

X10_PATH=/opt/x10-2.2.1/bin

# environment variables
X10_NTHREADS := 24
#X10_STATIC_THREADS := false
#X10LAUNCHER_NPROCS := 1


CC = g++

ExeName = main
 
Main = Simulator_Main.cpp

MacFramework = -framework Carbon -framework OpenGL -framework GLUT
LinuxFramework = -lglut -lGLU

#NUM_PARTICLES=64 81 100
NUM_PARTICLES=4 9 16 25 36 49 64 81 100 400 900 1600 2500 3600 4900 6400 8100 10000

NUM_ASYNCS=2 5 10 15 20 25 36 49 64 81

TEST_PARTICLES=64
TEST_ASYNCS=24

# Sequential Parameters 
P1=SceneTester
P1_ASYNCS=1
P1_INPUT=./test/$(NUM_PARTICLES).txt
P1_OUTPUT=./output/outseq$(NUM_PARTICLES).txt
P1_NUM_TRIALS=2
P1_DT=0.05
P1_DURATION=5.0
P1_K=100.0
P1_THICKNESS=0.00
P1_COR=1.0

# Parallel Parameters 
P2=SceneTesterPar
P2_ASYNCS=1
P2_INPUT=./test/$(NUM_PARTICLES).txt
P2_OUTPUT=./output/out$(NUM_PARTICLES).txt
P2_NUM_TRIALS=2
P2_DT=0.05
P2_DURATION=5.0
P2_K=100.0
P2_THICKNESS=0.00
P2_COR=1.0
P2_MAX_ASYNCS=24
P2_SCALE_PARTICLES=100

all: main

simmac: $(Main)
	$(CC) -g -o $(ExeName) $(Main) $(MacFramework)

simlin: $(Main)
	$(CC) -g -o $(ExeName) $(Main) $(LinuxFramework)


clean:
	rm -f $(ExeName) $(P1).exe $(P2).exe *.cc *.h

functests: sequentialtest paralleltest compare

perftests: sequential parallel

scaletests: parallel_scale



sequentialtest: $(P1).exe $(P1)test.out

$(P1)test.out: $(P1).exe   
	salloc -n1 srun.x10sock ./$(P1).exe test/$(TEST_PARTICLES).txt output/$(TEST_PARTICLES).seqtest.txt $(TEST_PARTICLES) $(P1_DT) $(P1_DURATION) $(P1_K) $(P1_THICKNESS) $(P1_COR) > output/$(P1).test.$(TEST_PARTICLES).txt
	@echo " "
	

# Test the parallel code's functionality by running on TEST_PARTICLES and then comparing to sequential code's performance

paralleltest: $(P2).exe $(P2)test.out

$(P2)test.out: $(P2).exe
	salloc -n1 srun.x10sock ./$(P2).exe test/$(TEST_PARTICLES).txt output/$(TEST_PARTICLES).partest.txt $(TEST_PARTICLES) $(P2_DT) $(P2_DURATION) $(P2_K) $(P2_THICKNESS) $(P2_COR) $(TEST_ASYNCS) > output/$(P2).test.$(TEST_PARTICLES).txt
	@echo " "

compare:
	@echo "Comparing outputs of sequential and parallel code."
	diff -q output/$(TEST_PARTICLES).seqtest.txt output/$(TEST_PARTICLES).seqtest.txt; if [ $$? -eq 0 ]; then echo "No differences. Pass!"; else echo "Differences present. Fail!"; fi
	@echo " "
	




# Test the sequential code's performance by iterating through NUM_PARTICLES

sequential: $(P1).exe $(P1).out
$(P1).out: $(NUM_PARTICLES:%=$(P1).%.buildandrun) 

$(P1).%.buildandrun: $(P1).exe   
	salloc -n1 srun.x10sock ./$(P1).exe test/$*.txt output/$*.seq.txt $* $(P1_DT) $(P1_DURATION) $(P1_K) $(P1_THICKNESS) $(P1_COR) > output/$(P1).$*.txt
	@echo "Dumping contents of output/$(P1).$*.txt ... "
	@grep "" output/$(P1).$*.txt
	@echo " "
	@echo "Find your results in output/$(P1).$*.txt"
	@echo " "

$(P1).exe: src/$(P1).x10
	$(X10_PATH)/x10c++ -t -v -report postcompile=1 -o $(P1).exe -optimize -O -NO_CHECKS src/$(P1).x10


# Test the parallel code's performance by iterating through NUM_PARTICLES

parallel: $(P2).exe $(P2).out

$(P2).out: $(NUM_PARTICLES:%=$(P2).%.buildandrun) 

$(P2).%.buildandrun: $(P2).exe   
	salloc -n1 srun.x10sock ./$(P2).exe test/$*.txt output/$*.par.txt $* $(P2_DT) $(P2_DURATION) $(P2_K) $(P2_THICKNESS) $(P2_COR) $(P2_MAX_ASYNCS) > output/$(P2).$*.txt
	@echo "Dumping contents of output/$(P2).$*.txt ... "
	@grep "" output/$(P2).$*.txt
	@echo " "
	@echo "Find your results in output/$(P2).$*.txt"
	@echo " "

$(P2).exe: src/$(P2).x10
	$(X10_PATH)/x10c++ -t -v -report postcompile=1 -o $(P2).exe -optimize -O -NO_CHECKS src/$(P2).x10



# Test scaling by iterating through all NUM_ASYNCS

parallel_scale: $(P2).exe $(P2)scale.out

$(P2)scale.out: $(NUM_ASYNCS:%=$(P2)scale.%.buildandrun) 

$(P2)scale.%.buildandrun: $(P2).exe   
	salloc -n1 srun.x10sock ./$(P2).exe test/$(P2_SCALE_PARTICLES).txt output/$*.scale.txt $(P2_SCALE_PARTICLES) $(P2_DT) $(P2_DURATION) $(P2_K) $(P2_THICKNESS) $(P2_COR) $* > output/$(P2).scale.$*.txt
	@echo "Dumping contents of output/$(P2).scale.$*.txt ... "
	@grep "" output/$(P2).scale.$*.txt
	@echo " "
	@echo "Find your results in output/$(P2).scale.$*.txt"
	@echo " "
# IMPORTANT: Change MacFramework to LinuxFramework when necessary.

X10_PATH=/opt/x10-2.2.0.1/bin

# environment variables
X10_NTHREADS := 24
#X10_STATIC_THREADS := false
#X10LAUNCHER_NPROCS := 1


CC = g++

ExeName = main
 
Main = Simulator_Main.cpp

MacFramework = -framework Carbon -framework OpenGL -framework GLUT
LinuxFramework = -lglut -lGLU

NUM_PARTICLES=100

# Sequential Parameters 
P1=SceneTester
P1_ASYNCS=1
P1_INPUT=./src/$(NUM_PARTICLES).txt
P1_OUTPUT=./src/outseq$(NUM_PARTICLES).txt
P1_NUM_TRIALS=2
P1_DT=0.001
P1_DURATION=5.0
P1_K=100.0
P1_THICKNESS=0.00
P1_COR=1.0

# Parallel Parameters 
P2=SceneTesterPar
P2_ASYNCS=1
P2_INPUT=./src/$(NUM_PARTICLES).txt
P2_OUTPUT=./src/out$(NUM_PARTICLES).txt
P2_NUM_TRIALS=2
P2_DT=0.001
P2_DURATION=5.0
P2_K=100.0
P2_THICKNESS=0.00
P2_COR=1.0

all: main

main: $(Main) $(HEdge) $(GLScene)
	$(CC) -g -o $(ExeName) $(Main) $(MacFramework)

clean:
	rm -f $(ExeName) $(P1).exe $(P2).exe *.cc *.h

functests: sequential parallel

perftests: sequential parallel

sequential: $(P1).exe $(P1).out
$(P1).out: $(NUM_PARTICLES:%=$(P1).%.buildandrun) 

$(P1).%.buildandrun: $(P1).exe   
	salloc -n1 srun.x10sock ./$(P1).exe $(P1_INPUT) $(P1_OUTPUT) $(NUM_PARTICLES) $(P1_DT) $(P1_DURATION) $(P1_K) $(P1_THICKNESS) $(P1_COR) > $(P1).out
	@echo "Dumping contents of $(P1).out ... "
	@grep "" $(P1).out
	@echo " "
	@echo "Find your results in $(P1).out"
	@echo " "

$(P1).exe: src/$(P1).x10
	$(X10_PATH)/x10c++ -t -v -report postcompile=1 -o $(P1).exe -optimize -O -NO_CHECKS src/$(P1).x10

parallel: $(P2).exe $(P2).out
$(P2).out: $(NUM_PARTICLES:%=$(P2).%.buildandrun) 

$(P2).%.buildandrun: $(P2).exe   
	salloc -n1 srun.x10sock ./$(P2).exe $(P2_INPUT) $(P2_OUTPUT) $(NUM_PARTICLES) $(P2_DT) $(P2_DURATION) $(P2_K) $(P2_THICKNESS) $(P2_COR) > $(P2).out
	@echo "Dumping contents of $(P2).out ... "
	@grep "" $(P2).out
	@echo " "
	@echo "Find your results in $(P2).out"
	@echo " "

$(P2).exe: src/$(P2).x10
	$(X10_PATH)/x10c++ -t -v -report postcompile=1 -o $(P2).exe -optimize -O -NO_CHECKS src/$(P2).x10
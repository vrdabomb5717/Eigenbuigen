# IMPORTANT: Change MacFramework to LinuxFramework when necessary.

CC = g++

ExeName = main
 
Main = Simulator_Main.cpp

MacFramework = -framework Carbon -framework OpenGL -framework GLUT
LinuxFramework = -lglut -lGLU

all: main

main: $(Main) $(HEdge) $(GLScene)
	$(CC) -g -o $(ExeName) $(Main) $(MacFramework)

clean:
	rm -f $(ExeName)

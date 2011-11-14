# IMPORTANT: Change MacFramework to LinuxFramework when necessary.

CC = g++

ExeName = main

HEdge = HalfEdge.cpp
#GLScene = OBJRenderer.cpp 
Main = Simulator_Main.cpp

MacFramework = -framework Carbon -framework OpenGL -framework GLUT
LinuxFramework = -lglut -lGLU

all: main

main: $(Main) $(HEdge) $(GLScene)
	$(CC) -g -o $(ExeName) $(Main) $(HEdge) $(GLScene) $(MacFramework)

clean:
	rm -f $(ExeName)

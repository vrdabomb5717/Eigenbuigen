//
//  Particle_Simulator.cpp
//  particle_simulator
//
//  Created by Nathaniel Clinger on 11/5/11.
//  Copyright (c) 2011 Abstract-coding.com. All rights reserved.
//

#ifdef __APPLE__
#include <glut/glut.h>
#else
#include <GL/glut.h>
#endif

#include <iostream>
#include <string>
#include <math.h>
#include <vector>
#include <assert.h>
#include <fstream>
#include <sstream>

using namespace std ;

struct particle
{
    particle( double x, double y, double r ) : x(x), y(y), r(r) {}
    double x ;
    double y ;
    double r ;
} ;

void display( void ) ;
void reshape( int, int ) ;
void init( void ) ;
string fileReader() ;
vector<string> split( const string &s, char delim, bool empty ) ;
vector<string> &split( const string s, char delim, vector<string> &elems, bool empty ) ;
double strToDouble( string str ) ;
int strToInt( string str ) ;
void renderParticles( void ) ;
void loadParticles( void ) ;
void start( string file_name ) ;

ifstream *myfile ;
vector<particle*> particles ;
vector<string> temp ;
bool end_of_scene = false ;
double current_time = 0 ;


void display (void) 
{
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f); // Clear the background
    
    glClear(GL_COLOR_BUFFER_BIT); //Clear the colour buffer (more buffers later on)  
    glLoadIdentity(); // Load the Identity Matrix to reset our drawing locations  
    
    glTranslatef(0.0f, 0.0f, -10.0f);
    
    if( !end_of_scene )
        loadParticles() ;
    
    renderParticles() ; // render the particles
    
    glutSwapBuffers() ;
}

void renderParticles( void )
{
    glColor3f( 0, 0, 0 ) ;
    for( int i = 0 ; i < particles.size() ; i++ )
    {
        glPointSize( particles[i]->r*70 );
        glBegin( GL_POINTS ) ;
        glVertex3f( particles[i]->x, particles[i]->y, 0 ) ;
        glEnd() ;
    }
}

double strToDouble( string str )
{
    return ::atof( str.c_str() ) ;
}

int strToInt( string str )
{
    return ::atof( str.c_str() ) ;
}

void loadParticles( void )
{
    particles.clear() ;
    
    do
    {
        if( temp.size() > 0 )   // check if we've already loaded a value into temp
        {                       // if we have set the particle id to its new values
            particles.push_back( new particle( strToDouble( temp[2] ), strToDouble( temp[3] ), strToDouble( temp[4] ) ) ) ;
        }
        
        string line = fileReader() ;    // read the next line in the file
        
        if( line.empty() )  // if end of file
        {
            //renderParticles() ; // render the particles
            end_of_scene = true ;
            break ;
        }
        
        temp = split( line, ' ', false ) ;      // break the line into segments
    } 
    while( strToDouble( temp[1] ) == current_time ) ; // if the time stamp for the new temp != current time then exit loop
    
    current_time = strToDouble( temp[1] ) ; // set current time stamp to temp time stamp
}

vector<string> &split( const string s, char delim, vector<string> &elems, bool empty )
{
    string str = s ;
    
    str.erase( remove( str.begin(), str.end(), '\n' ), str.end() ) ;        // remove EOL
    str.erase( remove( str.begin(), str.end(), '\r' ), str.end() ) ;        // remove EOL
    
    stringstream ss( str ) ;
    string item ;
    while( getline( ss, item, delim ) )
    {
        if( empty || !item.empty() )
            elems.push_back( item ) ;
    }
    
    return elems ;
}

vector<string> split( const string &s, char delim, bool empty )
{
    vector<string> elems ;
    return split( s, delim, elems, empty ) ;
}

string fileReader()
{
    string line ;
    if( myfile->is_open() )              // if it opened correctly
    {
        if( myfile->good() )          // while we haven't reached the end
        {
            getline( *myfile, line ) ;   // get the next line
            if( line.size() != 0 )
                return line ;         // pass it to the parser
        }
        else
        {
            cout << "end of file" << endl ;
            myfile->close() ;                // close file
        }
    }
    else
    {
        cout << "failed to open file" << endl ;
    }
    
    return "" ;
}

void reshape (int width, int height) 
{  
    glViewport(0, 0, (GLsizei)width, (GLsizei)height); // Set our viewport to the size of our window  
    glMatrixMode(GL_PROJECTION); // Switch to the projection matrix so that we can manipulate how our scene is viewed  
    glLoadIdentity(); // Reset the projection matrix to the identity matrix so that we don't get any artifacts (cleaning up)  
    gluPerspective(60, (GLfloat)width / (GLfloat)height, 1.0, 100.0); // Set the Field of view angle (in degrees), the aspect ratio of our window, and the new and far planes
    glMatrixMode(GL_MODELVIEW); // Switch back to the model view matrix, so that we can start drawing shapes correctly  
}

void start( string file_name )
{
    int argc ;
    char **argv ;
    glutInit( &argc, argv ) ; // Initialize GLUT  
    glutInitDisplayMode( GLUT_DOUBLE ) ; // Set up a basic display buffer (only single buffered for now)  
    glutInitWindowSize( 800, 800 ) ; // Set the width and height of the window  
    glutInitWindowPosition( 100, 100 ) ; // Set the position of the window  
    glutCreateWindow ("Particle generator"); // Set the title for the window  
    
    glutDisplayFunc(display); // Tell GLUT to use the method "display" for rendering  
    glutIdleFunc( display ) ;
    glutReshapeFunc(reshape); // Tell GLUT to use the method "reshape" for reshaping  
    
    myfile = new ifstream( file_name.c_str() ) ;   // open file
    
    glutMainLoop(); // Enter GLUT's main loop  
}


int main (int argc, char **argv) 
{  
    start( argv[1] ) ;
}
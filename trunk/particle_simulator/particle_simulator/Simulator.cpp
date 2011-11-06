//
//  Simulator.cpp
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

#define PI 3.1415926535897
#define fov 100.0
#define near 1.0
#define far 1000000.0

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

// ********* figure out the aspect ration
float h = 500 ;
float w = 800 ;
float aspect_ratio = (float)w/(float)h ;
float bottom = aspect_ratio < 1.0 ? -15.f / aspect_ratio : -15.f ;  // if smaller than 1.0 then divided top and bottom by aspect ratio
float top = aspect_ratio < 1.0 ? 15.f / aspect_ratio : 15.f ;       
float leftt = aspect_ratio < 1.0 ? -15 : -15 * aspect_ratio ;       // else multiple left and right by aspect ratio
float rightt = aspect_ratio < 1.0 ? 15 : 15 * aspect_ratio ;

ifstream *myfile ;

vector<particle*> particles ;
vector<string> temp ;

bool end_of_scene = false ;

double current_time = 0 ;

double strToDouble( string str )
{
    return ::atof( str.c_str() ) ;
}

int strToInt( string str )
{
    return ::atof( str.c_str() ) ;
}

void display( void )
{
    glClearColor( 0.8f, 0.8f, 0.8f, 0.8f ) ;        // background color
    
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT ) ;                // clear color buffer and depth
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA ) ;

    glLoadIdentity() ;          // load identity matrix so that we start from a clean slate
    
    if( !end_of_scene )
    {
        particles.clear() ;
        
        do
        {
            if( temp.size() > 0 )   // check if we've already loaded a value into temp
            {                       // if we have set the particle id to its new values
                cout << temp[0] << ":" << temp[1] << ":" << temp[2] << ":" << temp[3] << ":" << temp[4] << endl ;
                particles.push_back( new particle( strToDouble( temp[2] ), strToDouble( temp[3] ), strToDouble( temp[4] ) ) ) ;
            }
            
            string line = fileReader() ;    // read the next line in the file
            
            if( line.empty() )  // if end of file
            {
                renderParticles() ; // render the particles
                end_of_scene = true ;
                break ;
            }
        
            temp = split( line, ' ', false ) ;      // break the line into segments
                
        } while( strToDouble( temp[1] ) == current_time ) ; // if the time stamp for the new temp != current time then exit loop
        
        current_time = strToDouble( temp[1] ) ; // set current time stamp to temp time stamp
    }
    
    renderParticles() ; // render the particles
    
    glutSwapBuffers() ;
}

void renderParticles( void )
{
    for( int i = 0 ; i < particles.size()/2 ; i++ )
    {
        glColor3f( 0, 0, 0 ) ;
        glPointSize( particles[i]->r * 100 ) ;
        glBegin( GL_POINTS ) ;
        glVertex2f( particles[i]->x, particles[i]->y ) ;
        glEnd() ;
    }
}

void init( void )
{
    glEnable( GL_DEPTH_TEST ) ;
    glEnable( GL_COLOR_MATERIAL ) ;
    glEnable( GL_LIGHTING ) ;
    glEnable( GL_NORMALIZE ) ;
    glShadeModel( GL_SMOOTH ) ;
    
    glMatrixMode( GL_PROJECTION ) ;
    glLoadIdentity() ;
    glOrtho( leftt, rightt, bottom, top, near, far) ;
    glMatrixMode( GL_MODELVIEW ) ;
    
    gluLookAt( 0, 0, -30,
              0, 0, 20,
              0.f, 1.f, 0.f ) ;
    
    end_of_scene = false ;
}

void reshape( int w1, int h1 )
{
    if( h1 == 0 )
        h1 = 1 ;
    
    h = h1 ;
    w = w1 ;
    
    
    aspect_ratio = (float)w/(float)h ;
    if( aspect_ratio < 1.0 )
    {
        bottom = -15.f / aspect_ratio ;  // if smaller than 1.0 then divided top and bottom by aspect ratio
        top = 15.f / aspect_ratio ;       
    }
    else
    {
        leftt = -15 * aspect_ratio ;       // else multiple left and right by aspect ratio
        rightt = 15 * aspect_ratio ;
    }
    
    glViewport( 0, 0, (GLsizei)w1, (GLsizei)h1 ) ;
    glMatrixMode( GL_PROJECTION ) ;
    glLoadIdentity() ;
    gluPerspective( 60, (GLfloat)w1 / (GLfloat)h1, near, far ) ;
    glMatrixMode( GL_MODELVIEW ) ;
    
    glutPostRedisplay() ;
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
        {
            //            cout << "item: " << item.c_str() << ":" << item.empty() << ":" << item.size() << ":test" << endl ;
            elems.push_back( item ) ;
        }
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

int main( int argc, char **argv )
{
    glutInit( &argc, argv ) ;
    glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH ) ;
    glutInitWindowSize( w, h ) ;
    glutInitWindowPosition( 100, 100 ) ;
    glutCreateWindow( "Computer Graphics: Downtown sunset" ) ;
    init() ;
    glutDisplayFunc( display ) ;
    glutIdleFunc( display ) ;
    glutReshapeFunc( reshape ) ;
    
    string file_name = argv[1] ;
    myfile = new ifstream( file_name.c_str() ) ;   // open file
    
    glutMainLoop() ;
}
import x10.io.*;
import MathDefs.*;

public class SceneReaderPar
{
	public def this(particles:Int)
	{
		scene = new TwoDScene(particles);
	}
	
	// read file in
	public def read(inputFileName:String)
	{
		try
		{
			val input = new File(inputFileName); 
			var split:Array[String];
			var counter:Int = 0;
			
			var mass:scalar = 0d;
			var px:scalar = 0d;
			var py:scalar = 0d;
			var vx:scalar = 0d;
			var vy:scalar = 0d;
			var radius:scalar = 0d;
			var pos:Vector2s = new Vector2s();
			var vel:Vector2s = new Vector2s();
			
			for (line in input.lines())
			{ 
				val line1 = line.trim();
				split = line1.split(" ");
				
				// mass px py vx vy radius
				
				if(split.size < 6)
				{	
					x10.io.Console.OUT.println("Incorrect number of arguments on line " + (counter + 1) + ". Arguments provided: " + split.size +". " + line1);
					return;
				}
				
				
				mass = Double.parse(split(0));
				px = Double.parse(split(1));
				py = Double.parse(split(2));
				vx = Double.parse(split(3));
				vy = Double.parse(split(4));
				radius = Double.parse(split(5));
				
				x10.io.Console.OUT.println( "new particle at: " + px + ":" + py + " with v: " + vx + ":" + vy ) ;
				
				pos(0) = px;
				pos(1) = py;
				vel(0) = vx;
				vel(1) = vy;
				
				scene.setX(counter, pos);
				scene.setV(counter, vel);
				scene.setM(counter, mass);
				scene.setRadius(counter, radius);
				
				counter++;	
			}
			
			// x10.io.Console.OUT.println( "positions of particles: " + scene.getX().toString() ) ;
		} 
		catch (ioe:IOException) 
		{
			x10.io.Console.OUT.println("An IO Exception occurred.");
		}
	}
	
	// detect collisions using hash-based detection, apply forces to resolve collisions, integrate, and output to file.
	public def animate( dt:scalar, duration:scalar, k:scalar, thickness:scalar, cor:scalar, outputFileName:String, max_async:Int )
	{
		val output = new File(outputFileName);
		val p = output.printer();
		
		val detector = new HashCollisionDetectorPar( max_async ) ;
		
		scene.insertForce(new PenaltyForce(scene, detector, k, thickness));
		
		var oldpos:VectorXs;
		var oldvel:VectorXs;
		val euler = new SemiImplicitEuler();
		val handler = new SimpleCollisionHandler(cor);
		
		for(var i:Double = 0.0; i < duration; i += dt)
		{
			// x10.io.Console.OUT.println( "dt: " + i ) ;
			val time0 = System.nanoTime();
			// oldpos = scene.getX();
			// oldvel = scene.getV();
			
			euler.stepScene(scene, dt);
			// handler.handleCollisions(scene, detector, oldpos, oldvel, dt);
			
			scene.checkConsistency();
			
			// val time3 = System.nanoTime();
			write( output, p, i ) ;
			// x10.io.Console.OUT.println("Time for printout: " + ((System.nanoTime()-time3)/(1000*1000))) ;
			// x10.io.Console.OUT.println("Time step: " + dt + ": " + ((System.nanoTime()-time0)/(1000*1000))) ;
		}
		
		x10.io.Console.OUT.println( "creating animation" ) ;
	}
	
	// display particles velocities and positions at each time step
	public def write(output:File, p:Printer, dt:double )
	{
		try
		{ 
			// # mass px py vx vy radius
			val pos:VectorXs = scene.getX();
			val vel:VectorXs = scene.getV();
			val mass:VectorXs = scene.getM();
			val num_particles = scene.getNumParticles();
			var line:String;
			
			for( [i] in 0..(num_particles-1) )
			{
				line = i + " " + dt + " " + pos(i*2) + " " + pos(i*2+1) + " " + scene.getRadius( i/2 ) ;
				
				// x10.io.Console.OUT.println( "printing to file: " + line ) ;
				
				p.println( line ) ;
			}
		
			p.flush() ; 
		} 
		catch (IOException) 
		{
			x10.io.Console.OUT.println( "An IO Exception occurred." ) ;
		}
	}
	
	private var scene:TwoDScene = null ;
}
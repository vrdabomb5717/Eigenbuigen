import x10.io.*;
import MathDefs.*;

public class SceneReader
{
	public def this(particles:Int)
	{
		scene = new TwoDScene(particles);
	}
	
	
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
				split = line.trim().split("\\s+");
				
				// mass px py vx vy radius
				
				if(split.size < 6)
				{
					x10.io.Console.OUT.println("Incorrect number of arguments on line " + (counter + 1) + ".");
					return;
				}
				
				
				mass = Double.parse(split(0));
				px = Double.parse(split(1));
				py = Double.parse(split(2));
				vx = Double.parse(split(3));
				vy = Double.parse(split(4));
				radius = Double.parse(split(5));
				
				pos(0) = px;
				pos(1) = py;
				vel(0) = vx;
				vel(1) = vy;
				
				scene.setPosition(counter, pos);
				scene.setVelocity(counter, vel);
				scene.setMass(counter, mass);
				scene.setRadius(counter, radius);
				
			} 

			
		} 
		catch (ioe:IOException) 
		{
			x10.io.Console.OUT.println("An IO Exception occurred.");
		}
	}
	
	public def animate(dt:scalar, duration:scalar, k:scalar, thickness:scalar, cor:scalar)
	{	
		scene.insertForce(new PenaltyForce(scene, k, thickness));
		
		var oldpos:VectorXs;
		var oldvel:VectorXs;
		val euler = new SemiImplicitEuler();
		val handler = new SimpleCollisionHandler(cor);
		
		for(var i:Double = 0.0; i < duration; i += dt)
		{
			oldpos = scene.getX();
			oldvel = scene.getV();
			
			euler.stepScene(scene, dt);
			handler.handleCollisions(scene, oldpos, oldvel, dt);
			scene.checkConsistency();
		}
	}
	
	
	public def write(outputFileName:String)
	{
		// try
		// { 
		// 	val output = new File(outputFileName); 
		// 	val p = output.printer(); 
		// 
		// 	for (line in input.lines())
		// 	{ 
		// 		p.println(line); 
		// 	} 
		// 
		// 	p.flush(); 
		// } 
		// catch (IOException) 
		// {
		// 
		// }
	}
	

	
	private var scene:TwoDScene = null;
	
}
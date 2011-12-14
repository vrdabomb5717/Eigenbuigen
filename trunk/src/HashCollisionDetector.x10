import x10.util.*;

public class HashCollisionDetector extends CollisionDetector
{

	static type PPList = HashSet[Pair[Int,Int]];

	static class Cell
	{
		val verts = new HashSet[Int]();
	}
	
	private var numcells:Int = 0;
	private var hashgrid:Array[Cell] = null;
	
	public def performCollisionDetection(scene:TwoDScene, qs:VectorXs, qe:VectorXs, dc:DetectionCallback)
	{
		assert (qs-qe).norm() < 1e-8 : "Contest collision detector is only designed for use with the penalty method!";
		
		val pppairs = new PPList();
		
		// find the colliding pairs and then resolve collisions per pair
		findCollidingPairs(scene, qe, pppairs);
		
		for(p:Pair[Int,Int] in pppairs)
		{
			dc.particleParticleCallback(p.first, p.second);
		}

	}
	
	private def findCollidingPairs(scene:TwoDScene, x:VectorXs, pppairs:PPList)
	{
		if(numcells == 0)
		{
			numcells = Math.sqrt(scene.getNumParticles()) as Int;
		}
		
		var minx:Double = x(0);
		var maxx:Double = x(0);
		var miny:Double = x(1);
		var maxy:Double = x(1);
		
		// find min in x and y direction
		for(var i:Int =0; i < scene.getNumParticles(); i++)
		{
			if(x(2*i) > maxx)
				maxx = x(2*i);
			
			if(x(2*i) < minx)
				minx = x(2*i);
			
			if(x(2*i+1) > maxy)
				maxy = x(2*i+1);
			
			if(x(2*i+1) < miny)
				miny = x(2*i+1);
		}		
		
		if(hashgrid == null)
			hashgrid = new Array[Cell](numcells*numcells, new Cell());
		
		for(var i:Int = 0; i < numcells * numcells; i++)
		{
			hashgrid(i).verts.clear() ;
		}
		
		// hash each particle to a cell and add it to a hashset in the grid
		for(var i:Int = 0; i < scene.getNumParticles(); i++)
		{
			val r = scene.getRadius(i);
			val px1 = hash(minx, maxx, x(2*i)-r, numcells);
			val px2 = hash(minx, maxx, x(2*i)+r, numcells);
			
			val py1 = hash(miny, maxy, x(2*i+1)-r, numcells);
			val py2 = hash(miny, maxy, x(2*i+1)+r, numcells);
			
			for(var a:Int = px1; a <= px2; a++)
			{
				for(var b:Int = py1; b <= py2; b++)
				{
					hashgrid( numcells * a + b ).verts.add( i ) ;
				}
			}
		}
		
		// add pairs of particles to final set that gets resolved
		for(var i:Int = 0; i < numcells * numcells; i++)
		{
			for(val c in hashgrid(i).verts)
			{
				for(val d in hashgrid(i).verts)
				{
					if(c != d)
						pppairs.add( new Pair[Int, Int]( Math.min( c, d ), Math.max( c, d ) ) );
				}
			}
		}
		
		for( p in pppairs )
		{
			Console.OUT.print( p + " " ) ;
		}
		Console.OUT.println() ;
	}
	
	// hash particles based upon the difference in max and min in x or y direction.
	private def hash(min:Double, max:Double, value:Double, numcells:Int):Int
	{
		val res = (value-min)/(max-min)*numcells;
		return Math.max(Math.min( numcells-1, res as Int), 0);
	}
}
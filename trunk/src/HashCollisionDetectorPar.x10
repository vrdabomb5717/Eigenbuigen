import x10.util.*;

public class HashCollisionDetectorPar extends CollisionDetector
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

		val max_async = 24 ;
		
		clocked finish
		{
			for( [i] in 0..( 24-1 ) )
			{
				val i_start = i*(numcells * numcells)/max_async ;	// find start of async array
				
				val i_end = i == max_async-1 ? numcells * numcells : (i_start+numcells * numcells)/max_async ;	// find end of async array
				
				val n_start = i*(scene.getNumParticles())/max_async ;	// find start of async array
				
				val n_end = i == max_async-1 ? scene.getNumParticles() : (i_start+scene.getNumParticles())/max_async ;	// find end of async array
				
				clocked async
				{
					for( [j] in i_start..(i_end-1) )
						hashgrid(j).verts.clear() ;
					
					Clock.advanceAll() ;
					
					for( [j] in n_start..(n_end-1) )
					{
						val r = scene.getRadius(i);
						val px1 = hash(minx, maxx, x(2*j)-r, numcells);
						val px2 = hash(minx, maxx, x(2*j)+r, numcells);

						val py1 = hash(miny, maxy, x(2*j+1)-r, numcells);
						val py2 = hash(miny, maxy, x(2*j+1)+r, numcells);

						for(var a:Int = px1; a <= px2; a++)
						{
							for(var b:Int = py1; b <= py2; b++)
							{
								hashgrid(numcells * a + b).verts.add(j);
							}
						}
					}
					
					Clock.advanceAll() ;
					
					for( [j] in i_start..(i_end-1) )
					{
						for(val c in hashgrid(j).verts)
						{
							for(val d in hashgrid(j).verts)
							{
								if(c != d)
									pppairs.add(new Pair[Int, Int](c, d));
							}
						}
					}
					
					Clock.advanceAll() ;
				}
			}
		}
	}
	
	private def hash(min:Double, max:Double, value:Double, numcells:Int):Int
	{
		val res = (value-min)/(max-min)*numcells;
		return Math.max(Math.min( numcells-1, res as Int), 0);
	}
}
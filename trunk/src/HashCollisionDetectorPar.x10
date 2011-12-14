import x10.util.*;
import x10.util.concurrent.*;

public class HashCollisionDetectorPar extends CollisionDetector
{

	static type PPList = HashSet[Pair[Int,Int]];
	private val MAX_ASYNC:Int ;
	
	public def this( max_async:Int )
	{
		MAX_ASYNC = max_async ;
	}
	
	class Cell
	{
		val verts = new HashSet[Int]();
		
		public def add( x:Int )
		{
			atomic verts.add( x ) ;
		}
	}

	private var numcells:Int = 0;
	private var hashgrid:Array[Cell] = null;
	
	public def performCollisionDetection(scene:TwoDScene, qs:VectorXs, qe:VectorXs, dc:DetectionCallback)
	{
		assert (qs-qe).norm() < 1e-8 : "Contest collision detector is only designed for use with the penalty method!";
		
		val pppairs = new Accumulator[PPList]( new Reducer() ) ;
		
		findCollidingPairs(scene, qe, pppairs);
		
		
		for( p in pppairs() )
			dc.particleParticleCallback( p.first, p.second ) ;
	}
	
	public class Reducer implements Reducible[PPList]
	{
		public def zero():PPList = new PPList() ;
		
		public operator this(var a:PPList, var b:PPList ):PPList 
		{ 
			for( p in b )
				a.add( p ) ;
			return a ;
		}
	}
	
	
	private def findCollidingPairs(scene:TwoDScene, x:VectorXs, pppairs:Accumulator[PPList])
	{
		// val time0 = System.nanoTime();
		
		if(numcells == 0)
		{
			numcells = Math.sqrt(scene.getNumParticles()) as Int;
		}
		
		var minx:Double = Double.POSITIVE_INFINITY;
		var maxx:Double = Double.NEGATIVE_INFINITY;
		var miny:Double = Double.POSITIVE_INFINITY;
		var maxy:Double = Double.NEGATIVE_INFINITY;
		
		for(var i:Int = 0; i < scene.getNumParticles(); i++)
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
		{
			hashgrid = new Array[Cell](numcells*numcells, new Cell());
		
			for( var i:int = 0 ; i < hashgrid.size ; i++ )
				hashgrid(i) = new Cell() ;
		}
		
		val max_async = Math.min( scene.getNumParticles(), MAX_ASYNC ) ;
		
		clocked finish
		{
			for( var i:int = 0 ; i < max_async ; i++ )
			{
				val id = i ;
				
				val i_start = i*(numcells * numcells)/max_async ;	// find start of async array
				
				val i_end = i == max_async-1 ? numcells * numcells : ( i_start + ( numcells * numcells )/max_async ) ;	// find end of async array
				
				val n_start = i*(scene.getNumParticles())/max_async ;	// find start of async array
				
				val n_end = i == max_async-1 ? scene.getNumParticles() : ( n_start + scene.getNumParticles()/max_async ) ;	// find end of async array
				
				val localPP = new PPList() ;
				
				Console.OUT.println( id + ":" + n_start + ":" + n_end ) ;
				
				clocked async
				{
					for( var j:int = i_start ; j < i_end ; j++ )
						hashgrid(j).verts.clear() ;
					
					Clock.advanceAll() ;
					
					for( var j:int = n_start ; j < n_end ; j++ )
					{
						val r = scene.getRadius(j);
						val px1 = hash(minx, maxx, x(2*j)-r, numcells);
						val px2 = hash(minx, maxx, x(2*j)+r, numcells);
						
						val py1 = hash(miny, maxy, x(2*j+1)-r, numcells);
						val py2 = hash(miny, maxy, x(2*j+1)+r, numcells);
						
						for( var a:Int = px1; a <= px2; a++ )
						{
							for( var b:Int = py1; b <= py2; b++ )
							{
								Console.OUT.println( id + ": adding: " + j + " at " + (numcells * a + b) ) ;
								hashgrid( numcells * a + b ).add( j ) ;
							}
						}
					}
					
					Clock.advanceAll() ;
					
					for( var j:int = i_start ; j < i_end ; j++ )
					{						
						val verts = new Array[Int](hashgrid(j).verts.size());
						val it = hashgrid(j).verts.iterator() ;
						
						for( var k:int = 0 ; k < hashgrid(j).verts.size() ; k++ )
							verts(k) = it.next() ;
						
						for( var k:int = 0 ; k < verts.size ; k++ )
						{
							for( var l:int = k ; l < verts.size ; l++ )
							{
								val c = verts(k) ;
								val d = verts(l) ;
								if( c != d )
								{
									localPP.add( new Pair[Int, Int]( Math.min( c, d ), Math.max( c, d ) ) ) ;
								}
							}
						}
					}
					
					pppairs.supply( localPP ) ;
				}
			}
		} ;
		
		for( p in pppairs() )
		{
			Console.OUT.print( p + " " ) ;
		}
		Console.OUT.println() ;
	}
	
	private def hash(min:Double, max:Double, value:Double, numcells:Int):Int
	{
		val res = ((value-min)/(max-min))*numcells;
		// Console.OUT.println( "res: " + res + ":" + (numcells-1) ) ;
		return Math.max(Math.min( numcells-1, res as Int), 0);
	}
}
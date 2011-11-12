import x10.util.*;

public class HashCollisionDetector extends CollisionDetector
{

	static type PPList = HashSet[Pair[Int,Int]];

	public def this(){}
	
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
	
	}
	
	private def hash(min:Double, max:Double, value:Double, numcells:Int):Int
	{
	  val res = (value-min)/(max-min)*numcells;
	  return Math.max(Math.min( numcells-1, res as Int), 0);
	}
}
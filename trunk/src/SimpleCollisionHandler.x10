public class SimpleCollisionHandler extends CollisionHandler
{
	public def this(COR:Double)
	{
		super(COR);
	}
	
	public def getName():String
	{
		return "Simple Collision Handler";
	}
	
	public def handleCollisions(oldpos:VectorXs, oldvel:VectorXs, dt:scalar)
	{
		VectorXs n = new VectorXs(2);
		
		for(var i:Int = 0; i < oldpos.size / 2; i++)
		{
			for(var j:Int = i + 1; j < oldpos.size / 2; j++)
			{
				if(detectParticleParticle(i,j,n))
				{
					addParticleParticleImpulse(i,j,n, 0);
					respondParticleParticle(i,j,n);
				}
			}
		}
		
	}
	
	private def detectParticleParticle(idx1:Int, idx2:Int, n:VectorXs)
	{
		
	}
	
	private def respondParticleParticle(idx1:Int, idx2:Int, n:VectorXs)
	{
		
	}
}
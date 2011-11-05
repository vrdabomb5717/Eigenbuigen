import MathDefs.*;

public class SimpleCollisionHandler extends CollisionHandler
{	
	public def this(cor:Double)
	{
		super(cor);
	}
	
	public def getName():String
	{
		return "Simple Collision Handler";
	}
	
	public def handleCollisions(oldpos:VectorXs, oldvel:VectorXs, dt:scalar)
	{
		n:VectorXs = new VectorXs(2);

		for(var i:Int = 0; i < oldpos.size() / 2; i++)
		{
			for(var j:Int = i + 1; j < oldpos.size() / 2; j++)
			{
				if(detectParticleParticle(i,j,n))
				{
					addParticleParticleImpulse(i,j,n, 0);
					respondParticleParticle(i,j,n);
				}
			}
		}

	}
	
	private def detectParticleParticle(idx1:Int, idx2:Int, n:VectorXs):Boolean
	{
		return false;
	}
	
	private def respondParticleParticle(idx1:Int, idx2:Int, n:VectorXs)
	{
		
	}
}
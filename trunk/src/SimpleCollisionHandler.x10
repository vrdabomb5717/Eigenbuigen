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
	
	public def handleCollisions(scene:TwoDScene, oldpos:VectorXs, oldvel:VectorXs, dt:scalar)
	{
		n:VectorXs = new VectorXs(2);
		val num_particles = scene.getNumParticles();

		for(var i:Int = 0; i < num_particles; i++)
		{
			for(var j:Int = i + 1; j < num_particles; j++)
			{
				if(detectParticleParticle(scene,i,j,n))
				{
					addParticleParticleImpulse(i,j,n, 0);
					respondParticleParticle(scene,i,j,n);
				}
			}
		}

	}
	
	private def detectParticleParticle(scene:TwoDScene, idx1:Int, idx2:Int, var n:VectorXs):Boolean
	{
		val x1 = scene.getX().segment(2*idx1);
		val x2 = scene.getX().segment(2*idx2);
		
		n = x2 - x1;
		l:scalar = n.norm();
		assert(l != 0.0);
		
		val v1 = scene.getV().segment(2*idx1);
		val v2 = scene.getV().segment(2*idx2);

		if(l < scene.getRadius(idx1) + scene.getRadius(idx2))
		{
			if ( (v1 - v2).dot(n) > 0)
				return true;
		}
		
		return false;
	}
	
	private def respondParticleParticle(scene:TwoDScene, idx1:Int, idx2:Int, n:VectorXs)
	{
		val M = scene.getM();
	    val v = scene.getV();

	    val nhat = n / n.norm();
	    
	    val cfactor:double = ( 1.0d + getCOR() ) / 2.0d ;
	    val m1 = M(2*idx1);
	    val m2 = M(2*idx2); 

	    val v1 = scene.getV().segment(2*idx1);
	    val v2 = scene.getV().segment(2*idx2);
	    
	    val numerator = 2d * cfactor * ( v2 - v1 ).dot( nhat ) ;
	    val denom1 = 1d + m1/m2 ;
	    val denom2 = m2/m1 + 1d ;
	    
		
		if(!scene.isFixed(idx1))
			v(2*idx1) = v.segment(2*idx1) + nhat * numerator / denom1 ;
		
		if(!scene.isFixed(idx2))
			v(2*idx2) = v.segment(2*idx2) - nhat * numerator / denom2 ;
	}
}
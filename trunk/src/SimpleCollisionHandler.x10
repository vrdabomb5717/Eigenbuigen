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

		// your implementation here

		val v1 = scene.getV().segment(2*idx1);
		val v2 = scene.getV().segment(2*idx2);
		val m1 = M[2*idx1];
		val m2 = M[2*idx2];

		// if(scene.isFixed(idx1))
		// 	m1 = std::numeric_limits<double>::infinity();
		// 
		// if(scene.isFixed(idx2))
		// 	m2 = std::numeric_limits<double>::infinity();

		val cor = (1.0 + getCOR()) / 2.0;

		val nhat = n / n.norm();

		if(!scene.isFixed(idx1))
			v.segment(2*idx1) += ((2 * cor * (v2 - v1).dot(nhat))/(1 + (m1/m2))) * nhat;

		if(!scene.isFixed(idx2))
			v.segment(2*idx2) -= ((2 * cor * (v2 - v1).dot(nhat))/(1 + (m2/m1))) * nhat;
	}
}
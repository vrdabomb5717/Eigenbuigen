public class PenaltyForce extends Force
{
	private var m_k:scalar;
	private var m_thickness:scalar;
	
	public def this(stiffness:scalar, thickness:scalar)
	{
		m_k = stiffness;
		m_thickness = thickness;
	}

	public def addEnergyToTotal(x:VectorXs, v:VectorXs, m:VectorXs, E:scalar)
	{

	}
	
	public def addGradEToTotal(x:VectorXs, v:VectorXs, m:VectorXs, r:VectorXs, var gradE:VectorXs)
	{
		val num_particles = x.size() / 2;
		
		for(var i:Int = 0; i < num_particles; i++)
	    {
			val r1 = r(i);
		
	        for(var j:Int = i + 1; j < num_particles; j++)
	        {
				val r2 = r(j);
				
	            addParticleParticleGradEToTotal(x, i, j, r1, r2, gradE);
	        }
	    }
	}
	
	// Adds the gradient of the penalty potential (-1 * force) for a pair of 
	// particles to the total.
	// Read the positions of the particles from the input variable x. Radii can
	// be obtained from the member variable m_scene, the penalty force stiffness 
	// from member variable m_k, and penalty force thickness from member variable
	// m_thickness.
	// Inputs:
	//   x:    The positions of the particles in the scene. 
	//   idx1: The index of the first particle, i.e. the position of this particle
	//         is ( x[2*idx1], x[2*idx1+1] ).
	//   idx2: The index of the second particle.
	// Outputs:
	//   gradE: The total gradient of penalty force. *ADD* the particle-particle
	//          gradient to this total gradient.
	public def addParticleParticleGradEToTotal(x:VectorXs, idx1:Int, idx2:Int, r1:Double, r2:Double, var gradE:VectorXs)
	{
	    val x1 = x.segment(2*idx1);
	    val x2 = x.segment(2*idx2);

	    // val r1 = m_scene.getRadius(idx1);
	    // val r2 = m_scene.getRadius(idx2);

		val n = x2 - x1;
		val nhat = n / n.norm();

		val tmp = n.norm() - r1 - r2 - m_thickness;

		if(tmp > 0)
			return;

		var deltaN:MatrixXs = new MatrixXs(2,4);
		deltaN << (-1, 0, 1, 0, 
					0, -1, 0, 1);

		val force = m_k * tmp * deltaN.transpose() * nhat;

		gradE.segment(2*idx1) += force.segment(0);
		gradE.segment(2*idx2) += force.segment(2);
	}
}
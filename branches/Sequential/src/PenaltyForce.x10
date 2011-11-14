import MathDefs.*;

public class PenaltyForce extends Force
{
	private var m_k:scalar;
	private var m_thickness:scalar;
	private m_scene:TwoDScene;
	
	public def this(scene:TwoDScene, stiffness:scalar, thickness:scalar)
	{
		m_scene = scene;
		m_k = stiffness;
		m_thickness = thickness;
	}

	public def addEnergyToTotal(x:VectorXs, v:VectorXs, m:VectorXs, E:scalar):void
	{
		// Feel free to implement if you feel like it.
	}
	
	public def addGradEToTotal(x:VectorXs, v:VectorXs, m:VectorXs, r:VectorXs, var gradE:VectorXs)
	{
		val num_particles = m_scene.getNumParticles();
		
		for(var i:Int = 0; i < num_particles; i++)
	    {		
	        for(var j:Int = i + 1; j < num_particles; j++)
	        {				
	            addParticleParticleGradEToTotal(x, i, j, gradE);
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
	public def addParticleParticleGradEToTotal(x:VectorXs, idx1:Int, idx2:Int, var gradE:VectorXs)
	{
	    val x1:VectorXs = x.segment(2*idx1);
	    val x2:VectorXs = x.segment(2*idx2);

	    val r1 = m_scene.getRadius(idx1);
	    val r2 = m_scene.getRadius(idx2);

		val n:VectorXs = (x2 - x1) as VectorXs ;
		val nhat:VectorXs = ( n / n.norm() ) as VectorXs ;
		
		if( n.norm() < r1 + r2 + m_thickness )
		{
			gradE(2*idx1) = ( gradE.segment(2*idx1) - m_k * (n.norm() - r1 - r2 - m_thickness ) * nhat ) ;
			gradE(2*idx2) = ( gradE.segment(2*idx2) + m_k * (n.norm() - r1 - r2 - m_thickness ) * nhat ) ;
		}
	}
	
	public def addGradEToTotal(var x:VectorXs, var v:VectorXs, var m:VectorXs, var gradE:VectorXs):void 
	{
    // TODO: auto-generated method stub
	}


}
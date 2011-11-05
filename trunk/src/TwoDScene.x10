import x10.util.ArrayList;
import MathDefs.*;

public class TwoDScene
{
	public def this(num_particles:Int)
	{
		assert(num_particles >= 0);

		m_x = new VectorXs(2*num_particles);
		m_v = new VectorXs(2*num_particles);
		m_m = new VectorXs(2*num_particles);
		m_fixed = new ArrayList[Boolean]();
		m_radii = new ArrayList[scalar]();
		m_forces = new ArrayList[Force]();
		
		m_x.setZero();
		m_v.setZero();
		m_m.setZero();
	}

	public def getNumParticles():Int
	{
		return m_x.size() / 2;
	}

	public def getX():VectorXs
	{
		return m_x;
	}

	public def getV():VectorXs 
	{
		return m_v;
	}

	public def getM():VectorXs
	{
		return m_m;
	}

	public def getRadii():ArrayList[scalar]
	{
		return m_radii;
	}

	public def setPosition( particle:Int, pos:Vector2s )
	{
		assert( particle >= 0 );
		assert( particle < getNumParticles() );

		m_x(2*particle) = pos;
	}

	public def setVelocity( particle:Int, vel:Vector2s )
	{
		assert( particle >= 0 );
		assert( particle < getNumParticles() );

		m_v(2*particle) = vel;
	}

	public def setMass( particle:Int, mass:scalar )
	{
		assert( particle >= 0 );
		assert( particle < getNumParticles() );

		m_m(2*particle)   = mass;
		m_m(2*particle+1) = mass;
	}

	public def setFixed( particle:Int, fixed:Boolean )
	{
		assert( particle >= 0 );
		assert( particle < getNumParticles() );

		m_fixed(particle) = fixed;
	}

	public def isFixed( particle:Int ):Boolean
	{
		assert( particle >= 0 );
		assert( particle < getNumParticles() );

		return m_fixed(particle);
	}

	public def getRadius( particle:Int ):scalar
	{
		assert( particle >= 0 );
		assert( particle < getNumParticles() );

		return m_radii(particle);
	}

	public def setRadius( particle:Int, radius:scalar )
	{
		assert( particle >= 0 );
		assert( particle < getNumParticles() );

		m_radii(particle) = radius;
	}

	public def insertForce(newforce:Force)
	{
		m_forces.add(newforce);
	}

	public def computeKineticEnergy():scalar
	{
		var T:scalar = 0.0;

		for( var i:Int = 0; i < getNumParticles(); ++i ) 
			T += m_m(2*i)*m_v.segment(2*i).dot(m_v.segment(2*i));

		return 0.5 * T;
	}

	public def computePotentialEnergy():scalar
	{
		var U:scalar = 0.0;

		for( var i:Int = 0; i < m_forces.size(); ++i ) 
			m_forces(i).addEnergyToTotal( m_x, m_v, m_m, U );
			
		return U;  
	}

	public def computeTotalEnergy():scalar
	{
		return computeKineticEnergy() + computePotentialEnergy();
	}

	public def accumulateGradU( var F:VectorXs, dx:VectorXs, dv:VectorXs )
	{
		assert( F.size() == m_x.size() );
		assert( dx.size() == dv.size() );
		assert( dx.size() == 0 || dx.size() == F.size() );

		// Accumulate all energy gradients
		if( dx.size() == 0 )
		{
			for( var i:Int = 0; i < m_forces.size(); ++i ) 
				m_forces(i).addGradEToTotal( m_x, m_v, m_m, F );
		}
		else
		{
			for( var i:Int = 0; i < m_forces.size(); ++i ) 
				m_forces(i).addGradEToTotal( m_x+dx, m_v+dv, m_m, F );
		}
	}

	public def checkConsistency()
	{
		assert( m_x.size() == m_v.size() );
		assert( m_x.size() == m_m.size() );
		assert( m_x.size() == (2*m_fixed.size()) as Int);
	}

	private var m_x:VectorXs;
	private var m_v:VectorXs;
	private var m_m:VectorXs;
	private var m_fixed:ArrayList[Boolean];

	// Vertex radii
	private var m_radii:ArrayList[scalar];

	// Forces. Note that the scene inherits responsibility for deleting forces.
	private var m_forces:ArrayList[Force];
}
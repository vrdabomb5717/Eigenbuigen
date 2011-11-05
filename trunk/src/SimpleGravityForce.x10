import MathDefs.*;

public class SimpleGravityForce extends Force
{
	private var m_gravity:Vector2s;
	
	public def this(gravity:Vector2s)
	{
		assert( (m_gravity.array() == m_gravity.array()).all() );
		assert( (m_gravity.array() != Double.POSITIVE_INFINITY).all() );
	}

	public def addEnergyToTotal(x:VectorXs, v:VectorXs, m:VectorXs, var E:scalar):void
	{
		assert( x.size() == v.size() );
		assert( x.size() == m.size() );
		assert( x.size() % 2 == 0 );

		// Assume 0 potential is at origin
		for( var i:Int = 0; i < x.size()/2; ++i )
		{
			E -= m(2*i)*m_gravity.dot(x.segment(2*i));
		}
	}
	
	public def addGradEToTotal(x:VectorXs, v:VectorXs, m:VectorXs, gradE:VectorXs):void
	{
		assert( x.size() == v.size() );
		assert( x.size() == m.size() );
		assert( x.size() == gradE.size() );
		assert( x.size() % 2 == 0 );

		for( var i:Int = 0; i < x.size()/2; ++i )
		{
			gradE.segment(2*i) -= m(2*i)*m_gravity;
		}
	}
	
	// public addHessXToTotal(x:VectorXs, v:VectorXs, m:VectorXs, hessE:MatrixXs):void
	// {
	// 	assert( x.size() == v.size() );
	// 	assert( x.size() == m.size() );
	// 	assert( x.size() == hessE.rows() );
	// 	assert( x.size() == hessE.cols() );
	// 	assert( x.size() % 2 == 0 );
	// 	// Nothing to do.
	// }
	// 
	// public addHessVToTotal(x:VectorXs, v:VectorXs, m:VectorXs, hessE:MatrixXs):void
	// {
	// 	assert( x.size() == v.size() );
	// 	assert( x.size() == m.size() );
	// 	assert( x.size() == hessE.rows() );
	// 	assert( x.size() == hessE.cols() );
	// 	assert( x.size()%2 == 0 );
	// 	// Nothing to do.
	// }
	// 
	// public createNewCopy():Force
	// {
	// 	return new SimpleGravityForce(*this);
	// }
}
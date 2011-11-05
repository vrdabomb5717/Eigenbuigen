public abstract class CollisionHandler 
{
	static struct CollisionInfo
	{
		def this(idx1:Int, idx2:Int, n:VectorXs, time:Double)
		{
			m_idx1 = idx1;
			m_idx2 = idx2;
			m_n = n;
		}
		
		private m_idx1:Int;
		private m_idx2:Int;
		private m_n:VectorXs;
	}
	
	public def this(COR:Double)
	{
		m_COR = COR;
	}
	
	public abstract handleCollisions(oldpos:VectorXs, oldvel:VectorXs, dt:scalar):void;
	
	public def getCOR():Double
	{
		return m_COR;
	}
	
	public abstract getName():String;
	
	protected def addParticleParticleImpulse(idx1:Int, idx2:Int, n:VectorXs, time:Double)
	{
		
	}
	
	private m_COR:Double;
}
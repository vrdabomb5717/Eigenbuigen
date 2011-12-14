import x10.util.ArrayList;
import MathDefs.*;

public abstract class CollisionHandler 
{
	static struct CollisionInfo
	{
		def this(idx1:Int, idx2:Int, n:VectorXs, time:Double)
		{
			m_idx1 = idx1;
			m_idx2 = idx2;
			m_n = n;
			m_time = time;
		}
		
		private m_idx1:Int;
		private m_idx2:Int;
		private m_n:VectorXs;
		private m_time:Double;
	}
	
	public def this(COR:Double)
	{
		m_impulses = new ArrayList[CollisionInfo]();
		m_COR = COR;
	}
	
	public abstract def handleCollisions(scene:TwoDScene, detector:CollisionDetector, oldpos:VectorXs, oldvel:VectorXs, dt:scalar):void;
	
	public def getCOR():Double
	{
		return m_COR;
	}
	
	public abstract def getName():String;
	
	public def clearImpulses()
	{
		m_impulses.clear();
	}
	
	public def getImpulses():ArrayList[CollisionInfo]
	{
		return m_impulses;
	}
	
	// resolve forces
	protected def addParticleParticleImpulse(idx1:Int, idx2:Int, n:VectorXs, time:Double)
	{
		m_impulses.add(CollisionInfo(idx1, idx2, n, time));
	}
	
	private m_COR:Double;
	private m_impulses:ArrayList[CollisionInfo];
	
}
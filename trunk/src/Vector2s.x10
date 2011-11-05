public class Vector2s extends VectorXs
{
	public def this()
	{
		super( 2 ) ;
	}
	
	public def x():double
	{
		return this(0) ;
	}
	
	public def y():double
	{
		return this(1) ;
	}
}
public class VectorXs extends Matrix
{
	public def this( rows:int )
	{
		super( rows ) ;
	}
	
	public operator this( x:Int )=( d:double ):void
	{
		this(x,0) = d ;
	}
	
	public operator this( x:Int ):double = this(x,0) ;
	
	public def size():double
	{
		return this.num_rows() ;
	}
}
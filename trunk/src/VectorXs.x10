public class VectorXs extends Matrix
{
	public def this( rows:int )
	{
		super( rows ) ;
	}
	
	public def size():double
	{
		return this.num_rows() ;
	}
}
import x10.lang.Math ;

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
	
	public def norm():double
	{
		var sum:double = 0 ;
		for( [i] in 0..(this.num_rows()-1) )
		{
			sum += this(i,0)*this(i,0) ;
		} 
		
		return Math.sqrt( sum ) ;
	}
}
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
	
	public def size():int
	{
		return this.num_rows() ;
	}
	
	public def norm():double
	{
		var sum:double = 0 ;
		for( [i] in 0..(size()-1) )
		{
			sum += this(i,0)*this(i,0) ;
		}
		
		return Math.sqrt( sum ) ;
	}
	
	public def segment( pos:int, n:int ):VectorXs
	{
		val result:VectorXs = new VectorXs( n ) ;
		
		for( [i] in 0..(size()-1) )
			result(i) = this(pos+i) ;
		
		return result ;
	}
	
	public def segment( pos:int ):VectorXs
	{
		return segment( pos, 2 ) ;
	}
	
	public operator this( pos:int )=( other:VectorXs ):void
	{
		if( pos + other.size() < size() )
		{
			Console.OUT.println( "Trying to place values into a vector past its max size." ) ;
			return ;
		}
		
		for( [i] in 0..(other.size()-1) )
			this(pos+i) = other(i) ;
	}
	
	public operator this/( other:VectorXs ):VectorXs
	{
		val result:VectorXs = new VectorXs( size() ) ;
		
		for( [i] in 0..(size()-1) )
			result(i) = this(i) / other(i) ;
		
		return result ;
	}
	
	public def dot( other:VectorXs ):double
	{
		var sum:double = 0d ;
		
		for( [i] in 0..(size()-1) )
			sum += this(i) * other(i) ;
		
		return sum ;
	}
}
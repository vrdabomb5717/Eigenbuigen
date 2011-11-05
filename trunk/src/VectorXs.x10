import x10.lang.Math ;

public class VectorXs extends Matrix
{
	public def this( rows:int )
	{
		super( rows ) ;
	}
	
	public def this( matrix:Matrix )
	{
		super( matrix ) ;
		assert( matrix.num_columns() == 1 ) ;
	}
	
	public operator this()=( other:VectorXs ):void
	{
		for( [i] in 0..(other.size()-1) )
			this(i) = other(i) ;
	}
	
	// a bunch of operators that call on the matrix operators
	public operator this*( other:VectorXs ):VectorXs = new VectorXs( this as Matrix * other as Matrix ) ;
	public operator this+( other:VectorXs ):VectorXs = new VectorXs( this as Matrix + other as Matrix ) ;
	public operator this-( other:VectorXs ):VectorXs = new VectorXs( this as Matrix - other as Matrix ) ;
	public operator this/( other:double ):VectorXs = this*(1/other) ;
	
	public operator this*( other:double ):VectorXs// = new VectorXs( this as Matrix * other ) ;
	{
		val result = new VectorXs( size() ) ;
		for( [i] in 0..(size()-1) )
			result(i) = this(i)*other ;
		return result ;
	}
	public operator ( other:double )*this:VectorXs = this*other ;
	
	public static operator (other:Matrix) as ? = new VectorXs( other ) ;
	
	// assign d to position x in the vector
	public operator this( x:Int )=( d:double ):void
	{
		this(x,0) = d ;
	}
	
	public operator this<<( arg:Array[double] ):void
	{
		for( [i] in 0..(size()-1) )
			this(i) = arg(i) ;
	}
	
	// return the value from position x 
	public operator this( x:Int ):double = this(x,0) ;
	
	// return size of vector
	public def size():int = this.num_rows() ;
	
	// place values from other vector into this vector starting from position pos
	public operator this( pos:int )=( other:VectorXs ):void
	{
		assert pos + other.size() <= size() :
			"Trying to place values into a vector past its max size: " + 
			"num elements: " (pos+other.size()) +
			"from: " + pos +
			"to: " + pos + other.size() ;
		
		for( [i] in 0..(other.size()-1) )
			this(pos+i) = other(i) ;
	}
	
	// divide each i in vector this by vector other, and return a new vector with those divisions
	public operator this/( other:VectorXs ):VectorXs
	{
		val result:VectorXs = new VectorXs( size() ) ;
		
		for( [i] in 0..(size()-1) )
			result(i) = this(i) / other(i) ;
		
		return result ;
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
	
	// return a segment starting at pos of size n
	public def segment( pos:int, n:int ):VectorXs
	{
		val result:VectorXs = new VectorXs( n ) ;
		
		for( [i] in 0..(n-1) )
			result(i) = this(pos+i) ;
		
		return result ;
	}
	
	// return a segment starting at pos of size 2
	public def segment( pos:int ):VectorXs
	{
		return segment( pos, 2 ) ;
	}
	
	// return dot product
	public def dot( other:VectorXs ):double
	{
		var sum:double = 0d ;
		
		for( [i] in 0..(size()-1) )
			sum += this(i) * other(i) ;
		
		return sum ;
	}
	
	public def transpose():VectorXs
	{
		return new VectorXs( super.transpose() ) ;
	}
}
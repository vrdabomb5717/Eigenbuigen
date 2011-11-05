
public class Matrix
{
	private val matrix:Array[double](2) ;
	private val rows:int ;
	private val columns:int ;
	
	public def this( m:int, n:int )
	{
		matrix = new Array[double]((0..(m-1)) * (0..(n-1)), 0d ) ;
		rows = m ;
		columns = n ;
	}
	
	public def this( m:int, n:int, v:double )
	{
		matrix = new Array[double]((0..(m-1)) * (0..(n-1)), v ) ;
		rows = m ;
		columns = n ;
	}
	
	public def this( m:int )
	{
		matrix = new Array[double]((0..(m-1))*(0..0), 0d ) ;
		rows = m ;
		columns = 1 ;
	}
	
	public operator this(x:Int, y:Int):double = matrix(x,y) ;
	
	public operator this( x:Int, y:Int )=( d:double ):void
	{
		matrix(x,y) = d ;
	}
	
	public operator this<<( arg:Array[double] ):void
	{
		for( [i] in 0..(rows-1) )
			for( [j] in 0..(columns-1) )
				matrix(i,j) = arg(i,j) ;
	}
	
	public operator this*( other:Matrix ):Matrix
	{
		if( columns != other.num_rows() )
		{
			Console.OUT.println( "Columns are not equal to rows:" + columns + ":" + other.num_rows() ) ;
			return null ;
		}
		
		val result = new Matrix( rows, other.num_columns(), 0d) ;
		
		for( [i,j] in (0..(rows-1))*(0..(other.columns-1)) )
		{
			for( [k] in 0..(columns-1) )
			{
				result(i,k) += matrix(i,k) * other(k,j) ;
			}
		}
		
		return result ;
	}
	
	public operator this-( other:Matrix )
	{
		
	}
	
	public def num_rows():int = rows ;
	
	public def num_columns():int = columns ;
	
	
}
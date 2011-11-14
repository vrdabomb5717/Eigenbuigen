
public class Matrix
{
	private var matrix:Array[double](2) ;
	private var rows:int ;
	private var columns:int ;
	
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
	
	public def this( other:Matrix )
	{
		matrix = new Array[double]((0..(other.num_rows()-1))*(0..(other.num_columns()-1)), 0d ) ;
		rows = other.num_rows() ;
		columns = other.num_columns() ;
		
		for( [i,j] in (0..(rows-1))*(0..(columns-1)) )
			matrix(i,j) = other(i,j) ;
	}
	
	public operator this(x:Int, y:Int):double = matrix(x,y) ;
	
	public operator this()=( other:Matrix ):void
	{
		this.matrix = other.array() ;
		this.rows = other.num_rows() ;
		this.columns = other.num_columns() ;
		
		// for( [i,j] in (0..(rows-1))*(0..(columns-1)) )
		// {
		// 	matrix(i,j) = other(i,j) ;
		// }
	}
	
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
		assert columns == other.num_rows() : 
			"Columns of this matrix are not equal to rows of other:" + 
            "\nthis columns: " + columns + 
            "\nother rows: " + other.num_rows();
		
		val result = new Matrix( rows, other.num_columns(), 0d) ;
		
		for( [i,j] in (0..(rows-1))*(0..(other.num_columns()-1)) )
		{
			for( [k] in 0..(columns-1) )
			{
				result(i,k) += matrix(i,k) * other(k,j) ;
			}
		}
		
		return result ;
	}
	
	public operator this*( other:double ):Matrix
	{
		val result:Matrix = new Matrix( rows, columns, 0d) ;
		
		for( [i,j] in (0..(rows-1))*(0..(columns-1)) )
		{
			result(i,j) = matrix(i,j) * other ;
		}
		
		return result ;
	}
	
	public operator ( other:double )*this:Matrix = this*other ;
	
	public operator this/( other:double ):Matrix = this*(1/other) ;
		
	public operator this+( other:Matrix ):Matrix
	{
		assert rows == other.num_rows() && columns == other.num_columns() : 
			"Matricies most be of same size for addition: " + 
			"\nthis rows: " + rows +
			"\nthis columns: " + columns +
			"\nother rows: " + other.num_rows() +
			"\nother columns: " + other.num_columns() ;
		
		val result:Matrix = new Matrix( rows, columns, 0d) ;
		
		for( [i,j] in (0..(rows-1))*(0..(columns-1)) )
			result(i,j) = matrix(i,j) + other(i,j) ;
		
		return result ;
	}
	
	public operator this-( other:Matrix )
	{
		assert rows == other.num_rows() && columns == other.num_columns() :
			"Matricies most be of same size for addition: " + 
			"\nthis rows: " + rows +
			"\nthis columns: " + columns +
            "\nother rows: " + other.num_rows() +
            "\nother columns: " + other.num_columns() ;
		
		val result:Matrix = new Matrix( rows, columns, 0d) ;
		
		for( [i,j] in (0..(rows-1))*(0..(columns-1)) )
			result(i,j) = matrix(i,j) - other(i,j) ;
		
		return result ;
	}
	
	public operator this->( other:Matrix ):boolean
	{
		for( [i,j] in (0..(rows-1))*(0..(columns-1)) )
			if( this(i,j) != other(i,j) )
				return false ;
		
		return true ;
	}
	
	public def num_rows():int = rows ;
	
	public def num_columns():int = columns ;
	
	public def setZero():void
	{
		for( [i,j] in (0..(rows-1))*(0..(columns-1)) )
			matrix(i,j) = 0d ;
	}
	
	public def transpose():Matrix
	{
		val result:Matrix = new Matrix( columns, rows, 0d) ;
		
		for( [i,j] in (0..(columns-1))*(0..(rows-1)) )
			result(i,j) = matrix(j,i) ;
		
		return result ;
	}
	
	public def array():Array[double]
	{
		return matrix ;
	}
}
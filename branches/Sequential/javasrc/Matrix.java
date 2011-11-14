public class Matrix implements Cloneable
{
	private double matrix[][];
	private int rows;
	private int columns;
	
	public Matrix(int myRows, int myColumns)
	{
		matrix = new double[myRows][myColumns];
		rows = myRows;
		columns = myColumns;
	}
	
	public Matrix(int myRows, int myColumns, int value)
	{
		matrix = new double[myRows][myColumns];
		rows = myRows;
		columns = myColumns;
		
		for(int i = 0; i < rows; i++)
		{
			for(int j = 0; j < columns; j++)
			{
				matrix[i][j] = value;
			}
		}
	}
	
	public double getElement(int myRow, int myColumn)
	{
		return matrix[myRow][myColumn];
	}
	
	public void setElement(int myRow, int myColumn, double result)
	{
		matrix[myRow][myColumn] = result;
	}
	
	public int getRows()
	{
		return rows;
	}
	
	public int getColumns()
	{
		return columns;
	}
	
	public Matrix clone()
	{
		try {
			super.clone();
		} catch (CloneNotSupportedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		Matrix cloned = new Matrix(rows, columns);
		
		for(int i = 0; i < rows; i++)
		{
			for(int j = 0; j < columns; j++)
			{
				cloned.setElement(i, j, matrix[i][j]);
			}
		}
		
		return cloned;
	}
	
	public Matrix createTranspose()
	{
		Matrix transpose = new Matrix(columns, rows);
		
		for(int i = 0; i < columns; i++)
		{
			for(int j = 0; j < rows; j++)
			{
				transpose.setElement(i, j, matrix[j][i]);
			}
		}
		
		return transpose;
	}
	
	
	public double magnitude()
	{
		if(columns != 1)
			return 0.0;
		else
		{
			double length = 0.0;
			
			for(int i = 0; i < rows; i++)
			{
				length += matrix[i][0] * matrix[i][0];
			}
			
			length = Math.sqrt(length);
			
			return length;
		}
	}
}

public class MatrixMath
{
	
	public  Matrix multiplyTwoMatrices(Matrix matrixOne, Matrix matrixTwo)
	{
		if(matrixOne.getColumns() != matrixTwo.getRows())
		{
			System.out.println("You can't multiply these two matrices together.");
			return null;
		}
		
		
		//An MxN matrix times an NxR matrix results in a matrix of size MxR
		Matrix result = new Matrix(matrixOne.getRows(), matrixTwo.getColumns() );
		
		for(int i=0; i < matrixOne.getRows(); i++)
		{
			for(int j=0; j < matrixTwo.getColumns(); j++)
			{
				double sum = 0.0;
				result.setElement(i,j, sum);
								
				for(int k=0; k < matrixOne.getColumns(); k++)
				{
					sum += matrixOne.getElement(i,k) * matrixTwo.getElement(k,j);
					result.setElement(i,j, sum);
				}
			}
		}
		
		return result;
	}
	
	public Matrix raiseMatricesToPower(Matrix matrixOne, int power)
	{
		if(matrixOne.getRows() != matrixOne.getColumns() )
		{
			System.out.println("You cannot raise a non-square matrix to a power.");
			return null;
		}
		
		Matrix result = matrixOne;
		
		//a square matrix raised to the 0 power is the identity matrix of that size
		if(power == 0)
		{
			for(int i=0; i < result.getRows(); i++)
			{
				for(int j=0; j < result.getColumns(); j++)
				{
					if(i == j)
						result.setElement(i, j, 1.0);
					else
						result.setElement(i, j, 0.0);		
				}
			}
		}
		
		
		for(int i=1; i < power; i++)
		{
			result = multiplyTwoMatrices(result, matrixOne);
		}
		
		return result;
	}
	
	public Matrix multiplyByConstant(Matrix m, double constant)
	{
		Matrix result = new Matrix(m.getRows(), m.getColumns() );
		
		for(int i=0; i < m.getRows(); i++)
		{
			for(int j=0; j < m.getColumns(); j++)
			{
					result.setElement(i,j, m.getElement(i, j) * constant);
			}
		}
		
		return result;
	}
	
	public Matrix addMatrices(Matrix a, Matrix b)
	{
		if(a.getRows() != b.getRows() && a.getColumns() != b.getColumns())
		{
			System.out.println("Matrix addition only works on matrices of the same size. Try again.");
			return null;
		}
		
		Matrix result = new Matrix(a.getRows(), a.getColumns() );
		
		for(int i=0; i < a.getRows(); i++)
		{
			for(int j=0; j < a.getColumns(); j++)
			{
					result.setElement(i,j, a.getElement(i, j) + b.getElement(i, j));
			}
		}
		
		return result;
	}
	
	public Matrix subtractMatrices(Matrix a, Matrix b)
	{
		if(a.getRows() != b.getRows() && a.getColumns() != b.getColumns())
		{
			System.out.println("Matrix addition only works on matrices of the same size. Try again.");
			return null;
		}
		
		Matrix result = new Matrix(a.getRows(), a.getColumns() );
		
		for(int i=0; i < a.getRows(); i++)
		{
			for(int j=0; j < a.getColumns(); j++)
			{
					result.setElement(i,j, a.getElement(i, j) - b.getElement(i, j));
			}
		}
		
		return result;
	}
	
}
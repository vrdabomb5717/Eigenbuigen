
public class GaussianElimination 
{
	public GaussianElimination()
	{

	}

	public Matrix[] completeSolution(Matrix A)
	{
		Matrix[] solutions;
		Matrix[] specialSolutions;
		Matrix C = A.clone();
		Matrix R = rref(C);
		getRank(R);

		if(R == null)
		{
			System.out.println("There is no solution for the system.");
			return null;
		}

		//System.out.println(rank);
		if(rank != 0)
		{
			for(int q = rank - 1; (((rank < R.getRows() && rank == R.getColumns() - 1) || (rank < R.getRows() && rank < R.getColumns() - 1) ) && q < R.getRows()); q++)
			{
				
				for(int s = 0; s < R.getColumns(); s++)
				{
					if(s < R.getColumns() - 1 && R.getElement(q, s) == 0)
						continue;
					//look through the last column. If there's an element there that's not 0, and the entire row is full of 0s, then there is no solution.
					else if(s == R.getColumns() - 1 && R.getElement(q, s) != 0)
					{
						System.out.println("There is no solution for the system.");
						return null;
					}
					else
						break;
				}

			}
		}
		else
		{
			//look through the last column of R and see if every element is 0. If so, there are infinite solutions. If not, there are no solutions.

			for(int r = 0; r < R.getRows(); r++)
			{
				if(R.getElement(r, R.getColumns() - 1) != 0)
				{
					System.out.println("There is no solution for the system.");
					return null;
				}
			}


		}

		specialSolutions = this.findSpecialSolutions(R);

		//the first element will be the particular solution
		solutions = new Matrix[specialSolutions.length + 1];
		solutions[0] = this.findParticularSolution(R);

		if(rank == R.getRows() && rank == R.getColumns() - 1)
			System.out.println("There is only one solution.");
		else if(rank == R.getRows() && rank < R.getColumns() - 1)
			System.out.println("There is an infinite number of solutions.");
		else if(rank < R.getRows() && rank == R.getColumns() - 1)
			System.out.println("There is exactly 1 solution.");
		else if(rank < R.getRows() && rank < R.getColumns() - 1)
			System.out.println("There is an infinite number of solutions.");


		//copy the special solutions into our answer matrix
		for(int i = 1; i < solutions.length; i++)
		{
			solutions[i] = specialSolutions[i-1];
		}

		return solutions;
	}


	public Matrix rref(Matrix A)
	{
		Matrix U = forwardElimination(A);
		Matrix R = UtoR(U);
		return R;
	}

	public int[] findPivots(Matrix A)
	{
		Matrix C = A.clone();
		Matrix U = forwardElimination(C);
		Matrix R = UtoR(U);
		int[] pivots = markPivots(R);

		return pivots;
	}

	private Matrix forwardElimination(Matrix A)
	{
		int currentCol = 0;

		//iterate through all the columns of the augmented matrix
		for(int k = 0; k < A.getColumns() - 1 && currentCol < A.getColumns() - 1; k++, currentCol++)
		{
			//while a pivot is 0, attempt a row swap. Don't attempt to do a row swap if there are no rows under the k we're looking at.
			while(currentCol < A.getColumns() - 1 && k < A.getRows() && A.getElement(k,currentCol) == 0)
			{
				//find a row with a non-zero element in the same column
				for(int l = k; l <= A.getRows(); l++)
				{
					//we looked through every row and couldn't find a non-zero pivot, so this column should be marked free. Move on to the next column.
					if(l == A.getRows())
					{
						currentCol++;
						break;
					}

					//we've found a row with a non-zero element; now do a row swap
					if(A.getElement(l,k) != 0)
					{
						//swap the two rows, row l and row k
						for(int a = 0; a < A.getColumns(); a++)
						{
							double temp = A.getElement(l, a);
							A.setElement(l, a, A.getElement(k, a));
							A.setElement(k, a, temp);
						}

						break;
					}
				}
			}

			//go through all the rows beneath row k. Row k stays the same.
			for(int i = k+1; i < A.getRows(); i++)
			{
				if(A.getElement(k, currentCol) != 0)
				{
					double multiplier = (A.getElement(i, currentCol)/A.getElement(k, currentCol));

					//for any values underneath and to the right of the pivot, do elimination
					for(int j = currentCol; j < A.getColumns(); j++)
					{
						double value = A.getElement(i, j) - (multiplier*A.getElement(k, j));
						A.setElement(i, j, value);

					}
				}
			}

		}

		return A;
	}

	private Matrix UtoR(Matrix U)
	{

		//iterate through all the columns of the augmented matrix, but now backwards
		for(int k = U.getColumns() - 2; k >= 0; k--)
		{

			for(int i = U.getRows() - 1; i >= 0; i--)
			{	
				//pivot marks the location of the column where the pivot occurs
				int pivot = -1;
				double pivotValue = 0;
				boolean foundPivot = false;


				//for each row, iterate through the columns to find the first non-zero element. That must be the pivot.
				for(int p = 0; p < U.getColumns(); p++)
				{
					//if we've found the pivot, mark its location
					if(!foundPivot && U.getElement(i, p) !=0)
					{
						pivot = p;
						pivotValue = U.getElement(i, pivot);
						foundPivot = true;
					}

					//Divide the row by the pivot's value to make the pivot equal to 1
					if(foundPivot)
					{
						double quotient = (U.getElement(i, p) / pivotValue );
						//System.out.println(quotient);
						U.setElement(i, p, quotient);
					}

				}

				/*if the entire column is full of 0s, we just continue iterating over every column and do nothing. 
				 * We check if the value for d is 0. If it is, we will have a solution to the matrix, and we then move on to the next row.
				 * If not, we return null and let a higher-up method handle what to do next.
				 */
				if(pivot == -1)
				{
					if(U.getElement(i, U.getColumns() - 1) == 0)
						continue;
					else
					{
						//System.out.println("There is no solution for the system.");
						//return null;
					}
				}


				for(int l = i - 1; l >= 0; l--)
				{
					double multiplier = (U.getElement(l, pivot)/U.getElement(i, pivot));

					for(int j = pivot; j < U.getColumns(); j++)
					{
						double value = U.getElement(l, j) - (multiplier*U.getElement(i, j));
						U.setElement(l, j, value);

					}
				}
			}

		}

		return U;
	}

	public int getRank(Matrix A)
	{
		Matrix C = A.clone();
		this.markPivots(this.rref(C));
		return rank;
	}

	public int getRank()
	{
		return rank;
	}

	private int[] markPivots(Matrix R)
	{
		int[] columns = new int[R.getColumns() - 1];

		//initialize all elements to 0, marking them as free columns
		for(int a : columns)
		{
			columns[a] = 0;
		}

		//iterate over R and mark the columns that are pivots with 1s.
		for(int i = 0; i < R.getRows(); i++)
		{
			for(int j = 0; j < R.getColumns() - 1; j++)
			{
				if(R.getElement(i, j) != 0)
				{
					columns[j] = 1;
					if(writeRank)
						rank++;
					break;
				}
			}
		}
		writeRank = false;
		return columns;
	}

	private Matrix[] findSpecialSolutions(Matrix R)
	{
		int[] pivots = this.markPivots(R);

		int special = 0;

		//determine how many special solutions there are
		for(int a : pivots)
		{
			if(a == 0)
				special++;
		}

		Matrix[] specialSolutions = new Matrix[special];

		//create the special solution matrices and initialize them to zero
		for(int b = 0; b < specialSolutions.length; b++)
		{
			specialSolutions[b] = new Matrix(pivots.length, 1, 0);

			int currentFree = 0;

			for(int c = 0; c < pivots.length; c++)
			{
				//look for the appropriate free column to read values off from
				if(pivots[c] == 0)
				{
					currentFree++;

					//if we found the correct free column, then read the values into the special solution matrix
					if(currentFree - 1 == b)
					{
						//set the appropriate free variable to 1
						specialSolutions[b].setElement(c, 0, 1);

						//variable to keep track of what row to look at, indicated by the pivots seen so far
						int currentPivot = 0;

						for(int d = 0; d < pivots.length; d++)
						{
							if(pivots[d] == 1)
							{
								//look at the current pivot row to find the element to insert into the special solution matrix
								double result = R.getElement(currentPivot, c);

								if(result != 0)
									result = -result;

								specialSolutions[b].setElement(d, 0, result);
								currentPivot++;
							}
						}

					}
				}


			}
		}

		return specialSolutions;
	}

	private Matrix findParticularSolution(Matrix R)
	{
		int[] pivots = this.markPivots(R);

		Matrix Xp = new Matrix(pivots.length, 1);

		int row = 0;

		for(int i = 0; i < pivots.length && row < R.getRows(); i++)
		{
			//if the column is a pivot column, then the particular solution contains the element from d ( corresponding to [R d] ) in that place
			if(pivots[i] == 1)
			{
				double element = R.getElement(row, R.getColumns() - 1);
				Xp.setElement(i, 0, element);
				row++;
			}
			else
			{
				//set all the free variables to be 0 in the particular solution
				Xp.setElement(i, 0, 0);
			}
		}

		return Xp;
	}

	private int rank = 0;
	private boolean writeRank = true;
}
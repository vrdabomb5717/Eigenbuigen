import MathDefs.*;

public class VectorXsTest
{
	public static def main(argv:Rail[String])
	{
		var a:VectorXs = new VectorXs(5);
		var b:VectorXs = new VectorXs(5);
		val constant = 10;
		
		val ints = [1,2,3,4,5];
		val moreInts = [6,7,8,9,10];
		
		testSetZero(a);
		
		// test appending to array
		a << ints;
		
		for([i] in 0..4)
		{
			assert(a(i) == ints(i));
		}
		
		a.setZero();
		
		// test size method
		assert(a.size() == 5);
		
		// test rows
		assert(a.num_rows() == 5);
	
		// test columns
		assert(a.num_columns() == 1);
		
		// test norm method
		assert(a.norm() - Math.sqrt(55) <= .0001);
		
		// test segment method
		val pos = 3;
		val c = a.segment(pos);
		assert(c(0) == a(pos));
		assert(c(1) == a(pos + 1));
		
		// testing a.segment(index) = VectorXs
		val newPos = 0;
		a(newPos) = c;
		assert(a(newPos) == c(0));
		assert(a(newPos + 1) == c(1));
		
		// assert rewriting all elements after the vector has been written to
		a << ints;
		for([i] in 0..4)
		{
			assert(a(i) == ints(i));
		}
		
		// test addition
		val d = a + b;
		for([i] in 0..4)
		{
			assert(d(i) == a(i) + b(i));
		}
		
		// test subtraction
		val e = a - b;
		for([i] in 0..4)
		{
			assert(e(i) == a(i) - b(i));
		}
		
		// test dot product
		val f = (b-a).dot(b-a);
		assert(f == 25);
		
		// test division operator
		val g = b / a;
		for([i] in 0..4)
		{
			assert(g(i) == ((b*1.0) / a));
		}
		
		// test multiplication operator with VectorXs
		val h = b * a;
		for([i] in 0..4)
		{
			assert(h(i) == ((b*1.0) / a));
		}
		
		// test multiplication operator with constants
		val j = constant * a;
		val k = a * constant;
		for([i] in 0..4)
		{
			assert(j(i) == k(i));
			assert(j(i) == a(i) * constant);
		}
		
		a.setZero();
		a << ints;
		
		// test transpose
		val m = a.transpose();
		assert(m.num_columns() == a.num_rows());
		assert(m.num_rows() == a.num_columns());
		for([i] in 0..4)
		{
			assert( m(0,i) == a(i) );
		}
		
		Console.OUT.println("Success!");
	}
	
	public static def testSetZero(var a:VectorXs)
	{
		a.setZero();
		
		for([i] in 0..4)
		{
			assert(a(i) == 0);
		}
	}

}
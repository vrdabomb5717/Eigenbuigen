public class SceneTesterPar
{
	static val Meg = 1000*1000;
	
	public static def main(args:Rail[String])
	{
		if (args.size < 9) 
		{
			x10.io.Console.OUT.println("Usage: SceneTester <inputFileName:String> <outputFileName:String> <num_particles:Int> <dt:Double> <duration:Double> <k:Double> <thickness:Double> <COR:Double> <MAX_ASYNC:Int>.");
			return;
		}
		
		val inputFileName = args(0);
		val outputFileName = args(1);
		val num_particles = Int.parse(args(2));
		val dt = Double.parse(args(3));
		val duration = Double.parse(args(4));
		val k = Double.parse(args(5));
		val thickness = Double.parse(args(6));
		val cor = Double.parse(args(7));
		val max_async = Int.parse( args( 8 ) ) ;
		
		Console.OUT.println( "creating: " + num_particles + ":" + dt + ":" + duration ) ;
		
		val sr = new SceneReaderPar(num_particles);
		sr.read(inputFileName);
		val time = System.nanoTime();
		sr.animate(dt, duration, k, thickness, cor, outputFileName, max_async ) ;
		val parallelTime = (System.nanoTime()-time)/Meg;
		Console.OUT.println("Time for parallel animation: " + parallelTime) ;
		// sr.write(outputFileName);
	}
}

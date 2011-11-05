import MathDefs.*;

public class SemiImplicitEuler 
{
	public def stepScene( scene:TwoDScene, dt:scalar):boolean
	{
		var x:VectorXs = scene.getX();
		var v:VectorXs = scene.getV();
		val m:VectorXs = scene.getM();

		// Compute forces using start-of-step state
		var F:VectorXs = new VectorXs(x.size());
		F.setZero();
		scene.accumulateGradU( F, x, v ) ;
		// Force is negative the energy gradient
		F *= -1.0;

		// Zero the force for fixed DoFs
		// for( var i:Int = 0; i < scene.getNumParticles(); ++i )
		// 	if( scene.isFixed(i) ) F.segment(2*i).setZero();

		// Step velocities forward based on start-of-step forces
		F /= m;
		v += (dt*F) as VectorXs;

		// Step positions forward based on new velocities
		x += dt*v;

		return true;	
	}

	public getName():String
	{
		return "Forward-Backward Euler";
	}
}
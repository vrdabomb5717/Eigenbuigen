import MathDefs.*;

public abstract class Force
{
	public abstract def addEnergyToTotal(x:VectorXs, v:VectorXs, m:VectorXs, E:scalar):void;
	
	public abstract def addGradEToTotal(x:VectorXs, v:VectorXs, m:VectorXs, gradE:VectorXs):void;
	
	// public abstract addHessXToTotal(x:VectorXs, v:VectorXs, m:VectorXs, hessE:MatrixXs):void;
	
	// public abstract addHessVToTotal(x:VectorXs, v:VectorXs, m:VectorXs, hessE:MatrixXs):void;
	
	// public abstract createNewCopy():Force;
}

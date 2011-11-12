public abstract class CollisionDetector
{
	public abstract def performCollisionDetection(scene:TwoDScene, qs:VectorXs, qe:VectorXs, dc:DetectionCallback):void;
}
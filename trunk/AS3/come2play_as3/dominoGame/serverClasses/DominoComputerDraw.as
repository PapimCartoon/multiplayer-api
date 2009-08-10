package come2play_as3.dominoGame.serverClasses
{
	import come2play_as3.dominoGame.serverClasses.DominoDraw;

	public class DominoComputerDraw extends DominoDraw
	{
		static public const DOMINO_COMPUTER_DRAW:String = "DominoComputerDraw"
		static public function create():DominoComputerDraw{
			return new DominoComputerDraw()
		}
	}
}
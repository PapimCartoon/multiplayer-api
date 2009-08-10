package come2play_as3.dominoGame.serverClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class DominoComputerMove extends DominoMove
	{
		static public const DOMINO_COMPUTER_MOVE:String = "DominoComputerMove"
		public var dominoMove:DominoMove;
		static public function create(dominoMove:DominoMove):DominoComputerMove{
			var res:DominoComputerMove = new DominoComputerMove()
			res.key = dominoMove.key;
			res.moveNum = dominoMove.moveNum;
			res.playerId = dominoMove.playerId;
			res.connectToRight = dominoMove.connectToRight
			res.brickOrientation = dominoMove.brickOrientation
			return res;
		}
		
	}
}
package ticktactoeTuturial
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class TickTacToeMove extends SerializableClass
	{
		static public const TickTacToeMoveEvent:String = "TickTacToeMoveEvent";
		public var playerTurn:int;
		public var xPos:int;
		public var yPos:int;
		public function TickTacToeMove( bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(TickTacToeMoveEvent, bubbles, cancelable);
		}
		static public function create(playerTurn:int,xPos:int,yPos:int):TickTacToeMove
		{
			var res:TickTacToeMove = new TickTacToeMove();
			res.playerTurn = playerTurn;
			res.yPos = yPos;
			res.xPos = xPos;
			return res;
		}
		
	}
}
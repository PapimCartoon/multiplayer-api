package ticktactoeTuturial
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	public class TickTacToeMove extends SerializableClass
	{
		static public const TickTacToeMoveEvent:String = "TickTacToeMoveEvent"; //the Event Type
		public var playerTurn:int; //which player made this move
		public var xPos:int; 
		public var yPos:int; 
		public function TickTacToeMove( bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(TickTacToeMoveEvent, bubbles, cancelable);
		}
		
		/**
		*A static function that acts as the class constructor
		*
		*@param playerTurn Which player turn it is
		*@param xPos the x position on the tic tac toe board
		*@param yPos the y position on the tic tac toe board
		*/
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
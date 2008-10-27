package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	public class PlayerMove extends SerializableClass
	{
		public var isMine:Boolean;	
		public var playerId:int;
		public var xPos:int;
		public var yPos:int;
		static public function create(xPos:int,yPos:int,playerId:int,isMine:Boolean):PlayerMove
		{
			var res:PlayerMove = new PlayerMove();
			res.xPos = xPos;
			res.yPos = yPos;
			res.playerId = playerId;
			res.isMine = isMine;
			return res;
		}
	}
}
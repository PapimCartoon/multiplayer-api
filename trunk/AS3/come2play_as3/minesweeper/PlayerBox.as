package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	public class PlayerBox extends SerializableClass
	{
		public var xPos:int;
		public var yPos:int;
		public var isMine:Boolean;
		public var borderingMines:int;
		public var takingPlayer:int;
		public static function create(boxServer:ServerBox,userId:int):PlayerBox
		{
			var res:PlayerBox = new PlayerBox();
			res.xPos = boxServer.xPos;
			res.yPos = boxServer.yPos;
			res.isMine = boxServer.isMine;
			res.borderingMines = boxServer.borderingMines;
			res.takingPlayer = userId; 
			return res;
		}
	}
}
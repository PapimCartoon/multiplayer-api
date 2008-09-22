package come2play_as3.mineSweeper
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	public class ServerBox extends SerializableClass
	{
		public var isMine:Boolean;
		public var xPos:int;
		public var yPos:int;
		public var borderingMines:int;

		public static function create(isMine:Boolean,borderingMines:int,xPos:int,yPos:int):ServerBox
		{
			var res:ServerBox = new ServerBox();
			res.isMine = isMine;
			res.xPos = xPos;
			res.yPos = yPos;
			res.borderingMines = borderingMines
			return res;
		}
	}
}
package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	public class ComputerMove extends SerializableClass
	{
		public var xPos:int;
		public var yPos:int;
		static public function create(xPos:int,yPos:int):ComputerMove
		{
			var res:ComputerMove = new ComputerMove();
			res.xPos = xPos;
			res.yPos = yPos;
			return res;
		}
	}
}
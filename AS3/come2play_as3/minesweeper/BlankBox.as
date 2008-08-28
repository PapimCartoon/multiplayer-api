package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	public class BlankBox extends SerializableClass
	{
		public var xPos:int;
		public var yPos:int;
		public var bordering:int; // number of bordering mines
		public static function create(xPos:int,yPos:int,bordering:int):BlankBox
		{
			var res:BlankBox =  new BlankBox();
			res.bordering = bordering;
			res.xPos = xPos;
			res.yPos = yPos;
			return res;
		}
	}
}
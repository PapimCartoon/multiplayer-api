package come2play_as3.pseudoCode.battleShips2
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class Ship extends SerializableClass
	{
		public var row:int, column:int,length:int,vertical:Boolean;
		
		public static function create(row:int, column:int,length:int,vertical:Boolean):Ship
		{
			var res:Ship = new Ship;
			res.row = row;
			res.column = column;
			res.length = length;
			res.vertical = vertical;
			return res;
		}
	}
}


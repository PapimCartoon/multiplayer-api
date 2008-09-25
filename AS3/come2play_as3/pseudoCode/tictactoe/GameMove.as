package come2play_as3.pseudoCode.tictactoe
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class GameMove extends SerializableClass
	{
		public var row:int, column:int;	
		
		public static function create(row:int, column:int):GameMove
		{
			var res:GameMove = new GameMove();
			res.row = row;
	    	res.column = column;
	    	return res;
		}
	}
}
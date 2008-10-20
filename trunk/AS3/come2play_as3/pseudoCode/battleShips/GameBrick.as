package come2play_as3.pseudoCode.battleShips
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class GameBrick extends SerializableClass
	{
		public var row:int, column:int,isShip:Boolean;
		public function GameBrick() { super("GameBrick"); }
		public static function create(row:int, column:int,isShip:Boolean):GameBrick
		{
			var res:GameBrick = new GameBrick()
			res.row = row;
			res.column = column;
			res.isShip = isShip;
			return res;
		}
	}
}
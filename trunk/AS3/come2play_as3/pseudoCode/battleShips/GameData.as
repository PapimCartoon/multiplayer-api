package come2play_as3.pseudoCode.battleShips
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class GameData extends SerializableClass
	{
		public var row:int, column:int,playerIdAttacked:int,isHit:Boolean,playerAttacking:int;
		public static function create(row:int, column:int,playerIdAttacked:int,isHit:Boolean,playerAttacking:int):GameData
		{
			var res:GameData = new GameData();
			res.row = row;
			res.column = column;
			res.playerAttacking = playerAttacking;
			res.playerIdAttacked = playerIdAttacked;
			res.isHit = isHit;
			return res;
		}
	}
}



package come2play_as3.pseudoCode.battleShips
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class GameMove extends SerializableClass
	{
		public var row:int, column:int,playerIdAttacked:int,playerAttacking:int;
		public function GameMove() { super("GameMove"); }
		public function objectKey():Object
	 	{
	  		return {playerIdAttacked:playerIdAttacked,row:row,column:column};
	  	}
	  	public function testKey(gameMoveTarget:Array):Boolean
  		{
  			return ((gameMoveTarget[0] == playerIdAttacked) && (gameMoveTarget[1] == row) && (gameMoveTarget[2] == column))
  		} 
  		public static function create(row:int, column:int,playerIdAttacked:int,playerAttacking:int):GameMove
  		{
  			var res:GameMove = new GameMove();
  			res.row = row;
  			res.column = column;
  			res.playerAttacking = playerAttacking;
  			res.playerIdAttacked = playerIdAttacked;
  			return res;
  		}
	}
}


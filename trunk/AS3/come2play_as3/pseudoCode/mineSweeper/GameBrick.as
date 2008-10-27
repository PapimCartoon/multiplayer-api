package come2play_as3.pseudoCode.mineSweeper
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class GameBrick extends SerializableClass
	{
  		public var isMine:Boolean, touchingMines:int,row:int,col:int;
    	public static function create(isMine:Boolean, touchingMines:int,row:int,col:int):GameBrick
  		{
  	  		var res:GameBrick = new GameBrick();
  			res.isMine = isMine;
  			res.row = row;
  			res.col = col;
  			res.touchingMines = touchingMines;
  			return res;
  		}		
	}
}
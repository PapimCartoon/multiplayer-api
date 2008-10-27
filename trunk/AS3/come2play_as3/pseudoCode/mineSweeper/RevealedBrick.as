package come2play_as3.pseudoCode.mineSweeper
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class RevealedBrick extends SerializableClass
	{
		public var brick:GameBrick,playerId:int;
	 	public static function create(brick:GameBrick,playerId:int):RevealedBrick
  		{
  	  		var res:RevealedBrick = new RevealedBrick();
  			res.brick = brick;
  			res.playerId = playerId;
  			return res;
  		}
		
	}
}
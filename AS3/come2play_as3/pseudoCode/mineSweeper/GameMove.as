package come2play_as3.pseudoCode.mineSweeper
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class GameMove extends SerializableClass
	{
		public var row:int, column:int,playerId:int,className:String;
		  
		public static function create(row:int, column:int,playerId:int,className:String):GameMove
		{
		  	var res:GameMove = new GameMove();
		  	res.row = row;
		  	res.column = column;
		  	res.playerId = playerId;
		  	res.className = className;
		  	return res;
		 }
		  
		 public function getKey():Object
		 {
		  	return {playerId:playerId,row:row,column:column};
		 }
		 public function getRevealKey():Object
		 {
		 	return {row:row,column:column};
		 }
		
	}
}
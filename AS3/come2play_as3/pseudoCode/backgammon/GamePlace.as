package come2play_as3.pseudoCode.backgammon
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class GamePlace extends SerializableClass
	{
		public var position:int,ownerPlayerId:int,gamePieces:int;
		public function GamePlace(){super("GamePlace");}
	  	public static function create(position:int,ownerPlayerId:int,gamePieces:int):GamePlace
	 	{
	  		var res:GamePlace = new GamePlace;
	  		res.position =position;
	  		res.ownerPlayerId = ownerPlayerId;
	  		res.gamePieces = gamePieces;
	  		return res;
	  	}
	}
}
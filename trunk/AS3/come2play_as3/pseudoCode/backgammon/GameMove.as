package come2play_as3.pseudoCode.backgammon
{
	public class GameMove
	{
		public var pieceCurrentLocation:int, pieceNewLocation:int;
	
	  	public static function create(pieceCurrentLocation:int, pieceNewLocation:int):GameMove
	 	{
	  		var res:GameMove = new GameMove;
	  		res.pieceCurrentLocation =pieceCurrentLocation;
	  		res.pieceNewLocation = pieceNewLocation;
	  		return res;
	  	}
	}
}
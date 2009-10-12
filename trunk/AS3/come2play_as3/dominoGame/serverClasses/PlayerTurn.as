package come2play_as3.dominoGame.serverClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class PlayerTurn extends SerializableClass
	{
		static public const PLAYER_TURN:String = "PlayerTurn"
		static public const PLAYER_TURN_REQUEST:String = "PlayerTurnRequest"
		public var playerTurn:int
		static public function create(playerTurn:int):PlayerTurn{
			var res:PlayerTurn = new PlayerTurn();
			res.playerTurn = playerTurn;
			return res;
		}
		
	}
}
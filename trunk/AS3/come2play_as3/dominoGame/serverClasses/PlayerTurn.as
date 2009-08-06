package come2play_as3.dominoGame.serverClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class PlayerTurn extends SerializableClass
	{
		public var playerTurn:int
		static public function create(playerTurn:int):PlayerTurn{
			var res:PlayerTurn = new PlayerTurn();
			res.playerTurn = playerTurn;
			return res;
		}
		
	}
}
package come2play_as3.domino
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	public class PlayerTurn extends SerializableClass
	{
		public var playerId:int;
		static public function create(playerId:int):PlayerTurn
		{
			var res:PlayerTurn = new PlayerTurn;
			res.playerId = playerId;
			return res;
		}
	}
}
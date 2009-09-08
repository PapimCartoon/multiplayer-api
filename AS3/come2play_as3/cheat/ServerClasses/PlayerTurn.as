package come2play_as3.cheat.ServerClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class PlayerTurn extends SerializableClass
	{
		public var playerId:int
		public var turnNum:int
		static public function create(playerId:int,turnNum:int):PlayerTurn{
			var res:PlayerTurn = new PlayerTurn()
			res.playerId = playerId;
			res.turnNum = turnNum;
			return res;
		}
		
	}
}
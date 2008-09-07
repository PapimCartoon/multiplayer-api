package come2play_as3.domino
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	public class PlayerTurn extends SerializableClass
	{
		public var turn:int;
		static public function create(turn:int):PlayerTurn
		{
			var res:PlayerTurn = new PlayerTurn;
			res.turn = turn;
			return res;
		}
	}
}
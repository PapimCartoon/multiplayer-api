package come2play_as3.cheat.connectionClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class PlayerCall extends SerializableClass
	{
		public var callNum:int;
		public var playerId:int;
		static public function create(playerId:int,callNum:int):PlayerCall
		{
			var res:PlayerCall = new PlayerCall();
			res.playerId = playerId;
			res.callNum =callNum;
			return res;
		}
	}
}
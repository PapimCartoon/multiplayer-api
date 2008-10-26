package come2play_as3.cheat.connectionClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class CheatTypeClass extends SerializableClass
	{
		static public const CALLCHEATER:String="callCheater"
		public var type:String;
		public var playerId:int;
		public function CheatTypeClass()
		{
			super("CheatTypeClass");
		}
		static public function create(playerId:int,type:String):CheatTypeClass
		{
			var res:CheatTypeClass = new CheatTypeClass();
			res.type = type;
			res.playerId = playerId;
			return res;
		}
	
		
	}
}
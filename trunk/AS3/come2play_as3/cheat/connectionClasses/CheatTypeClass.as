package come2play_as3.cheat.connectionClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class CheatTypeClass extends SerializableClass
	{
		static public const CALLCHEATER:String="callCheater";
		static public const NEXTTURN:String = "NextTurn";
		public var cardType:String;
		public var playerId:int;
		static public function create(playerId:int,cardType:String):CheatTypeClass
		{
			var res:CheatTypeClass = new CheatTypeClass();
			res.cardType = cardType;
			res.playerId = playerId;
			return res;
		}
	
		
	}
}
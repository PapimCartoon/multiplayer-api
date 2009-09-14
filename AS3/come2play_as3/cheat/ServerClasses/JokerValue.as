package come2play_as3.cheat.ServerClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;
	import come2play_as3.cards.CardKey;

	public class JokerValue extends SerializableClass
	{
		public var jokerValue:int
		public var cardKey:CardKey
		static public function create(jokerValue:int,cardKey:CardKey):JokerValue{
			var res:JokerValue = new JokerValue()
			res.jokerValue = jokerValue;
			res.cardKey = cardKey;
			return res;
		}
		
	}
}
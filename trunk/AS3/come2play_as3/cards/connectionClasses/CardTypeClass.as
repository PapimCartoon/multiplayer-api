package come2play_as3.cards.connectionClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class CardTypeClass extends SerializableClass
	{
		static public const CARD:String = "Card";
		static public const CENTERCARD:String = "CenterCard"
		public var type:String;
		public var value:int;
		static public function create(type:String,value:int):CardTypeClass
		{
			var res:CardTypeClass = new CardTypeClass();
			res.type = type;
			res.value = value;
			return res;
		}
		
	}
}
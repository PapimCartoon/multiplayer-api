package come2play_as3.cards
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class CardGameAction extends SerializableClass
	{
		static public const DRAW_CARD:String = "DrawCard";
		static public const PUT_CARD:String = "PutCard";
		public var action:String
		static public function create(action:String):CardGameAction{
			var res:CardGameAction = new CardGameAction();
			res.action = action;
			return res;
		}
		
	}
}
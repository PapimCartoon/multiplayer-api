package come2play_as3.cards
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class CardKey extends SerializableClass
	{
		public var num:int
		static public function create(num:int):CardKey{
			var res:CardKey = new CardKey();
			res.num = num;
			return res;
		}
		
	}
}
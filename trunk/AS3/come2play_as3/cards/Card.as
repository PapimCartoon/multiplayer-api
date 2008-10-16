package come2play_as3.cards
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	public class Card extends SerializableClass
	{
		public static const HEART:String = "Heart";
		public static const DAIMOND:String = "Daimond";
		public static const CLUB:String = "Club";
		public static const SPADE:String = "Spade";
		public static const JOKER:String = "Joker";
		public var value:int;
		public var sign:String;
		
		public function equelTo(card:Card):Boolean
		{
			return ((value == card.value) && (sign == card.sign))
		}
		public function toString():String{return "{$Card$ value : "+value+",sign : "+sign+"}"}
		public static function create(sign:String,value:int):Card
		{
			var res:Card = new Card();
			res.sign = sign;
			res.value = value;
			return res;
		}
		public static function createByNumber(sign:int,value:int):Card
		{
			var res:Card = new Card();
			switch(sign)
			{
				case 1: res.sign = Card.HEART; break;
				case 2: res.sign = Card.DAIMOND; break;
				case 3: res.sign = Card.CLUB; break;
				case 4: res.sign = Card.HEART; break;
				case 5: res.sign = Card.JOKER; break;
			}
			res.value = value;
			return res;
		}

	}
}
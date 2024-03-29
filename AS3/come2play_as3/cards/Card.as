package come2play_as3.cards
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	public class Card extends SerializableClass
	{
		public static const HEART:String = "Heart";
		public static const DAIMOND:String = "Daimond";
		public static const CLUB:String = "Club";
		public static const SPADE:String = "Spade";
		public static const BLACKJOKER:String = "BlackJoker";
		public static const REDJOKER:String = "RedJoker";
		public var value:int;
		public var sign:String;
		
		public function equelTo(card:Card):Boolean
		{
			return ((value == card.value) && (sign == card.sign))
		}
		public function isBlack():Boolean
		{
			if(sign == HEART)
				return false;
			if(sign == DAIMOND)
				return false;
			if(sign == CLUB)
				return true;
			if(sign == SPADE)
				return true;
			if(sign == BLACKJOKER)
				return true;
			if(sign == REDJOKER)
				return false;
			return false;
		}
		public function intSign():int
		{
			switch(sign)
			{
				case Card.HEART : return 1; break;
				case Card.DAIMOND : return 2; break;
				case Card.CLUB : return 3; break;
				case Card.SPADE : return 4 ; break;
			}
			return 0;
		}
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
				case 4: res.sign = Card.SPADE; break;
				case 5: res.sign = Card.REDJOKER; break;
				case 6: res.sign = Card.BLACKJOKER; break;
			}
			res.value = value;
			return res;
		}

	}
}
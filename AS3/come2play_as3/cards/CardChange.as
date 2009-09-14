package come2play_as3.cards
{
	import come2play_as3.api.auto_copied.JSON;
	import come2play_as3.cards.Card;
	import come2play_as3.cards.CardKey;
	
	public class CardChange
	{
		static public const DRAWN_CARD:String = "drawnCard";
		static public const FLIPPED_CARD:String = "flippedCard";
		static public const USER_CARD:String = "handCard";
		public var card:Card;
		public var cardKey:CardKey;
		public var action:String;
		public var userId:int
		public function CardChange(card:Card,cardKey:CardKey,action:String,userId:int = -1)
		{
			this.card = card;
			this.cardKey = cardKey;
			this.action = action;
			this.userId = userId;
		}
		public function toString():String{
			return action+" : "+(card==null?"null":card.toString())
		}

	}
}
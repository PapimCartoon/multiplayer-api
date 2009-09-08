package come2play_as3.cheat.events
{
	import come2play_as3.cards.Card;
	import come2play_as3.cards.CardKey;
	
	import flash.events.Event;

	public class CardClickedEvent extends Event
	{
		static public const CARD_CLICKED:String = "CardClicked"
		public var cardKey:CardKey;
		public function CardClickedEvent(cardKey:CardKey)
		{
			super(CARD_CLICKED);
			this.cardKey = cardKey;
		}
		
	}
}
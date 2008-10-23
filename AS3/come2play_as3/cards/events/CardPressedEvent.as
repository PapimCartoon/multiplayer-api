package come2play_as3.cards.events
{
	import come2play_as3.cards.PlayerCard;
	
	import flash.events.Event;

	public class CardPressedEvent extends Event
	{
		static public var CardPressedEvent:String = "CardPressed";
		public var playerCard:PlayerCard;
		public var isPressed:Boolean;
		public function CardPressedEvent(playerCard:PlayerCard,isPressed:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.playerCard = playerCard;
			this.isPressed = isPressed;
			super(CardPressedEvent, bubbles, cancelable);
		}
		
	}
}
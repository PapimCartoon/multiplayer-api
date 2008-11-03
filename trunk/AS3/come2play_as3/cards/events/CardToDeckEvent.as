package come2play_as3.cards.events
{
	import come2play_as3.cards.graphic.CardGraphicMovieClip;
	
	import flash.events.Event;

	public class CardToDeckEvent extends Event
	{
		static public const CardToDeckEvent:String = "CardToDeckEvent";
		public var card:CardGraphicMovieClip;
		public function CardToDeckEvent(card:CardGraphicMovieClip, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.card = card;
			super(CardToDeckEvent, bubbles, cancelable);
		}
		
	}
}
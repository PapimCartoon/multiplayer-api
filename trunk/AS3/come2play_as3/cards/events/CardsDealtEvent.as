package come2play_as3.cards.events
{
	import flash.events.Event;

	public class CardsDealtEvent extends Event
	{
		static public var CardsDealtEvent:String = "CardsDealtEvent";
		public function CardsDealtEvent(bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(CardsDealtEvent, bubbles, cancelable);
		}
		
	}
}
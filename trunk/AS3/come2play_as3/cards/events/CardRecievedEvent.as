package come2play_as3.cards.events
{
	import flash.events.Event;

	public class CardRecievedEvent extends Event
	{
		static public const CardRecieved:String ="CardRecieved"
		public function CardRecievedEvent(bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(CardRecieved, bubbles, cancelable);
		}
		
	}
}
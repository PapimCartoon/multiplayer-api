package come2play_as3.cards.events
{
	import flash.events.Event;

	public class CardShownEvent extends Event
	{
		static public const CardShown:String = "CardShown";
		public function CardShownEvent(bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(CardShown, bubbles, cancelable);
		}
		
	}
}
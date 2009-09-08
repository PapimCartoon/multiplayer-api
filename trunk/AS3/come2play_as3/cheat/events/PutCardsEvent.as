package come2play_as3.cheat.events
{
	import flash.events.Event;

	public class PutCardsEvent extends Event
	{
		static public const PUT_CARD:String = "PutCard"
		public var cards:Array
		public function PutCardsEvent(cards:Array)
		{
			super(PUT_CARD);
			this.cards = cards;
		}
		
	}
}
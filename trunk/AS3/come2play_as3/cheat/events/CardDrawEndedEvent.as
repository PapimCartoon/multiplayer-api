package come2play_as3.cheat.events
{
	import flash.events.Event;

	public class CardDrawEndedEvent extends Event
	{
		static public const CARD_DRAW_ENDED:String = "CardDrawEvent"
		public var callFinishFunc:Boolean
		public function CardDrawEndedEvent(callFinishFunc:Boolean)
		{
			super(CARD_DRAW_ENDED);
			this.callFinishFunc = callFinishFunc;
		}
		
	}
}
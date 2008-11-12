package ticktactoeTuturial
{
	import flash.events.Event;

	public class SetNextTurnEvent extends Event
	{
		static public const SetNextTurnEvent:String = "SetNextTurnEvent"
		public var nextPlayerId:int;
		public function SetNextTurnEvent(nextPlayerId:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.nextPlayerId = nextPlayerId;
			super(SetNextTurnEvent, bubbles, cancelable);
		}
		
	}
}
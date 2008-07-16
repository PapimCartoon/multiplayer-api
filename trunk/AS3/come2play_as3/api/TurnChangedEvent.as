package come2play_as3.api
{
	import flash.events.Event;
	
	public final class TurnChangedEvent extends Event
	{
		public static const TURN_CHANGED_EVENT:String = "TURN_CHANGED_EVENT";
		public var turn_of_player_id:int;
		public function TurnChangedEvent(turn_of_player_id:int)
		{
			super(TURN_CHANGED_EVENT);
			this.turn_of_player_id = turn_of_player_id;
		}
		override public function toString():String {
			return "TurnChangedEvent: turn_of_player_id="+turn_of_player_id;
		}	
	}
}
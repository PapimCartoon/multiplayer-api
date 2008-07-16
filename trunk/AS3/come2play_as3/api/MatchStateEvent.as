package come2play_as3.api 
{
	import come2play_as3.api.Entry;
	
	import flash.events.Event;

	public final class MatchStateEvent extends Event
	{
		public static const MATCH_STATE_EVENT:String = "MATCH_STATE_EVENT";
		public var entry:Entry;
		public function MatchStateEvent(entry:Entry)
		{
			super(MATCH_STATE_EVENT);
			this.entry = entry;
		}
		override public function toString():String {
			return "[MatchStateEvent: entry="+entry.toString()+"]";
		}		
	}
}
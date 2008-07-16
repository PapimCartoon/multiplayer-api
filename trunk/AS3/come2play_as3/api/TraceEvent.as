package come2play_as3.api
{
	import flash.events.Event;

	public final class TraceEvent extends Event
	{
		public static const TRACE_EVENT:String = "TRACE_EVENT";
		public var args:Array;
		public var key:String;
		public function TraceEvent(key:String, args:Array)
		{
			super(TRACE_EVENT);
			this.args = args;
			this.key = key;
		}	
		
		override public function toString():String {
			return "TraceEvent: key="+key+" args="+args;
		}	
	}
}
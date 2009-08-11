package come2play_as3.dominoGame.events
{
	import flash.events.Event;

	public class DrawEvent extends Event
	{
		public static const DRAW_EVENT:String = "DrawEvent"
		public var isFinish:Boolean
		public function DrawEvent(isFinish:Boolean)
		{
			super(DRAW_EVENT);
			this.isFinish = isFinish;
		}
		
	}
}
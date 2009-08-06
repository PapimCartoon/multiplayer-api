package come2play_as3.dominoGame.events
{
	import come2play_as3.dominoGame.graphicClasses.DominoBrickGraphic;
	
	import flash.events.Event;

	public class GrabEvent extends Event
	{
		static public const PUT_BRICK:String = "putBrick";
		static public const GRAB_BRICK:String = "grabBrick";
		static public const LEAVE_BRICK:String = "leaveBrick";
		public var brick:DominoBrickGraphic
		public function GrabEvent(type:String,brick:DominoBrickGraphic)
		{
			super(type)
			this.brick = brick;
		}
		
	}
}
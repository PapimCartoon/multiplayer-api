package come2play_as3.dominoGame.events
{
	import flash.events.Event;

	public class AnimationEvent extends Event
	{
		static public const ANIMATION_EVENT:String = "AnimationEvent"
		public var start:Boolean;
		public var animationName:String;
		public function AnimationEvent(start:Boolean, animationName:String)
		{
			super(ANIMATION_EVENT, bubbles, cancelable);
			this.start = start;
			this.animationName = animationName
		}
		
	}
}
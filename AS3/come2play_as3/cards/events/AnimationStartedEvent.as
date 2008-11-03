package come2play_as3.cards.events
{
	import flash.events.Event;

	public class AnimationStartedEvent extends Event
	{
		static public const AnimationStartedEvent:String = "AnimationStartedEvent";
		public function AnimationStartedEvent( bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(AnimationStartedEvent, bubbles, cancelable);
		}
		
	}
}
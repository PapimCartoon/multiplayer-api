package come2play_as3.cards.events
{
	import flash.events.Event;

	public class AnimationEndedEvent extends Event
	{
		static public const AnimationEndedEvent:String = "AnimationEndedEvent";
		public function AnimationEndedEvent( bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(AnimationEndedEvent, bubbles, cancelable);
		}
		
	}
}
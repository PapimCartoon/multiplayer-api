package come2play_as3.ticktactoeTuturial
{
	import flash.events.Event;

	public class GameOverEvent extends Event
	{
		static public const GameOverEvent:String = "GameOverEvent"
		public var winingPlayer:int;
		public function GameOverEvent( winingPlayer:int,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.winingPlayer = winingPlayer
			super(GameOverEvent, bubbles, cancelable);
		}
		
	}
}
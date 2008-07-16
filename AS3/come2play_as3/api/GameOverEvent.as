package come2play_as3.api
{
	import flash.events.Event;

	public final class GameOverEvent extends Event
	{
		public static const GAME_OVER_EVENT:String = "GAME_OVER_EVENT";
		public var finished_players:Array/*PlayerMatchOver*/;
		public function GameOverEvent(finished_players:Array/*PlayerMatchOver*/)
		{
			super(GAME_OVER_EVENT);
			this.finished_players = finished_players;
		}
		override public function toString():String {
			return "GameOverEvent: finished_players="+finished_players.join(" ,");
		}		
	}
}
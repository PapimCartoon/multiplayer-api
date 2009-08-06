package come2play_as3.dominoGame.events
{
	import flash.events.Event;

	public class WinnerEvent extends Event
	{
		static public const DECALRE_WINNER:String = "decalreWinner"
		public var playerId:int;
		public function WinnerEvent(playerId:int)
		{
			super(DECALRE_WINNER);
			this.playerId = playerId;
		}
		
	}
}
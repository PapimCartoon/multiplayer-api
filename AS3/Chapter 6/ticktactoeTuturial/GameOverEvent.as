﻿package ticktactoeTuturial
{
	import flash.events.Event;

	public class GameOverEvent extends Event
	{
		static public const GameOverEvent:String = "GameOverEvent"
		public var winingPlayer:int; // id of wininig player
		public function GameOverEvent( winingPlayer:int,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.winingPlayer = winingPlayer
			super(GameOverEvent, bubbles, cancelable);
		}
		
	}
}
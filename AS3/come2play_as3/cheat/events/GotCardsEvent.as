package come2play_as3.cheat.events
{
	import flash.events.Event;
	
	
	public class GotCardsEvent extends Event
	{
		static public const CARDS_CHANGED:String = "cardsChanged"
		public var cardsChanged:Array/*CardKey*/
		public function GotCardsEvent(cardsChanged:Array)
		{		
			super(CARDS_CHANGED)
			this.cardsChanged = cardsChanged;
		}

	}
}
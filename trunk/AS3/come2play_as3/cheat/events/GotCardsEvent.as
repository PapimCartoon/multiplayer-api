package come2play_as3.cards.events
{
	import flash.events.Event;
	
	
	public class GotCardsEvent extends Event
	{
		static public const CARDS_CHANGED:String = "cardsChanged"
		private var cardsChanged:Array/*CardKey*/
		public function GotCardsEvent(cardsChanged:Array)
		{		
			super(CARDS_CHANGED)
			this.cardsChanged = cardsChanged;
		}

	}
}
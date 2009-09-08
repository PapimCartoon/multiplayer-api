package come2play_as3.cards
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	import flash.events.Event;
	
	
	public class GotCardsEvent extends Event
	{
		static public const CARDS_CHANGED:String = "cardsChanged"
		public var cardsChanged:Array/*CardKey*/
		public function GotCardsEvent(cardsChanged:Array,addedAction:SerializableClass)
		{		
			super(CARDS_CHANGED)
			this.cardsChanged = cardsChanged;
		}

	}
}
package come2play_as3.cards.graphic
{
	import flash.display.MovieClip;

	public class RivalHand extends Hand
	{
		private var rivalNum:int;
		private var cardsToDeal:int ;
		private var cardsInHand:Array/*CardGraphicMovieClip*/;
		
		public function RivalHand(rivalNum:int)
		{
			this.rivalNum = rivalNum;
			cardsToDeal = 0;
		}
		public function addCards(cardsToAdd:int):void
		{
			cardsToDeal += cardsToAdd;
		}
		override public function dealCard():void
		{
			
		}
		
	}
}
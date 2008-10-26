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
			cardsInHand = new Array();
			cardsToDeal = 0;
		}
		public function removeCard():void
		{
			cardsToDeal--;
			var cardGraphicMovieClip:CardGraphicMovieClip = cardsInHand.pop();
			removeChild(cardGraphicMovieClip);
		}
		public function addCards(cardsToAdd:int):void
		{
			cardsToDeal += cardsToAdd;
		}
		override public function dealCard():void
		{
			if(cardsToDeal <= cardsInHand.length)
				return;
			var tempCard:CardGraphicMovieClip = new CardGraphicMovieClip();
			addChild(tempCard)
			cardsInHand.push(tempCard);
			tempCard.moveCard(rivalNum,cardsInHand.length);
		}
		
	}
}
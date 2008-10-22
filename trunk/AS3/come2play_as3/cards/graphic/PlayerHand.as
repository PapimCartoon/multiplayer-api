package come2play_as3.cards.graphic
{
	import flash.display.MovieClip;

	public class PlayerHand extends Hand
	{
		private var cardsInStock:Array/*Card*/;
		private var cardsInHand:Array/*CardGraphicMovieClip*/;
		public function PlayerHand()
		{
			cardsInStock = new Array();
			cardsInHand = new Array();
		}
		public function addCards(cards:Array/*Card*/):void
		{
			cardsInStock = cardsInStock.concat(cards);
		}
		override public function dealCard():void
		{
			if(cardsInStock.length == 0)
				return;
			var tempCardGraphics:CardGraphicMovieClip = new CardGraphicMovieClip(/*cardsInStock.pop()*/);
			addChild(tempCardGraphics)
			cardsInHand.push(tempCardGraphics);
			tempCardGraphics.moveCard(0,cardsInHand.length);
		}
	}
}
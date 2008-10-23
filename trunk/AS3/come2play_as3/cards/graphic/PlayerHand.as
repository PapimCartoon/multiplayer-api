package come2play_as3.cards.graphic
{
	import come2play_as3.cards.CardDefenitins;

	public class PlayerHand extends Hand
	{
		private var cardsInStock:Array/*PlayerCard*/;
		private var cardsInHand:Array/*CardGraphicMovieClip*/;
		private var lastCard:CardGraphicMovieClip;
		private var randomId:Number = Math.floor(Math.random()*300);
		public function PlayerHand()
		{
			cardsInStock = new Array();
			cardsInHand = new Array();
		}
		public function addCards(playerCards:Array/*PlayerCard*/):void
		{
			cardsInStock = cardsInStock.concat(playerCards);
		}
		public function respaceCards():void
		{
			var cardGraphics:CardGraphicMovieClip;
			var i:int;
			var maxNeedeSpace:int = cardsInHand.length * CardDefenitins.cardWidth 
			var availableSpace:int = CardDefenitins.playerXPositions[0] - 20;
			
			if(availableSpace > maxNeedeSpace)
			{
				for(i = 0;i<cardsInHand.length;i++)
				{
					cardGraphics = cardsInHand[i];
					cardGraphics.x = CardDefenitins.playerXPositions[0] - i * CardDefenitins.cardWidth 
				}
				CardDefenitins.playerCardSpacing = CardDefenitins.cardWidth ;
			}
			else
			{
				var  spacingMod:int =CardDefenitins.cardWidth -( (maxNeedeSpace -availableSpace )/cardsInHand.length+1);
				for(i = 0;i<cardsInHand.length;i++)
				{
					cardGraphics = cardsInHand[i];
					cardGraphics.x = CardDefenitins.playerXPositions[0] - i * spacingMod 
				}
				CardDefenitins.playerCardSpacing = spacingMod ;
			}
		}
		public function showCard():void
		{
			lastCard.setCard(cardsInStock.pop());
			respaceCards();
		}
		override public function dealCard():void
		{
			if(cardsInStock.length == 0)
				return;
			lastCard = new CardGraphicMovieClip();
			addChildAt(lastCard,0)
			cardsInHand.push(lastCard);
			lastCard.moveCard(0,cardsInHand.length);
			
		}
	}
}
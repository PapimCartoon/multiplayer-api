package come2play_as3.cards.graphic
{
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.caurina.transitions.Tweener;
	import come2play_as3.cards.events.AnimationEndedEvent;
	import come2play_as3.cards.events.AnimationStartedEvent;
	
	import flash.display.Sprite;

	public class CardDeck extends Sprite
	{
		//private var cardsInDeck:int;
		private var cardsInDeck:Array;
		private var cardsToRemove:int;
		public function CardDeck()
		{
			cardsInDeck = new Array();
			CardDefenitins.currentDeckRotation = 0;
			cardsToRemove = 0;
			//cardsInDeck = 0;
		}
		public function addCard(card:CardGraphicMovieClip):void
		{
			addChild(card);
			cardsInDeck.push(card);
		}
		private function removeCard():void
		{
			if(cardsToRemove > 0)
			{
				CardDefenitins.currentDeckRotation -=10;
				var card:CardGraphicMovieClip = cardsInDeck.shift();
				Tweener.addTween(card, {x:-100, y:-100, rotation:0, time:CardDefenitins.cardSpeed, transition:"linear",onComplete:removeCardFromDeck,onCompleteParams:[card]});
				dispatchEvent(new AnimationStartedEvent);
			}
		}
		private function removeCardFromDeck(card:CardGraphicMovieClip):void
		{
			removeChild(card);
			cardsToRemove --;
			removeCard();
			dispatchEvent(new AnimationEndedEvent);
		}
		public function removeCards(moreCardsToRemove:int):void
		{
			cardsToRemove +=moreCardsToRemove;
			if(cardsToRemove > cardsInDeck.length) cardsToRemove = cardsInDeck.length;
			removeCard();
		}
		
	}
}
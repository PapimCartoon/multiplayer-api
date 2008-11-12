package come2play_as3.cards.graphic
{
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.caurina.transitions.Tweener;
	import come2play_as3.cards.events.AnimationEndedEvent;
	import come2play_as3.cards.events.AnimationStartedEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class CardDeck extends Sprite
	{
		//private var cardsInDeck:int;
		private var cardStackSize:TextField;
		private var cardsStack:MovieClip;
		private var cardsInDeck:Array;
		private var cardsToRemove:int;
		public function CardDeck()
		{
			cardsInDeck = new Array();
			cardStackSize = new TextField()
			cardStackSize.selectable = false;
			cardStackSize.x = CardDefenitins.CONTAINER_gameWidth / 2 - 10;
			cardStackSize.y = CardDefenitins.CONTAINER_gameHeight / 2 - 10;
			cardsStack = new MovieClip();
			addChild(cardsStack);
			addChild(cardStackSize)
			CardDefenitins.currentDeckRotation = 0;
			cardsToRemove = 0;
		}
		private function setText(text:String):void
		{
			cardStackSize.text = text;
			cardStackSize.setTextFormat(new TextFormat(null,27,0x4097D0));
		}
		public function addNumberOfCards(cardsAmount:int):void
		{
			for(var i:int=0;i<cardsAmount;i++)
			{
				var card:CardGraphicMovieClip = new CardGraphicMovieClip()
				card.x = CardDefenitins.CONTAINER_gameWidth/2 + Math.random() * 5;
				card.y = CardDefenitins.CONTAINER_gameHeight/2 + Math.random() * 5;
				card.rotation = CardDefenitins.currentDeckRotation + Math.random()*5;
				CardDefenitins.currentDeckRotation +=10;
				cardsStack.addChild(card);
				cardsInDeck.push(card);
				setText(String(cardsInDeck.length));
			}
		}
		public function addCard(card:CardGraphicMovieClip):void
		{
			cardsStack.addChild(card);
			cardsInDeck.push(card);
			setText(String(cardsInDeck.length));
		}
		private function removeCard():void
		{
			if(cardsToRemove > 0)
			{
				CardDefenitins.currentDeckRotation -=10;
				var card:CardGraphicMovieClip = cardsInDeck.shift();
				Tweener.addTween(card, {x:-100, y:-100, rotation:0, time:CardDefenitins.cardSpeed, transition:"linear",onComplete:removeCardFromDeck,onCompleteParams:[card]});
				dispatchEvent(new AnimationStartedEvent);
				if(cardsInDeck.length != 0)
					setText(String(cardsInDeck.length));
				else
					setText("");
			}
		}
		private function removeCardFromDeck(card:CardGraphicMovieClip):void
		{
			cardsStack.removeChild(card);
			cardsToRemove --;
			removeCard();
			dispatchEvent(new AnimationEndedEvent);
		}
		public function removeCards(moreCardsToRemove:int):void
		{
			cardsToRemove +=moreCardsToRemove;
			trace("cardsToRemove : "+cardsToRemove)
			if(cardsToRemove > cardsInDeck.length) cardsToRemove = cardsInDeck.length;
			removeCard();
		}
		
	}
}
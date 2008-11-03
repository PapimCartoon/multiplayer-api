package come2play_as3.cards.graphic
{
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.caurina.transitions.Tweener;
	import come2play_as3.cards.events.CardToDeckEvent;

	public class RivalHand extends Hand
	{
		public var rivalNum:int;
		private var cardsToDeal:int ;
		private var waitingRemove:int;
		private var removing:Boolean;
		private var cardsInHand:Array/*CardGraphicMovieClip*/;
		public function RivalHand(rivalNum:int)
		{
			this.rivalNum = rivalNum;
			cardsInHand = new Array();
			cardsToDeal = 0;
			waitingRemove = 0;
		}
		override public function isNoCardsLeft():Boolean
		{
			return cardsToDeal <=cardsInHand.length;
		}
		public function removeCard():void
		{
			if((cardsInHand.length == 0) || removing)
				waitingRemove++;
			else
			{
				removing = true
				cardsToDeal--;
				var cardGraphicMovieClip:CardGraphicMovieClip = cardsInHand.pop();
				Tweener.addTween(cardGraphicMovieClip, {x:(CardDefenitins.CONTAINER_gameWidth/2) + Math.random() * 5, y:(CardDefenitins.CONTAINER_gameHeight/2) + Math.random() * 5, rotation:(CardDefenitins.currentDeckRotation + Math.random()*5), time:CardDefenitins.cardSpeed, transition:"linear",onComplete:removeCardFromHand,onCompleteParams:[cardGraphicMovieClip]});	
				CardDefenitins.currentDeckRotation+=10;
				//removeChild(cardGraphicMovieClip);
			}
		}
		private function removeCardFromHand(card:CardGraphicMovieClip):void
		{
			removeChild(card);
			removing = false;
			if(waitingRemove > 0)
			{
				waitingRemove--;
				removeCard();
			}
			dispatchEvent(new CardToDeckEvent(card));
		}
		public function addCards(cardsToAdd:int):void
		{
			if(waitingRemove > 0)
				waitingRemove--
			else
				cardsToDeal += cardsToAdd;
		}
		override public function dealCard():Boolean
		{
			if(cardsToDeal <= cardsInHand.length)
				return false;
			respaceCards();
			var tempCard:CardGraphicMovieClip = new CardGraphicMovieClip();
			addChild(tempCard)
			cardsInHand.push(tempCard);
			tempCard.moveCard(rivalNum,cardsInHand.length);
			return true;
		}
		private function respaceCards():void
		{	
			var tempCard:CardGraphicMovieClip
			var i:int;
			var mod:int = 0;
			if(rivalNum== (CardDefenitins.playerNumber >2?1:2) )
			{
				if((cardsInHand.length * CardDefenitins.rivalCardSpacing + CardDefenitins.cardHeight * 2) > (CardDefenitins.CONTAINER_gameHeight - mod ))
				{
					 CardDefenitins.rivalCardSpacing = ((CardDefenitins.CONTAINER_gameHeight - CardDefenitins.cardHeight * 2 - mod ) / cardsInHand.length)
					for(i =0;i<cardsInHand.length;i++)
					{
						tempCard = cardsInHand[i];
						tempCard.y  = CardDefenitins.playerYPositions[1] + (i+1)* CardDefenitins.rivalCardSpacing;
					}
				}
			}
			else if(rivalNum== (CardDefenitins.playerNumber >2?2:1) )
			{
				if((cardsInHand.length * CardDefenitins.rivalCardSpacing + CardDefenitins.cardHeight * 2) > (CardDefenitins.CONTAINER_gameWidth - mod))
				{
					 CardDefenitins.rivalCardSpacing = ((CardDefenitins.CONTAINER_gameWidth - CardDefenitins.cardHeight * 2 - mod ) / cardsInHand.length )
					 for(i =0;i<cardsInHand.length;i++)
					{
						tempCard = cardsInHand[i];
						tempCard.x  = CardDefenitins.playerXPositions[2] + (i+1)* CardDefenitins.rivalCardSpacing;
					}
				}
			}
			else if(rivalNum==3)
			{
				if((cardsInHand.length * CardDefenitins.rivalCardSpacing + CardDefenitins.cardHeight * 2) > (CardDefenitins.CONTAINER_gameHeight - mod))
				{
					 CardDefenitins.rivalCardSpacing = ((CardDefenitins.CONTAINER_gameHeight - CardDefenitins.cardHeight * 2 - mod ) / cardsInHand.length )
					for(i =0;i<cardsInHand.length;i++)
					{
						tempCard = cardsInHand[i];
						tempCard.y  = CardDefenitins.playerYPositions[3] - (i+1)* CardDefenitins.rivalCardSpacing;
					}
				}
			}		
		}
		
	}
}
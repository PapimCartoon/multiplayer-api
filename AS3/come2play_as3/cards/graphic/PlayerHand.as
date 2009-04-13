package come2play_as3.cards.graphic
{
	import come2play_as3.api.auto_copied.AS3_Timer;
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.PlayerCard;
	import come2play_as3.cards.caurina.transitions.Tweener;
	import come2play_as3.cards.events.CardPressedEvent;
	import come2play_as3.cards.events.CardToDeckEvent;
	import come2play_as3.cards.events.CardsDealtEvent;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class PlayerHand extends Hand
	{
		private var cardsInStock:Array/*PlayerCard*/;
		private var cardsInHand:Array/*CardGraphicMovieClip*/;
		private var cardsToRemove:Array;
		private var removingCard:Boolean
		private var lastCard:CardGraphicMovieClip;
		private var middle:int;
		
		//bounce related
		private var bouncingCards:Array;
		private var bounceCards:Timer;
		private var bouncePosition:int;
		private var isBounceUp:Boolean;
		
		//card arranging related
		private var cardDictonery:CardDictonery;
		private var arrangeCardsTimer:Timer;
		private var cardsBack:Timer;
		private var cardArranged:CardGraphicMovieClip;
		private var cardsBackStarted:Boolean;
		private var wasMoved:Boolean;
		
		
		
		public function PlayerHand()
		{
			isBounceUp = true;
			cardsBack = new AS3_Timer("cardsBack",1000,0);
			bounceCards = new AS3_Timer("bounceCards",100,0);
			arrangeCardsTimer = new AS3_Timer("arrangeCardsTimer",120,0);
			bounceCards.start();
			cardsInStock = new Array();
			cardsInHand = new Array();
			bouncingCards = new Array();
			cardsToRemove = new Array();
			bouncePosition = CardDefenitins.playerYPositions[0] - 20;
			
			AS3_vs_AS2.myWeakAddEventListener("bounceCards",bounceCards,TimerEvent.TIMER,doBounce)
			AS3_vs_AS2.myAddEventListener("arrangeCardsTimer",arrangeCardsTimer,TimerEvent.TIMER,moveCard)
			AS3_vs_AS2.myAddEventListener("cardsBack",cardsBack,TimerEvent.TIMER,cardsBackToPlace)		
			AS3_vs_AS2.myAddEventListener("PlayerHand",this,MouseEvent.MOUSE_MOVE,repositionCards)
			AS3_vs_AS2.myAddEventListener("PlayerHand",this,CardPressedEvent.CardPressedEvent,bounceCard,true)
			cardsBack.start();
		}
		
		private function moveCard(ev:TimerEvent):void
		{
			if(cardArranged == null)
			{
				cardArranged = cardDictonery.arangeNextCard();
				if(cardArranged == null)
					arrangeCardsTimer.stop();
				else
					cardArranged.y = CardDefenitins.playerYPositions[0] -CardDefenitins.cardHeight*0.25;

			}
			else if(wasMoved)
			{
				cardArranged.y = CardDefenitins.playerYPositions[0];
				wasMoved = false;
				cardArranged = null;
			}
			else
			{
				respaceCardsFor(middle);
				//cardArranged
				wasMoved = true;
			}
		}
		private function cardsBackToPlace(ev:TimerEvent):void
		{
			cardsBack.delay = 60;
			if(cardsBackStarted)
			{
				
				var changed:Boolean;
				for each(var card:CardGraphicMovieClip in cardsInHand)
				{
					if(card.selected) continue;
					if(card.y < CardDefenitins.playerYPositions[0])
					{
						changed = true;
						card.y +=3;
					}
					if(card.y > CardDefenitins.playerYPositions[0])
						card.y = CardDefenitins.playerYPositions[0];
				}
				if(!changed)
					cardsBack.stop();
			}
			else
			{
				cardsBackStarted = true;
			}
		}
		private function doBounce(ev:TimerEvent):void
		{
			if(isBounceUp)
			{
				bouncePosition -=2;
				if(bouncePosition < (CardDefenitins.playerYPositions[0] -(CardDefenitins.cardHeight/3 +5)))
				{
					isBounceUp = false
				}
			}
			else
			{
				bouncePosition +=2;
				if(bouncePosition > CardDefenitins.playerYPositions[0] -CardDefenitins.cardHeight/3 )
				{
					isBounceUp = true
				}
			}
			var cardGraphicMovieClip:CardGraphicMovieClip;
			for each(var i:int in bouncingCards)
			{
				cardGraphicMovieClip = cardsInHand[i];
				cardGraphicMovieClip.y = bouncePosition;
			}
			
		}
		public function arrangeCards(isByNum:Boolean):void
		{
			cardDictonery = new CardDictonery(cardsInHand,isByNum);
			arrangeCardsTimer.start();
		}
		public function clearBounce():void
		{
			bounceCards.stop();
			var cardGraphicMovieClip:CardGraphicMovieClip;
			for each(var i:int in bouncingCards)
			{
				cardGraphicMovieClip = cardsInHand[i];
				cardGraphicMovieClip.y = CardDefenitins.playerYPositions[0];
			}
			bouncingCards = new Array();
			bounceCards.start();
		}
		private function bounceCard(ev:CardPressedEvent):void
		{
			var cardGraphicMovieClip:CardGraphicMovieClip;
			for(var i:int = 0;i<cardsInHand.length;i++)
			{
				cardGraphicMovieClip = cardsInHand[i];
				if(cardGraphicMovieClip == null)
					continue;
				if(!cardGraphicMovieClip.isSet)
					continue;
					
				if(cardGraphicMovieClip.isEquel(ev.playerCard))
				{
					if(ev.isPressed)
						bouncingCards.push(i);
					else
					{
						bouncingCards.splice(bouncingCards.indexOf(i),1);
						cardGraphicMovieClip.y = CardDefenitins.playerYPositions[0] - 15;
					}
				}
			}
		}
		
		
		public function repositionCards(ev:MouseEvent):void
		{
			cardsBack.delay = 1000;
			cardsBackStarted = true;
			cardsBack.reset();
			cardsBack.start();
			var cardGraphic:CardGraphicMovieClip;
			var distanceMap:Array = new Array();
			var smallesDistance:int;
			middle = -1;
			for(var i:int = 0;i<cardsInHand.length ;i++)
			{
				cardGraphic = cardsInHand[i];
				var actualMiddle:int = (cardGraphic.x + cardGraphic.width/2);
				var distance:int = Math.abs(actualMiddle - (ev.stageX- CardDefenitins.CONTAINER_gameStageX));
				distanceMap[i] = distance;
				if ((middle == -1) || (distance < smallesDistance))
				{
					smallesDistance = distance;
					middle = i;
				}
			}
			
			var distanceCaclculation:Number = (distanceMap[middle - 1] - distanceMap[middle + 1])/CardDefenitins.cardWidth;
			for(i=0;i<cardsInHand.length;i++)
			{
				cardGraphic = cardsInHand[i];
					if(i == middle)
					{
							cardGraphic.yPos = CardDefenitins.playerYPositions[0] - 30;
					}
					else if(Math.abs(i - middle) == 1)
					{
								cardGraphic.yPos = CardDefenitins.playerYPositions[0] - (15 *(2.2-(distanceMap[i] /(CardDefenitins.cardWidth*0.66))));
					}
					else
					{
							cardGraphic.yPos = CardDefenitins.playerYPositions[0];
					}

			}
			respaceCardsFor(middle);
		}
		
		override public function isNoCardsLeft():Boolean
		{
			if(cardsInStock.length == 0)
			{
				dispatchEvent(new CardsDealtEvent);
				return true;
			}
			else 
				return false
		}
		public function addCards(playerCards:Array/*PlayerCard*/):void
		{
			for each(var cardGraphicMovieClip:CardGraphicMovieClip in cardsInHand )
			{
				for(var i:int = 0;i< playerCards.length;i++)
				{
					if(cardGraphicMovieClip.isEquel(playerCards[i]))
					{
						cardGraphicMovieClip.setCard(playerCards[i]);
						playerCards.splice(i,1);
						break;
					}
				}
			}
			cardsInStock = cardsInStock.concat(playerCards);
		}
		public function removeCard(cardKey:int):void
		{
			var cardGraphic:CardGraphicMovieClip = cardsInHand[0];
			var playerCard:PlayerCard;
			var i:int;
			if(!cardGraphic.isSet)
			{
				for(i= 0;i<cardsInStock.length;i++)
				{
					playerCard = cardsInStock[i];
					if(playerCard.cardKey == cardKey)
					{
						cardsInStock.splice(i,1);
						break;
					}
				}			
			}
			else if(removingCard)
			{
				cardsToRemove.push(cardKey);
			}
			else
			{
				for(i = 0;i<cardsInHand.length;i++)
				{
					cardGraphic = cardsInHand[i];
					if(cardGraphic.isKey(cardKey))
					{
						removingCard = true;
						//removeChild(cardGraphic);
						cardGraphic.close();
						Tweener.addTween(cardGraphic, {x:(CardDefenitins.CONTAINER_gameWidth/2) + Math.random() * 5, y:(CardDefenitins.CONTAINER_gameHeight/2) + Math.random() * 5, rotation:(CardDefenitins.currentDeckRotation + Math.random()*5), time:CardDefenitins.cardSpeed, transition:"linear",onComplete:removeCardFromHand,onCompleteParams:[cardGraphic]});
						CardDefenitins.currentDeckRotation+=10;
						//dispatchEvent(new CardToDeckEvent(cardGraphic));
						cardsInHand.splice(i,1);
						updateSpacing();
						respaceCardsFor(middle);
						return;
					}
				} 
			}
		}
		private function removeCardFromHand(card:CardGraphicMovieClip):void
		{
			removeChild(card);
			/*if(waitingRemove > 0)
			{
				waitingRemove--;
				removeCard();
			}*/
			removingCard = false;
			dispatchEvent(new CardToDeckEvent(card));
			if(cardsToRemove.length > 0)
				removeCard(cardsToRemove.pop())
		}
		
		
		
		private function updateSpacing():void
		{
			var availableSpace:int = CardDefenitins.playerXPositions[0] - (25 + CardDefenitins.cardWidth * 2)
			if(CardDefenitins.playerNumber == 4)
			availableSpace -=  (CardDefenitins.cardHeight );
			var devider:int = (cardsInHand.length -3);
			if(devider < 1)
				devider = 1
			CardDefenitins.playerCardSpacing = availableSpace / devider
			if(CardDefenitins.playerCardSpacing >  (CardDefenitins.cardWidth * 0.66))
				CardDefenitins.playerCardSpacing =  (CardDefenitins.cardWidth * 0.66)
		}
		public function respaceCardsFor(cardId:int):void
		{
						
			var cardGraphics:CardGraphicMovieClip;
			var currentSpace:int = (-CardDefenitins.playerCardSpacing);
				for(var i:int = 0;i<cardsInHand.length;i++)
				{
					cardGraphics = cardsInHand[i];
					if((Math.abs(cardId - i) < 2) && (cardId!= -1))
					{
						currentSpace += CardDefenitins.cardWidth * 0.66
						cardGraphics.x = CardDefenitins.playerXPositions[0] - currentSpace	
						
					}
					else
					{
						currentSpace += CardDefenitins.playerCardSpacing
						cardGraphics.x = CardDefenitins.playerXPositions[0] - currentSpace	
						
					}
					addChildAt(cardGraphics,0);
				}
		}
		public function showCard():void
		{
			if(cardsInStock.length != 0)
			{
				lastCard.setCard(cardsInStock.pop());
				updateSpacing();
				respaceCardsFor(middle);
			}
		}
		override public function dealCard():Boolean
		{
			if(cardsInStock.length == 0)
				return false;
			lastCard = new CardGraphicMovieClip();
			addChildAt(lastCard,0)
			cardsInHand.push(lastCard);
			updateSpacing();
			lastCard.moveCard(0,cardsInHand.length);
			return true;
			
		}
	}
}
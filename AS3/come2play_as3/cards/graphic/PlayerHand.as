package come2play_as3.cards.graphic
{
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.events.CardPressedEvent;
	import come2play_as3.cards.events.CardsDealtEvent;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class PlayerHand extends Hand
	{
		private var cardsInStock:Array/*PlayerCard*/;
		private var cardsInHand:Array/*CardGraphicMovieClip*/;
		private var cardDictonery:CardDictonery;
		private var lastCard:CardGraphicMovieClip;
		private var cardOverFlow:Boolean;
		private var bouncingCards:Array;
		private var bounceCards:Timer;
		private var arrangeCardsTimer:Timer;
		private var bouncePosition:int;
		private var isBounceUp:Boolean;
		
		public function PlayerHand()
		{
			cardOverFlow = false;
			isBounceUp = true;
			bounceCards = new Timer(100,0);
			arrangeCardsTimer = new Timer(400,0);
			bounceCards.start();
			cardsInStock = new Array();
			cardsInHand = new Array();
			bouncingCards = new Array();
			bouncePosition = CardDefenitins.playerYPositions[0] - 20;
			bounceCards.addEventListener(TimerEvent.TIMER,doBounce);
			arrangeCardsTimer.addEventListener(TimerEvent.TIMER,moveCard);
			addEventListener(MouseEvent.MOUSE_MOVE,repositionCards)
			addEventListener(CardPressedEvent.CardPressedEvent,bounceCard,true);
		}
		
		private function moveCard(ev:TimerEvent):void
		{
			var tempCard:CardGraphicMovieClip = cardDictonery.arangeNextCard();
			var cardGraphicMovieClip:CardGraphicMovieClip;
			if(tempCard == null)
				arrangeCardsTimer.stop();
			else
			{
				respaceCards();
			}
		}
		
		private function doBounce(ev:TimerEvent):void
		{
			if(isBounceUp)
			{
				bouncePosition -=2;
				if(bouncePosition < (CardDefenitins.playerYPositions[0] -50))
				{
					isBounceUp = false
				}
			}
			else
			{
				bouncePosition +=2;
				if(bouncePosition > CardDefenitins.playerYPositions[0] -20 )
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
			
			var cardGraphic:CardGraphicMovieClip;
			var distanceMap:Array = new Array();
			var middle:int = -1,smallesDistance:int;
			for(var i:int = 0;i<cardsInHand.length ;i++)
			{
				cardGraphic = cardsInHand[i];
				var actualMiddle:int = (cardGraphic.x + cardGraphic.width/2);
				var distance:int = Math.abs(actualMiddle - ev.stageX);
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
							if(cardOverFlow)
								cardGraphic.yPos = CardDefenitins.playerYPositions[0] - (15 *(2.2-(distanceMap[i] /(CardDefenitins.cardWidth*0.66))));
							else
								cardGraphic.yPos = CardDefenitins.playerYPositions[0] - (15 *(2.2 -(distanceMap[i] /CardDefenitins.playerCardSpacing)));
					}
					else
					{
							cardGraphic.yPos = CardDefenitins.playerYPositions[0];
					}
					//addChildAt(cardGraphic,0)

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
			for(var i:int = 0;i<cardsInHand.length;i++)
			{
				var cardGraphic:CardGraphicMovieClip = cardsInHand[i];
				if(cardGraphic.isKey(cardKey))
				{
					removeChild(cardGraphic);
					cardsInHand.splice(i,1);
					respaceCards();
					return;
				}
			} 
		}
		public function respaceCardsFor(cardId:int):void
		{
			var cardGraphics:CardGraphicMovieClip;
			var i:int;
			var maxNeedeSpace:int = cardsInHand.length * CardDefenitins.cardWidth 
			var availableSpace:int = CardDefenitins.playerXPositions[0] - (CardDefenitins.cardHeight +10);
			
			if(availableSpace > maxNeedeSpace)
			{
				cardOverFlow = false;
				for(i = 0;i<cardsInHand.length;i++)
				{
					cardGraphics = cardsInHand[i];
					cardGraphics.x = CardDefenitins.playerXPositions[0] - i * CardDefenitins.cardWidth 
				}
				CardDefenitins.playerCardSpacing = CardDefenitins.cardWidth ;
			}
			else
			{
				cardOverFlow = true;
				var  spacingMod:int =CardDefenitins.cardWidth -(maxNeedeSpace -availableSpace )/cardsInHand.length ;
				var mod:int;
				if(cardId == 0)
					mod = 2;
				else if((cardsInHand.length - cardId) == 1)
					mod = 1;
				else if((cardsInHand.length - cardId) == 2)
					mod = 2;
				else
					mod = 3;
				
				
				spacingMod-= ((CardDefenitins.cardWidth * 0.66 - spacingMod) * mod)/(cardsInHand.length - mod)
				var currentSpace:int = (-CardDefenitins.cardWidth * 0.66);
				for(i = 0;i<cardsInHand.length;i++)
				{
					cardGraphics = cardsInHand[i];
					//if(!cardGraphics.selected)
					//{
						if(Math.abs(cardId - i) < 2)
						{
							currentSpace += CardDefenitins.cardWidth * 0.66
							cardGraphics.x = CardDefenitins.playerXPositions[0] - currentSpace	
							
						}
						else
						{
							currentSpace += spacingMod
							cardGraphics.x = CardDefenitins.playerXPositions[0] - currentSpace	
								
						}
				/*	}
					else
					{
						if(Math.abs(cardId - i) < 2)
							currentSpace += CardDefenitins.cardWidth * 0.66
						else
							currentSpace += spacingMod	
					}*/
				}
				CardDefenitins.playerCardSpacing = spacingMod ;
			}
		}
		public function respaceCards():void
		{
			var cardGraphics:CardGraphicMovieClip;
			var i:int;
			var maxNeedeSpace:int = cardsInHand.length * CardDefenitins.cardWidth 
			var availableSpace:int = CardDefenitins.playerXPositions[0] - (CardDefenitins.cardHeight +10);
			var spacingMod:int;
			if(availableSpace > maxNeedeSpace)
				spacingMod = CardDefenitins.cardWidth ;
			else
				spacingMod =CardDefenitins.cardWidth -( (maxNeedeSpace -availableSpace )/cardsInHand.length+1);
			for(i = 0;i<cardsInHand.length;i++)
			{
				cardGraphics = cardsInHand[i];
				addChildAt(cardGraphics,0);
				cardGraphics.y = CardDefenitins.playerYPositions[0]
				cardGraphics.x = CardDefenitins.playerXPositions[0] - i * spacingMod 
			}
			CardDefenitins.playerCardSpacing = spacingMod ;
		}
		public function showCard():void
		{
			if(cardsInStock.length != 0)
			{
				lastCard.setCard(cardsInStock.pop());
				respaceCards();
			}
		}
		override public function dealCard():Boolean
		{
			if(cardsInStock.length == 0)
				return false;
			lastCard = new CardGraphicMovieClip();
			addChildAt(lastCard,0)
			cardsInHand.push(lastCard);
			lastCard.moveCard(0,cardsInHand.length);
			return true;
			
		}
	}
}
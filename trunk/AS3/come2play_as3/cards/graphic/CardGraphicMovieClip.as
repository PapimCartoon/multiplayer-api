package come2play_as3.cards.graphic
{
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.PlayerCard;
	import come2play_as3.cards.caurina.transitions.Tweener;
	import come2play_as3.cards.events.CardPressedEvent;
	import come2play_as3.cards.events.CardRecievedEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CardGraphicMovieClip extends Sprite
	{
		public var playerCard:PlayerCard;
		private var cardGraphic:Card_MC;
		private var cardNum:int;
		private var playerNum:int;
		public var isSet:Boolean;
		public var selected:Boolean;
		public function CardGraphicMovieClip(movebale:Boolean = true)
		{
			if(movebale)
			{
				//addEventListener(MouseEvent.MOUSE_OVER,cardOver);
				//addEventListener(MouseEvent.MOUSE_OUT,cardOut);
				addEventListener(MouseEvent.CLICK,cardSelect);
			}
			cardGraphic = new Card_MC();
			cardGraphic.scaleX = CardDefenitins.cardSize *0.01
			cardGraphic.scaleY = CardDefenitins.cardSize *0.01
			cardGraphic.Symbole_MC.gotoAndStop("Back");
			cardGraphic.Letter_MC.stop();
			addChild(cardGraphic)
		}
		public function close():void
		{
			cardGraphic.Symbole_MC.gotoAndStop(1);
			cardGraphic.Letter_MC.gotoAndStop(1);
		}
		public function set yPos(yPos:int):void
		{
			if(!selected)
				y = yPos;	
		}
		public function isKey(cardKey:int):Boolean
		{
			return playerCard.cardKey == cardKey;
		}
		public function isEquel(playerCard:PlayerCard):Boolean
		{
			return this.playerCard.card.isEqual(playerCard.card);
		}
		public function setCard(playerCard:PlayerCard):void
		{
			this.playerCard = playerCard;
			isSet = true;
			var isBlack:Boolean = playerCard.card.isBlack();
			if(playerCard.card.value == 100)
			{
				if(isBlack)
				{
					cardGraphic.Letter_MC.gotoAndStop(29)
					cardGraphic.Symbole_MC.gotoAndStop("Joker_black");
				}
				else
				{
					cardGraphic.Letter_MC.gotoAndStop(15)
					cardGraphic.Symbole_MC.gotoAndStop("Joker_red");
				}
			}
			else
			{
				cardGraphic.Symbole_MC.gotoAndStop(playerCard.card.sign);
				if(playerCard.card.value > 10)
				{
					cardGraphic.Symbole_MC.gotoAndStop(cardGraphic.Symbole_MC.currentFrame+(((playerCard.card.value-11) < 1)?3:(playerCard.card.value-11)));
				}
				cardGraphic.Letter_MC.gotoAndStop(playerCard.card.value + (isBlack? 15 : 1))			
			}	
		}
		private function nextCard():void
		{
			dispatchEvent(new CardRecievedEvent());			
		}
		public function cardOver(ev:MouseEvent):void
		{
			if((playerNum == 0) && (CardDefenitins.canCardsBeSelected))
				y = CardDefenitins.playerYPositions[0] - CardDefenitins.cardHeight/4;
		}
		public function cardSelect(ev:MouseEvent):void
		{
			if(playerNum == 0)
			{
				if(selected)
				{
					selected = false;
					dispatchEvent(new CardPressedEvent(playerCard,selected));
				}
				else
				{
					if(CardDefenitins.canCardsBeSelected)
					{
						selected = true;
						y = CardDefenitins.playerYPositions[0] - 40;
						dispatchEvent(new CardPressedEvent(playerCard,selected));
					}
				}
				
			}
		}
		public function cardOut(ev:MouseEvent):void
		{
			if((playerNum == 0) && (!selected))
				y = CardDefenitins.playerYPositions[0]
		}
		
		
		public function moveCard(playerNum:int,cardNum:int):void
		{
			this.cardNum = cardNum;
			this.playerNum = playerNum;
			x = -50;
			y = -50;
			rotation= 120
			if(playerNum== (CardDefenitins.playerNumber >2?1:2) )
				Tweener.addTween(this, {x:CardDefenitins.playerXPositions[1], y:(CardDefenitins.playerYPositions[1] +CardDefenitins.rivalCardSpacing*cardNum) , rotation:270, time:CardDefenitins.cardSpeed, transition:"linear",onComplete:nextCard});		
			else if(playerNum== (CardDefenitins.playerNumber >2?2:1) )
				Tweener.addTween(this, {x:CardDefenitins.playerXPositions[2] +CardDefenitins.rivalCardSpacing*cardNum, y:(CardDefenitins.playerYPositions[2]) , rotation:180, time:CardDefenitins.cardSpeed, transition:"linear",onComplete:nextCard});		
			else if(playerNum==3)
				Tweener.addTween(this, {x:CardDefenitins.playerXPositions[3], y:(CardDefenitins.playerYPositions[3] - CardDefenitins.rivalCardSpacing*cardNum) , rotation:90, time:CardDefenitins.cardSpeed, transition:"linear",onComplete:nextCard});		
			else if(playerNum==0)
				Tweener.addTween(this, {x:CardDefenitins.playerXPositions[0] - CardDefenitins.playerCardSpacing*cardNum, y:(CardDefenitins.playerYPositions[0]) , rotation:0, time:CardDefenitins.cardSpeed, transition:"linear",onComplete:nextCard});		
			
			
		}

		

	}
}
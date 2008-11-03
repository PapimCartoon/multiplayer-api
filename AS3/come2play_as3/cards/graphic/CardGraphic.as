package come2play_as3.cards.graphic
{
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.PlayerCard;
	import come2play_as3.cards.caurina.transitions.Tweener;
	import come2play_as3.cards.events.CardRecievedEvent;
	import come2play_as3.cards.events.CardShownEvent;
	import come2play_as3.cards.events.CardToDeckEvent;
	import come2play_as3.cards.events.CardsDealtEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CardGraphic extends MovieClip
	{
		protected var yourCards:PlayerHand;
		protected var rivalHandsArray:Array/*RivalHand*/;
		protected var cardDeck:CardDeck;
		private var myUserId:int;
		private var allPlayersIds:Array;
		private var currentPlayer:int;
		private var background:Sprite;
		private var showCardsArr:Array;
		private var cardsShown:int;
		public function CardGraphic()
		{
			rivalHandsArray = new Array();
			addEventListener(CardRecievedEvent.CardRecieved,dealNextCard,true);
			addEventListener(CardsDealtEvent.CardsDealtEvent,cardsDealt,true)
			addEventListener(CardToDeckEvent.CardToDeckEvent,addCardToDeck,true);
		}
		public function addCardToDeck(ev:CardToDeckEvent):void
		{
			cardDeck.addCard(ev.card)
		}
		
		public function addCardsToMiddle(cardsToAdd:int):void
		{
			/*if(cardsInDeck < 0) cardsInDeck=0;
			cardsInDeck+=cardsToAdd;
			cardDeck.cardNum_txt.text = String(cardsInDeck);
			if(cardsInDeck > 0 )
				addChild(cardDeck);*/
		}
		public function removeCardsFromMiddle(cardsToRemove:int):void
		{
			cardDeck.removeCards(cardsToRemove);
			/*cardsInDeck-=cardsToRemove;
			cardDeck.cardNum_txt.text = String(cardsInDeck);
			if(cardsInDeck < 1 )
				if(contains(cardDeck))
					removeChild(cardDeck);*/
		}
		public function init(myUserId:int,allPlayersIds:Array):void
		{
			this.myUserId = myUserId;
			background = new Sprite();
			this.allPlayersIds = allPlayersIds;

			background.graphics.beginFill(0x5A24A0);
			background.graphics.drawRect(0,0,CardDefenitins.CONTAINER_gameWidth,CardDefenitins.CONTAINER_gameHeight);
			background.graphics.endFill();
			addChild(background)
			cardDeck = new CardDeck();
			addChild(cardDeck);
			//cardDeck.scaleX = cardDeck.scaleY = 0.01 * CardDefenitins.cardSize;
			//cardDeck.x = CardDefenitins.CONTAINER_gameWidth / 2;
			//cardDeck.y = CardDefenitins.CONTAINER_gameHeight / 2;
			if(yourCards!=null)
				if(contains(yourCards))
					removeChild(yourCards);
			for each(var rivalHand:RivalHand in rivalHandsArray)
				if(contains(rivalHand))
					removeChild(rivalHand);
			yourCards = new PlayerHand();
			currentPlayer = 0;
			var mod:int = allPlayersIds.indexOf(myUserId);
			var cahngedNum:int;
			for(var i:int = 0 ; i<allPlayersIds.length;i++)
			{
				cahngedNum = i - mod;
				if(cahngedNum < 0)
					cahngedNum = allPlayersIds.length + cahngedNum;
				rivalHandsArray[i] = new RivalHand(cahngedNum)
				addChild(rivalHandsArray[i]);
			}
			addChild(yourCards);		
					


		}
		public function cardsDealt(ev:CardsDealtEvent):void
		{
			yourCards.arrangeCards(false);
		}
		public function clearBounce():void
		{
			yourCards.clearBounce();
		}
		public function clearShownCards():void
		{
			for each(var tempGraphicCard:CardGraphicMovieClip in showCardsArr)
			{
				removeChild(tempGraphicCard);
			}
			showCardsArr = new Array();
		}
		public function showCards(revealedCards:Array/*PlayerCard*/):void
		{
			var tempGraphicCard:CardGraphicMovieClip;
			cardsShown = 0;
			showCardsArr = new Array();
			for each(var playerCard:PlayerCard in revealedCards)
			{
				tempGraphicCard = new CardGraphicMovieClip(false);
				tempGraphicCard.setCard(playerCard);
				tempGraphicCard.x = CardDefenitins.CONTAINER_gameWidth / 2;
				tempGraphicCard.y = CardDefenitins.CONTAINER_gameHeight / 2;
				addChild(tempGraphicCard);
				showCardsArr.push(tempGraphicCard);
			}
			var i:int = showCardsArr.length -1;
			var j:int = 0;
			var yMove:int=1;
			var xMove:int= Math.floor((showCardsArr.length-1) / 2)+1;
			while(i > j)
			{
				tempGraphicCard = showCardsArr[i] ;
				Tweener.addTween(tempGraphicCard,{time:0.3,rotation:(0 + xMove*15),x:(tempGraphicCard.x + xMove*20),y:(tempGraphicCard.y - yMove*10), transition:"linear",onComplete:cardDone})
				tempGraphicCard = showCardsArr[j];
				Tweener.addTween(tempGraphicCard,{time:0.3,rotation:(0 - xMove*15),x:(tempGraphicCard.x  - xMove*20),y:(tempGraphicCard.y - yMove*10),transition:"linear",onComplete:cardDone})
				j++;
				i--;
				xMove --;
				yMove ++;
			}
			if(i == j)
			{
				tempGraphicCard = showCardsArr[j];
				Tweener.addTween(tempGraphicCard,{time:0.3,y:(tempGraphicCard.y - yMove*10),transition:"linear",onComplete:cardDone})	
			}
		}
		private function cardDone():void
		{
			cardsShown++;
			if(cardsShown == showCardsArr.length)
				dispatchEvent(new CardShownEvent());
		}
		public function removeCard(playerId:int,cardKey:int):void
		{
			if(playerId == myUserId)
				yourCards.removeCard(cardKey);
			else
			{
				var rivalHand:RivalHand = rivalHandsArray[allPlayersIds.indexOf(playerId)];
				rivalHand.removeCard();
			}
		}
		public function arrangeCards(isByNum:Boolean):void
		{
			yourCards.arrangeCards(isByNum);
		}
		public function addCards(cards:Array/*Card*/):void
		{
			yourCards.addCards(cards);
		}

		public function rivalAddCards(rivalId:int,amountOfCards:int):void
		{
			var rivalHand:RivalHand = rivalHandsArray[allPlayersIds.indexOf(rivalId)];
			rivalHand.addCards(amountOfCards);
		}
		public function isNoCardsLeft():Boolean
		{
			if(yourCards.isNoCardsLeft()== false)
				return false;
			for each(var rivalHand:RivalHand in rivalHandsArray)
			{
			if(rivalHand.isNoCardsLeft()== false)
				return false;
			}
			return true;
		}
		public function devideCards():void
		{
			if(isNoCardsLeft())
				return;
			var dealCardToHand:Hand;
			if (allPlayersIds[currentPlayer] == myUserId)
				dealCardToHand = yourCards;
			else
				dealCardToHand = rivalHandsArray[currentPlayer];
			var cardAvaible:Boolean = dealCardToHand.dealCard();
			if(!cardAvaible)
				dealNextCard();

		}
		
		private function dealNextCard(ev:Event = null):void
		{
			if(currentPlayer == allPlayersIds.indexOf(myUserId))
				yourCards.showCard();
			currentPlayer++;
			if(currentPlayer >= allPlayersIds.length)
				currentPlayer = 0;
			devideCards();
		}
		
		
	}
}
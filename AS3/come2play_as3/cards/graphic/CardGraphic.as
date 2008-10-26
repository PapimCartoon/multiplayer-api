package come2play_as3.cards.graphic
{
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.PlayerCard;
	import come2play_as3.cards.caurina.transitions.Tweener;
	import come2play_as3.cards.events.CardRecievedEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CardGraphic extends MovieClip
	{
		protected var yourCards:PlayerHand;
		protected var rivalHandsArray:Array/*RivalHand*/;
		private var myUserId:int;
		private var allPlayersIds:Array;
		private var currentPlayer:int;
		private var background:Sprite;
		private var showCardsArr:Array;
		public function CardGraphic()
		{
			rivalHandsArray = new Array();
			addEventListener(CardRecievedEvent.CardRecieved,dealNextCard,true);
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
		public function showCards(revealedCards:Array/*PlayerCard*/):void
		{
			var tempGraphicCard:CardGraphicMovieClip;
			showCardsArr = new Array();
			for each(var playerCard:PlayerCard in revealedCards)
			{
				tempGraphicCard = new CardGraphicMovieClip();
				tempGraphicCard.setCard(playerCard);
				tempGraphicCard.x = CardDefenitins.CONTAINER_gameWidth / 2;
				tempGraphicCard.y = CardDefenitins.CONTAINER_gameHeight / 2;
				addChild(tempGraphicCard);
				Tweener.addTween(tempGraphicCard,{time:1,rotation:showCardsArr.length*30,x:tempGraphicCard.x - showCardsArr.length*20,y:tempGraphicCard.y - showCardsArr.length*20 , transition:"linear"})
				showCardsArr.push(tempGraphicCard);
			}
			var i:int = showCardsArr.length -1;
			var j:int = 0;
			while(i > j)
			{
				tempGraphicCard = showCardsArr[j] ;
				Tweener.addTween(tempGraphicCard,{time:1,rotation:(0 + j*10),/*x:tempGraphicCard.x - showCardsArr.length*20,y:tempGraphicCard.y - showCardsArr.length*20 ,*/ transition:"linear"})
				tempGraphicCard = showCardsArr[i];
				Tweener.addTween(tempGraphicCard,{time:1,rotation:(0 - i*10),/*x:tempGraphicCard.x - showCardsArr.length*20,y:tempGraphicCard.y - showCardsArr.length*20 ,*/ transition:"linear"})
				j++;
				i--;
			}
			
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
		public function addCards(cards:Array/*Card*/):void
		{
			yourCards.addCards(cards);
		}

		public function rivalAddCards(rivalId:int,amountOfCards:int):void
		{
			var rivalHand:RivalHand = rivalHandsArray[allPlayersIds.indexOf(rivalId)];
			rivalHand.addCards(amountOfCards);
		}
		
		public function devideCards():void
		{
			var dealCardToHand:Hand;
			if (allPlayersIds[currentPlayer] == myUserId)
				dealCardToHand = yourCards;
			else
				dealCardToHand = rivalHandsArray[currentPlayer];
			dealCardToHand.dealCard();

		}
		
		private function dealNextCard(ev:Event):void
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
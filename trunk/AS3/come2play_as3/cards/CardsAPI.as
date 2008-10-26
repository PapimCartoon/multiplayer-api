package come2play_as3.cards
{
	import come2play_as3.api.auto_generated.ClientGameAPI;
	import come2play_as3.api.auto_generated.InfoEntry;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.cards.connectionClasses.CardTypeClass;
	import come2play_as3.cards.events.CardPressedEvent;
	import come2play_as3.cards.graphic.CardGraphic;
	import come2play_as3.cards.graphic.CardGraphicMovieClip;
	
	public class CardsAPI extends ClientGameAPI
	{
		private var currentCard:int;
		private var availableCards:int;
		private var storedDecks:Boolean;
		private var allPlayerIdsForCardAPI:Array;/*int*/
		private var finishedPlayerIdsForCardAPI:Array;/*int*/
		private var allPlayerCardsKeys:Array;/*Array*/
		private var allPlayerAvailableCards:Array;/*Array*/
		
		private var cardGraphics:CardGraphic;
		private var hiddenDeck:Array;
		private var visibleDeck:Array;
		protected var myUserId:int;
		
		private var markedCards:Array;
		public function CardsAPI(cardGraphics:CardGraphic)
		{
			markedCards = new Array();

			(new Card).register();
			(new CenterCard).register();
			(new CardTypeClass).register();	
			initCardDefenitins();
			this.cardGraphics = cardGraphics
			cardGraphics.addEventListener(CardPressedEvent.CardPressedEvent,cardMarked,true);

			super(cardGraphics);
		}
		private function initCardDefenitins():void
		{
			var tempCardGraphic:CardGraphicMovieClip= new CardGraphicMovieClip();
			CardDefenitins.cardWidth = tempCardGraphic.width;
			CardDefenitins.cardHeight = tempCardGraphic.height;	
		}
		private function getId(playerId:int):int
		{
			return allPlayerIdsForCardAPI.indexOf(playerId);
		}
		public function putInCenter(choosenCards:Array/*PlayerCard*/,isVisible:Boolean):void
		{
			var userEntries:Array/*UserEntry*/ = new Array();
			for each(var playerCard:PlayerCard in choosenCards)
			{
				removeMarked(playerCard);
				userEntries.push(UserEntry.create(CardTypeClass.create(CardTypeClass.CENTERCARD,playerCard.num),CenterCard.create(myUserId,playerCard.num,isVisible)))
			}
			doStoreState(userEntries);
		}
		
		private function removeMarked(playerCard:PlayerCard):void
		{
			for(var i:int = 0;i<markedCards.length;i++)
			{
				var tempPlayerCard:PlayerCard = markedCards[i];
				if(playerCard.num == tempPlayerCard.num)
				{
					markedCards.splice(i,1);
					return;
				}
			}
		}
		
		private function cardMarked(ev:CardPressedEvent):void
		{
			var playerCard:PlayerCard;
			if(ev.isPressed)
			{
				markedCards.push(ev.playerCard)
			}
			else
			{
				for(var i:int = 0;i<markedCards.length;i++)
				{
					playerCard = markedCards[i];
					if(ev.playerCard.card.sign == playerCard.card.sign)
						if(ev.playerCard.card.value == playerCard.card.value)
						{
							markedCards.splice(i,1);
							CardDefenitins.canCardsBeSelected = true;
						}
				}
			}
			gotChoosenCards(markedCards.concat());
			
		}
		
		public function chooseCards(allowChoise:Boolean):void
		{
			markedCards = new Array();
			CardDefenitins.canCardsBeSelected = allowChoise;
		}
		
		public function drawCards(numberOfCards:int,playerId:int):void
		{
			var revealEntries:Array/*RevealEntry*/ = new Array();
			var drawingPlayer:Array = allPlayerAvailableCards[getId(playerId)];
			for(var i:int = 0;i<numberOfCards;i++)
			{
				revealEntries.push(RevealEntry.create(CardTypeClass.create(CardTypeClass.CARD,(currentCard+i)),[playerId]))
				drawingPlayer.push(currentCard+i);
			}
			currentCard += i;
			doAllRevealState(revealEntries);
		}

		
		public function storeDecks(numberOfDecs:int,withJokers:Boolean):void
		{
			currentCard = 1;
			var count:int = 1;
			
			var userEntries:Array/*UserEntry*/ = new Array();
			var keys:Array/*String*/ = new Array();
			for(var i:int=0;i<numberOfDecs;i++)
			{
				for(var j:int = 1;j<14;j++)
				{
					keys.push(CardTypeClass.create(CardTypeClass.CARD,(count)));
					userEntries.push(UserEntry.create(CardTypeClass.create(CardTypeClass.CARD,(count++)),Card.createByNumber(1,j),true));
					keys.push(CardTypeClass.create(CardTypeClass.CARD,(count)));
					userEntries.push(UserEntry.create(CardTypeClass.create(CardTypeClass.CARD,(count++)),Card.createByNumber(2,j),true));
					keys.push(CardTypeClass.create(CardTypeClass.CARD,(count)));
					userEntries.push(UserEntry.create(CardTypeClass.create(CardTypeClass.CARD,(count++)),Card.createByNumber(3,j),true));
					keys.push(CardTypeClass.create(CardTypeClass.CARD,(count)));
					userEntries.push(UserEntry.create(CardTypeClass.create(CardTypeClass.CARD,(count++)),Card.createByNumber(4,j),true));
					
				}
				if(withJokers)
				{
					keys.push(CardTypeClass.create(CardTypeClass.CARD,(count)));
					userEntries.push(UserEntry.create(CardTypeClass.create(CardTypeClass.CARD,(count++)),Card.createByNumber(1,100),true));
					keys.push(CardTypeClass.create(CardTypeClass.CARD,(count)));
					userEntries.push(UserEntry.create(CardTypeClass.create(CardTypeClass.CARD,(count++)),Card.createByNumber(3,100),true));		
				}
			}
			storedDecks = true;
			availableCards = count - 1;
			doAllStoreState(userEntries);
			doAllShuffleState(keys);
		}
		private function interpertServerEntries(serverEntries:Array,isLoad:Boolean):Array/*ServerEntry*/
		{
			var serverEntry:ServerEntry;
			var drawnCards:Array/*Card*/ = new Array();
			var revealedCards:Array/*Card*/ = new Array();
			var cardsPutOnBoard:Array/*CenterCard*/ = new Array();
			var rivalDecks:Array/*int*/ = new Array()
			var playerCards:Array/*int*/;
			var cardTypeClass:CardTypeClass;
			var blameId:int;
			for(var i:int = 0;i<serverEntries.length;i++)
			{
				serverEntry = serverEntries[i];
				if(typeof(serverEntry.key) != "object")
					continue;
				if(serverEntry.key is CardTypeClass)
				{
					cardTypeClass= serverEntry.key as CardTypeClass;
					if(serverEntry.value is Card)
					{
						if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,"this card was stored by a single player");
						if(serverEntry.visibleToUserIds != null)
							drawnCards.push(new PlayerCard(serverEntry.value as Card,cardTypeClass.value));
						else
							revealedCards.push(new PlayerCard(serverEntry.value as Card,cardTypeClass.value));
					}
					if(serverEntry.value is CenterCard)
					{
						cardsPutOnBoard.push(serverEntry.value as CenterCard);
						blameId = serverEntry.storedByUserId;
					}
					if(serverEntry.visibleToUserIds != null)
					{
						var drawingPlayer:Array/*int*/;
						if(cardTypeClass.type != CardTypeClass.CARD) continue;
						for each(var playerId:int in serverEntry.visibleToUserIds)
						{		
							var id:int = getId(playerId);			
							drawingPlayer = allPlayerAvailableCards[id];
							var spliceAt:int = drawingPlayer.indexOf(cardTypeClass.value);
							if((spliceAt == -1) && (!isLoad)) doAllFoundHacker(serverEntry.storedByUserId,"player can't have this card");
							drawingPlayer.splice(spliceAt,1);
							
							playerCards = allPlayerCardsKeys[id]	
							if(playerCards.indexOf(cardTypeClass.value)==-1)
							{
								playerCards.push(cardTypeClass.value);
								rivalDecks[id] == null ? rivalDecks[id] = 1 : rivalDecks[id] ++;
							}
						}
					}
										
					serverEntries.splice(i,1);
					i--;
				}
				
			}
			
			if(isLoad)
				gotMatchLoaded(allPlayerIdsForCardAPI.concat(), finishedPlayerIdsForCardAPI.concat(), serverEntries);	
			if(drawnCards.length > 0)
				callGotCards(drawnCards);
			if(cardsPutOnBoard.length > 0)
				callGotPlayerPutCards(cardsPutOnBoard,blameId);
			if(revealedCards.length > 0)
				callGotMiddleCards(revealedCards)
			for each(var userId:int in allPlayerIdsForCardAPI)
			{
				if((rivalDecks[getId(userId)]> 0) && (userId != myUserId))
					callRivalGotCards(userId,rivalDecks[getId(userId)]);
			}	

			return serverEntries;
		}
		override public function gotCustomInfo(infoEntries:Array):void
		{
			for each(var infoEntry:InfoEntry in infoEntries)
			{
				if(infoEntry.key == "CONTAINER_gameWidth")
					CardDefenitins.CONTAINER_gameWidth = infoEntry.value as int
				else if(infoEntry.key == "CONTAINER_gameHeight")
					CardDefenitins.CONTAINER_gameHeight = infoEntry.value as int
			}
			CardDefenitins.playerXPositions= [CardDefenitins.CONTAINER_gameWidth - 50,CardDefenitins.CONTAINER_gameWidth - 50,50,50] ;
			CardDefenitins.playerYPositions= [CardDefenitins.CONTAINER_gameHeight- 50,50,50,CardDefenitins.CONTAINER_gameHeight - 50]; 
		}
		override public function gotMyUserId(myUserId:int):void
		{
			this.myUserId = myUserId;
			gotMyUserId2(myUserId);
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			hiddenDeck = new Array();
			visibleDeck = new Array();
			this.allPlayerIdsForCardAPI = allPlayerIds.concat();
			this.finishedPlayerIdsForCardAPI = finishedPlayerIds.concat()
			cardGraphics.init(myUserId,allPlayerIdsForCardAPI);
			CardDefenitins.playerNumber = allPlayerIdsForCardAPI.length;
			allPlayerCardsKeys = new Array();
			allPlayerAvailableCards = new Array();
			for each(var playerId:int in allPlayerIdsForCardAPI)
			{
				var id:int = getId(playerId);
				allPlayerCardsKeys[id]/*int*/ = new Array();
				allPlayerAvailableCards[id]/*int*/ = new Array();
			}
			if(serverEntries.length>0)
			{
				serverEntries = interpertServerEntries(serverEntries,true);
			}
			else
				gotMatchStarted2(allPlayerIds, finishedPlayerIds, serverEntries);
			
			
			
		}

		override public function gotStateChanged(serverEntries:Array):void
		{
			var serverEntry:ServerEntry;
			
			if(storedDecks)
			{
				var countedCards:int = 0;
				for each(serverEntry in serverEntries)
				{
					if(typeof(serverEntry.key) != "object")
						continue;
					if(serverEntry.key is CardTypeClass)
					{
						var cardTypeClass:CardTypeClass = serverEntry.key as CardTypeClass;
						if(cardTypeClass.type != CardTypeClass.CARD) continue;
						if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,"this card was stored by a single player");
						countedCards++;
					}			
				}
				if(countedCards != availableCards)
					doAllFoundHacker(serverEntry.storedByUserId,"Wrong number of cards recived");
				else
					storedDecks = false;
			}	
			serverEntries = interpertServerEntries(serverEntries,false);
			cardGraphics.devideCards();	
			gotStateChangedNoCards(serverEntries)
		}
		private function callGotPlayerPutCards(cardsPutOnBoard:Array/*CenterCard*/,blameId:int):void
		{	
			var keys:Array = new Array();
			var centerCard:CenterCard = cardsPutOnBoard[0];
			var isVisble:Boolean = centerCard.isVisible;
			var playerId:int = centerCard.playerId;
			var id:int = getId(playerId);
			
			for each(centerCard in cardsPutOnBoard)
			{
				var tempPlayerKeys:Array = allPlayerCardsKeys[id];
				var index:int = tempPlayerKeys.indexOf(centerCard.cardKey);
				if(index == -1)
				{
					doAllFoundHacker(blameId,"user faked a centerCard class");
					return;
				}
				else
					tempPlayerKeys.splice(index,1);
				keys.push(CardTypeClass.create(CardTypeClass.CARD,centerCard.cardKey))
				cardGraphics.removeCard(playerId,centerCard.cardKey);
			}
			if(!isVisble)
			{
				gotPlayerPutCardsSecret(keys,playerId);
				
			}
			else
			{
				var revealEntries:Array = new Array();
				for each(var key:CardTypeClass in keys)
				{
					revealEntries.push(RevealEntry.create(key,null));
				}
				doAllRevealState(revealEntries);
			}
		}
		private function callGotMiddleCards(revealedCards:Array/*PlayerCard*/):void
		{
			//todo: graphic representation of cards
			cardGraphics.showCards(revealedCards);
			gotMiddleCards(revealedCards);
		}
		private function callRivalGotCards(rivalId:int,amountOfCards:int):void
		{
			cardGraphics.rivalAddCards(rivalId,amountOfCards);
			rivalGotCards(rivalId,amountOfCards);
		}
		private function callGotCards(playerCards:Array/*PlayerCard*/):void
		{
			cardGraphics.addCards(playerCards);
			gotCards(playerCards)
		}
		public function gotMiddleCards(revealedCards:Array/*PlayerCard*/):void{}
		public function gotPlayerPutCardsSecret(keys:Array,playerId:int):void{}
		public function gotPlayerPutCards(playerCards:Array/*PlayerCard*/,playerId:int):void{}
		public function gotMatchLoaded(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void{}	
		public function gotChoosenCards(choosenCards:Array):void{}
		public function gotCards(playerCards:Array/*PlayerCard*/):void{}
		public function rivalGotCards(rivalId:int,amountOfCards:int):void{}
		public function gotMatchStarted2(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void	{}
		public function gotMyUserId2(myUserId:int):void	{}
		public function gotStateChangedNoCards(serverEntries:Array):void{}
		
	}
}
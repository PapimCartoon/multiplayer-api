package come2play_as3.cards
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ClientGameAPI;
	import come2play_as3.api.auto_generated.InfoEntry;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.cards.connectionClasses.CardTypeClass;
	import come2play_as3.cards.events.AnimationEndedEvent;
	import come2play_as3.cards.events.AnimationStartedEvent;
	import come2play_as3.cards.events.CardPressedEvent;
	import come2play_as3.cards.graphic.CardGraphic;
	import come2play_as3.cards.graphic.CardGraphicMovieClip;
	
	import flash.events.Event;
	
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
			cardGraphics.addEventListener(AnimationEndedEvent.AnimationEndedEvent,endAnimation);
			cardGraphics.addEventListener(AnimationStartedEvent.AnimationStartedEvent,startAnimation);
			super(cardGraphics);
		}		
		private function startAnimation(ev:Event):void
		{
			animationStarted();
		}
		private function endAnimation(ev:Event):void
		{
			animationEnded();
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

		private function removeMarked(playerCard:PlayerCard):void
		{
			for(var i:int = 0;i<markedCards.length;i++)
			{
				var tempPlayerCard:PlayerCard = markedCards[i];
				if(playerCard.cardKey == tempPlayerCard.cardKey)
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
		public function arrangeByNum():void
		{
			cardGraphics.arrangeCards(true);
		}
		public function arrangeByColor():void
		{
			cardGraphics.arrangeCards(false);
		}
		public function putInCenter(choosenCards:Array/*PlayerCard*/,isVisible:Boolean):void
		{
			var userEntries:Array/*UserEntry*/ = new Array();
			for each(var playerCard:PlayerCard in choosenCards)
			{
				removeMarked(playerCard);
				userEntries.push(UserEntry.create(CardTypeClass.create(CardTypeClass.CENTERCARD,playerCard.cardKey),CenterCard.create(myUserId,playerCard.cardKey,isVisible)))
			}
			doStoreState(userEntries);
		}
		public function takeCardsFromMiddle(playerId:int,cardsInMiddle:Array/*CardTypeClass*/):void
		{
			var id:int = getId(playerId);
			var keysToScramble:Array = new Array()
			
			for each(var cardTypeClass:CardTypeClass in cardsInMiddle)
				keysToScramble.push(cardTypeClass.value);
			keysToScramble = keysToScramble.concat(allPlayerCardsKeys[id]);
			allPlayerAvailableCards[id] = keysToScramble.concat(allPlayerAvailableCards[id]);
			
			var revealEntries:Array/*RevealEntry*/ = new Array();
			var allKeys:Array/*CardTypeClass*/ = new Array();
			for each(var key:int in keysToScramble)
			{
				cardTypeClass = CardTypeClass.create(CardTypeClass.CARD,key);
				allKeys.push(cardTypeClass);
				revealEntries.push(RevealEntry.create(cardTypeClass,[playerId]))
				
			}
			cardGraphics.removeCardsFromMiddle(allKeys.length);
			doAllShuffleState(allKeys);
			doAllRevealState(revealEntries);					
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
					userEntries.push(UserEntry.create(CardTypeClass.create(CardTypeClass.CARD,(count++)),Card.createByNumber(5,100),true));
					keys.push(CardTypeClass.create(CardTypeClass.CARD,(count)));
					userEntries.push(UserEntry.create(CardTypeClass.create(CardTypeClass.CARD,(count++)),Card.createByNumber(6,100),true));		
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
						if(cardTypeClass.cardType != CardTypeClass.CARD) continue;
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
			
			var isDevideCards:Boolean;
			
			if(isLoad)
				gotMatchLoaded(allPlayerIdsForCardAPI.concat(), finishedPlayerIdsForCardAPI.concat(), serverEntries);	
			if(drawnCards.length > 0)
			{	
				callGotCards(drawnCards);
				isDevideCards = true;
			}
			for each(var userId:int in allPlayerIdsForCardAPI)
			{
				if((rivalDecks[getId(userId)]> 0) && (userId != myUserId))
				{
					isDevideCards = true;
					callRivalGotCards(userId,rivalDecks[getId(userId)]);
				}
					
			}	
			
			if(isDevideCards)
				cardGraphics.devideCards();	
			if(cardsPutOnBoard.length > 0)
				callGotPlayerPutCards(cardsPutOnBoard,blameId,isLoad);
			if(revealedCards.length > 0)
				callGotMiddleCards(revealedCards)

			return serverEntries;
		}
		override public function gotCustomInfo(infoEntries:Array):void
		{
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId, null) as int;
			CardDefenitins.CONTAINER_gameWidth = T.custom(CUSTOM_INFO_KEY_gameWidth, 400) as int;
			CardDefenitins.CONTAINER_gameHeight = T.custom(CUSTOM_INFO_KEY_gameHeight, 400) as int;
			CardDefenitins.CONTAINER_gameStageX = T.custom(CUSTOM_INFO_KEY_gameStageX, 0) as int;
			CardDefenitins.CONTAINER_gameStageY = T.custom(CUSTOM_INFO_KEY_gameStageY, 0) as int;
			gotMyUserId2(myUserId);			
			CardDefenitins.playerXPositions= [CardDefenitins.CONTAINER_gameWidth - 50,CardDefenitins.CONTAINER_gameWidth - 50,50,50] ;
			CardDefenitins.playerYPositions= [CardDefenitins.CONTAINER_gameHeight- 50,50,50,CardDefenitins.CONTAINER_gameHeight - 50]; 
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
			{
				gotMatchStarted2(allPlayerIds, finishedPlayerIds, serverEntries);
			}
			
			
			
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
						if(cardTypeClass.cardType != CardTypeClass.CARD) continue;
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
			gotStateChangedNoCards(serverEntries)
		}
		private function callGotPlayerPutCards(cardsPutOnBoard:Array/*CenterCard*/,blameId:int,isLoad:Boolean):void
		{	
			var keys:Array = new Array();
			var centerCard:CenterCard = cardsPutOnBoard[0];
			var isVisble:Boolean = centerCard.isVisible;
			var playerId:int = centerCard.playerId;
			var id:int = getId(playerId);
			cardGraphics.clearBounce();
			for each(centerCard in cardsPutOnBoard)
			{
				var tempPlayerKeys:Array = allPlayerCardsKeys[id];
				var index:int = tempPlayerKeys.indexOf(centerCard.cardKey);
				if(index == -1)
				{
					if(!isLoad)
					{
						doAllFoundHacker(blameId,"user faked a centerCard class");
						return;
					}
				}
				else
				{
					if(!isLoad)
					tempPlayerKeys.splice(index,1);
				}
				keys.push(CardTypeClass.create(CardTypeClass.CARD,centerCard.cardKey))
				if(!isLoad)
					cardGraphics.removeCard(playerId,centerCard.cardKey);
			}
			if(!isVisble)
			{
				cardGraphics.addCardsToMiddle(keys.length);
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
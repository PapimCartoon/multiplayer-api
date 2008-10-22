package come2play_as3.cards
{
	import come2play_as3.api.auto_generated.ClientGameAPI;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.cards.graphic.CardGraphic;
	
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
		protected var myUserId:int;
		public function CardsAPI(cardGraphics:CardGraphic)
		{
			(new Card).register();
			this.cardGraphics = cardGraphics
			super(cardGraphics);
		}
		
		public function drawCards(numberOfCards:int,playerId:int):void
		{
			var revealEntries:Array/*RevealEntry*/ = new Array();
			var drawingPlayer:Array = allPlayerAvailableCards[playerId];
			for(var i:int = 0;i<numberOfCards;i++)
			{
				revealEntries.push(RevealEntry.create({type:"Card",num:(currentCard+i)},[playerId]))
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
				for(var j:int = 0;j<13;j++)
				{
					keys.push({type:"Card",num:count});
					userEntries.push(UserEntry.create({type:"Card",num:count++},Card.createByNumber(1,j),true));
					keys.push({type:"Card",num:count});
					userEntries.push(UserEntry.create({type:"Card",num:count++},Card.createByNumber(2,j),true));
					keys.push({type:"Card",num:count});
					userEntries.push(UserEntry.create({type:"Card",num:count++},Card.createByNumber(3,j),true));
					keys.push({type:"Card",num:count});
					userEntries.push(UserEntry.create({type:"Card",num:count++},Card.createByNumber(4,j),true));
					
				}
				if(withJokers)
				{
					keys.push({type:"Card",num:count});
					userEntries.push(UserEntry.create({type:"Card",num:count++},Card.createByNumber(1,100),true));
					keys.push({type:"Card",num:count});
					userEntries.push(UserEntry.create({type:"Card",num:count++},Card.createByNumber(3,100),true));		
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
			var rivalDecks:Array/*int*/ = new Array()
			var playerCards:Array/*int*/;
			for(var i:int = 0;i<serverEntries.length;i++)
			{
				serverEntry = serverEntries[i];
				if(typeof(serverEntry.key) != "object")
					continue;
				if(serverEntry.key.type == null)
					continue;	
				if(serverEntry.key.type == "Card")
				{
					if(serverEntry.visibleToUserIds != null)
					{
						var drawingPlayer:Array/*int*/;
						for each(var id:int in serverEntry.visibleToUserIds)
						{
							drawingPlayer = allPlayerAvailableCards[id];
							var spliceAt:int = drawingPlayer.indexOf(serverEntry.key.num);
							if((spliceAt == -1) && (!isLoad)) doAllFoundHacker(serverEntry.storedByUserId,"player can't have this card");
							drawingPlayer.splice(spliceAt,1);
						}
					}
					if(serverEntry.value is Card)
					{
						if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,"this card was stored by a single player");
						drawnCards.push(serverEntry.value as Card);
					}

					if(serverEntry.visibleToUserIds != null)
					{
						for each(var playerId:int in serverEntry.visibleToUserIds)
						{
							playerCards = allPlayerCardsKeys[playerId]
							if(playerCards.indexOf(serverEntry.key.num)==-1)
							{
								playerCards.push(serverEntry.key.num);
								rivalDecks[playerId] == null ? rivalDecks[playerId] = 1 : rivalDecks[playerId] ++;
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
			for each(var userId:int in allPlayerIdsForCardAPI)
			{
				if((rivalDecks[userId]> 0) && (userId != myUserId))
					callRivalGotCards(userId,rivalDecks[userId]);
			}	

			return serverEntries;
		}
		override public function gotMyUserId(myUserId:int):void
		{
			this.myUserId = myUserId;
			gotMyUserId2(myUserId);
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			this.allPlayerIdsForCardAPI = allPlayerIds.concat();
			this.finishedPlayerIdsForCardAPI = finishedPlayerIds.concat()
			cardGraphics.init(myUserId,allPlayerIdsForCardAPI);
			allPlayerCardsKeys = new Array();
			allPlayerAvailableCards = new Array();
			for each(var playerId:int in allPlayerIdsForCardAPI)
			{
				allPlayerCardsKeys[playerId]/*int*/ = new Array();
				allPlayerAvailableCards[playerId]/*int*/ = new Array();
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
					if(serverEntry.key.type == null)
						continue;	
					if(serverEntry.key.type == "Card")
					{
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
		public function callRivalGotCards(rivalId:int,amountOfCards:int):void
		{
			cardGraphics.rivalAddCards(rivalId,amountOfCards);
			rivalGotCards(rivalId,amountOfCards);
		}
		public function callGotCards(cards:Array/*Card*/):void
		{
			cardGraphics.addCards(cards);
			gotCards(cards)
		}
		public function gotMatchLoaded(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void{}	
		public function gotCards(cards:Array/*Card*/):void{}
		public function rivalGotCards(rivalId:int,amountOfCards:int):void{}
		public function gotMatchStarted2(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void	{}
		public function gotMyUserId2(myUserId:int):void	{}
		public function gotStateChangedNoCards(serverEntries:Array):void{}
		
	}
}
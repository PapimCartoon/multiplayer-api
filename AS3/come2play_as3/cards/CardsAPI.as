package come2play_as3.cards
{

	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.JSON;
	import come2play_as3.api.auto_copied.SerializableClass;
	import come2play_as3.api.auto_copied.StaticFunctions;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ClientGameAPI;
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	public class CardsAPI extends ClientGameAPI
	{
		static public var cardsData:CardsAPI
		private var currentCard:int
		private var cardGraphics:MovieClip;
		private var waitingCards:Dictionary
		private var drawingCards:Dictionary
		private var flippedCards:Dictionary/*CardKey*/
		private var deckCards:Dictionary/*CardKey*/
		private var cardsOwners:Dictionary/*Dictionary -->userId*//*CardKey*/	
		private var cardToKey:Dictionary
		private var computerCards:int
		private var cardsNumToDraw:int
		private var currentSinglePlayer:int
		private var userCards:int
		private var isSinglePlayer:Boolean
		private var canShowCards:int
		protected var isPlaying:Boolean
		public function CardsAPI(cardGraphics:MovieClip)
		{
			super(cardGraphics)
			StaticFunctions.assert(cardsData==null,"can only make one CardsAPI instance")
			cardsData = this;
			this.cardGraphics = cardGraphics;
			new Card().register()
			new CardKey().register()
			new CardGameAction().register()
			AS3_vs_AS2.waitForStage(cardGraphics,buildCardsAPI)
		}	
		protected function buildCardsAPI():void{
			doRegisterOnServer()
		}	
		protected function storeDecks(deckNum:int,isWithJokers:Boolean):void{
			var doAllStore:Array = [];
			var doAllShuffle:Array = []
			var key:CardKey;
			var cardNum:int = 1;
			for(var deck:int =0;deck<deckNum;deck++){
				for(var sign:int=1;sign<5;sign++){
					for(var cardValue:int=1;cardValue<14;cardValue++){	
						key = CardKey.create(cardNum)
						waitingCards[key.toString()] = key
						doAllStore.push(UserEntry.create(key,Card.createByNumber(sign,cardValue)))
						doAllShuffle.push(key)
						cardNum++;
					}
				}
				if(isWithJokers){
					key = CardKey.create(cardNum++)
					waitingCards[key.toString()] = key
					doAllStore.push(UserEntry.create(key,Card.createByNumber(5,14)))
					doAllShuffle.push(key)
					
					key = CardKey.create(cardNum++)
					waitingCards[key.toString()] = key
					doAllStore.push(UserEntry.create(key,Card.createByNumber(6,14)))
					doAllShuffle.push(key)
				}
			}	
			canShowCards+=(cardNum-1)
			doAllStoreState(doAllStore)
			doAllShuffleState(doAllShuffle)
		}
		public function getCardsNumInDeck():int{
			return AS3_vs_AS2.dictionarySize(deckCards)
		}
		public function getCardsInUserHand(userId:int):Array{
			var tempDic:Dictionary = cardsOwners[userId]
			var cards:Array = []
			for(var str:String in tempDic){
				cards.push(tempDic[str])
			}
			return cards;
		}
		public function putCards(cards:Array/*CardKey*/,isPlayer:Boolean,addedData:SerializableClass = null):void{
			if(!isPlaying)	return;
			currentSinglePlayer = isPlayer?myUserId:0
			StaticFunctions.assert(cards.length!=0,"can't put 0 cards");
			var revealKeys:Array =[]
			for each(var cardKey:CardKey in cards){
				revealKeys.push(RevealEntry.create(cardKey,null))
				if(isSinglePlayer)	cardsNumToDraw++;
			}
			if(addedData==null)	addedData = CardGameAction.create(CardGameAction.PUT_CARD)
			doStoreState([UserEntry.create(CardGameAction.create(CardGameAction.PUT_CARD),addedData)],revealKeys)
		}
		
		public function singlePlayerDrawCards(isComputer:Boolean,amount:int,isByAll:Boolean = true):void{
			if(isComputer){
				computerCards +=amount;
			}else{
				userCards +=amount;
			}
			drawCards(allPlayerIds,amount,isByAll);
		}
		public function drawCards(userIds:Array,amount:int,isByAll:Boolean):void{
			if ((!isPlaying) || (canShowCards<=currentCard) )	return;
			var drawKey:Array = []
			var reavealArr:Array = []
			var keyStr:String
			for(var i:int =0;i<amount;i++){
				if(canShowCards<=currentCard)	continue;
				currentCard++
				drawKey.push(CardKey.create(currentCard))
			}	
			for each(var key:CardKey in drawKey){
				keyStr = key.toString()
				deleteOldPosition(keyStr)
				drawingCards[keyStr] = key;
				reavealArr.push(RevealEntry.create(key,userIds))
			}
			if(isByAll){
				doAllRevealState(reavealArr)
			}else{
				if(isSinglePlayer) currentSinglePlayer = userIds[0];
				doStoreState([UserEntry.create(CardGameAction.create(CardGameAction.DRAW_CARD),CardGameAction.create(CardGameAction.DRAW_CARD))],reavealArr)
			}
		}
		public function takeCardsToHand(cards:Array/*CardKey*/,userId:int):void{
			var revealEntries:Array = []
			var userCardsDic:Dictionary = cardsOwners[userId]
			var allCards:Array = []
			var tmpDic:Dictionary = new Dictionary()
			var keyString:String
			var cardKey:CardKey
			for(keyString in userCardsDic){
				if(tmpDic[keyString]!=null)	continue;
				tmpDic[keyString] = keyString
				allCards.push(SerializableClass.deserializeString(keyString) as CardKey)
			}	
			for each(cardKey in cards){
				keyString = cardKey.toString()
				if(tmpDic[keyString]!=null)	continue;
				tmpDic[keyString] = keyString
				allCards.push(cardKey)
			}
			allCards.sortOn("num",Array.NUMERIC)
			doAllShuffleState(allCards)
			var isComputer:Boolean
			if(isSinglePlayer){
				isComputer = (userId == 0)
				userId = myUserId;
			}	
			for each(cardKey in allCards){
				keyString = cardKey.toString()
				deleteOldPosition(cardKey.toString())
				waitingCards[keyString] = cardKey
				revealEntries.push(RevealEntry.create(cardKey,[userId]))
				if(isSinglePlayer){
					if(isComputer){
						computerCards++
					}else{
						userCards++;
					}
				}
			}
				
			doAllRevealState(revealEntries)
		}
		private var allPlayerIds:Array
		private var myUserId:int
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void{
			isPlaying = true
			this.allPlayerIds = allPlayerIds;
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,42) as int
			isSinglePlayer = (allPlayerIds.length == 1);
			currentCard = 0
			cardsNumToDraw = 0;
			computerCards = 0;
			userCards = 0;
			canShowCards = 0;
			waitingCards = new Dictionary();
			flippedCards = new Dictionary();
			deckCards = new Dictionary();
			cardsOwners = new Dictionary();
			cardToKey = new Dictionary();
			drawingCards = new Dictionary();
			if(isSinglePlayer){
				cardsOwners[myUserId] = new Dictionary()
				cardsOwners[0] = new Dictionary()
			}else{
				for each(var userId:int in allPlayerIds){
					cardsOwners[userId] = new Dictionary()
				}
			}
		}
		private function deletFromDic(dic:Dictionary,key:String):Boolean{
			if(dic[key]==null)	return false;
			delete dic[key];
			return true;
		}
		private function deleteOldPosition(key:String):Boolean{	
			if(deletFromDic(waitingCards,key))	return true ;
			if(deletFromDic(flippedCards,key))	return true;
			if(deletFromDic(drawingCards,key))	return true;
			if(deletFromDic(deckCards,key))	return true;		
			for each(var userId:int in allPlayerIds){
				if(deletFromDic(cardsOwners[userId],key))	return true;
			}
			if(isSinglePlayer){
				if(deletFromDic(cardsOwners[0],key))	return true;
			}
			return false;
		}
		
		override public function gotStateChanged(serverEntries:Array):void{
			StaticFunctions.assert(allPlayerIds!=null,"must call super.gotMatchStarted(serverEntries:Array) to use cards API")
			var addedData:SerializableClass
			var changedCards:Array = []
			var serverEntry:ServerEntry = serverEntries[0]
			var storingPlayer:int
			if(serverEntry.key is CardGameAction){
				var cardGameAction:CardGameAction = serverEntry.key as CardGameAction
				storingPlayer = isSinglePlayer?currentSinglePlayer:serverEntry.storedByUserId;
				if(cardGameAction.action == CardGameAction.DRAW_CARD){
					if(storingPlayer!=myUserId)	currentCard++;
				}
				if(!(serverEntry.value is CardGameAction)){
					addedData = serverEntry.value;
				}
			}	
			var i:int = 0
			while(i<serverEntries.length){
				serverEntry = serverEntries[i];
				if(serverEntry.key is CardKey){
					var key:CardKey = serverEntry.key as CardKey
					var keyString:String = key.toString();
					StaticFunctions.assert(deleteOldPosition(keyString),"can't delete a non existing key",keyString)
					if((serverEntry.visibleToUserIds == null) || (allPlayerIds.length == serverEntry.visibleToUserIds.length)){
						if(isSinglePlayer){
							if(userCards>0){
								changedCards.push(new CardChange(serverEntry.value,key,CardChange.USER_CARD,myUserId))
								cardsOwners[myUserId][keyString] = serverEntry.value
								userCards--
							}else if(computerCards>0){
								changedCards.push(new CardChange(serverEntry.value,key,CardChange.USER_CARD,0))
								cardsOwners[0][keyString] = serverEntry.value
								computerCards--
							}else if(cardsNumToDraw>0){
								changedCards.push(new CardChange(serverEntry.value,key,CardChange.FLIPPED_CARD,storingPlayer))
								flippedCards[keyString] = serverEntry.value
								cardsNumToDraw--
							}else{
								StaticFunctions.assert(false,"bug in drawing cards",keyString);
							}
						}else{
							changedCards.push(new CardChange(serverEntry.value,key,CardChange.FLIPPED_CARD,storingPlayer))
							flippedCards[keyString] = serverEntry.value
						}
					}else if(serverEntry.visibleToUserIds.length ==0){
						changedCards.push(new CardChange(serverEntry.value,key,CardChange.DRAWN_CARD))
						deckCards[keyString] = key;
					}else{
						for each(var userId:int in serverEntry.visibleToUserIds){
							changedCards.push(new CardChange(serverEntry.value,key,CardChange.USER_CARD,userId))
							cardsOwners[userId][keyString] = serverEntry.value == null?1:serverEntry.value
						}
					}
					serverEntries.splice(i,1);
				}else{
					i++
				}
			}
			var arr:Array = []
			arr.push(["waitingCards: "+AS3_vs_AS2.dictionarySize(waitingCards)])
			arr.push(["drawingCards: "+AS3_vs_AS2.dictionarySize(drawingCards)])
			arr.push(["flippedCards: "+AS3_vs_AS2.dictionarySize(flippedCards)])
			arr.push(["deckCards: "+AS3_vs_AS2.dictionarySize(deckCards)])
			for(var id:String in cardsOwners){		
				arr.push(["cardsOwners["+id+"]: "+AS3_vs_AS2.dictionarySize(cardsOwners[id])])
			}
			doTrace("currentState",arr)
			doTrace("changedCards",JSON.stringify(changedCards))
			if(changedCards.length!=0)	cardGraphics.dispatchEvent(new GotCardsEvent(changedCards,addedData))
		}
		
		public function declareWinner(userId:int):void{
			var finishedPlayers:Array = []
			for each(var id:int in allPlayerIds){
				if(id == userId)
					finishedPlayers.push(PlayerMatchOver.create(id,100,100))
				else
					finishedPlayers.push(PlayerMatchOver.create(id,0,0))
			}
			
			doAllEndMatch(finishedPlayers)
		}
		
		override public function gotMatchEnded(finishedPlayerIds:Array):void{
			isPlaying = false;
		}

	}
}
package come2play_as3.cards
{

	import come2play_as3.api.auto_copied.AS3_vs_AS2;
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
		private var isViewer:Boolean
		protected var isPlaying:Boolean
		
		private var testStr:String = '[{ $ServerEntry$ "changedTimeInMilliSeconds":2484 , "key":{ $CardKey$ "num":17} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2484 , "key":{ $CardKey$ "num":18} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2483 , "key":{ $CardKey$ "num":19} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2483 , "key":{ $CardKey$ "num":20} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2483 , "key":{ $CardKey$ "num":21} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2482 , "key":{ $CardKey$ "num":22} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2482 , "key":{ $CardKey$ "num":23} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2482 , "key":{ $CardKey$ "num":24} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2481 , "key":{ $CardKey$ "num":25} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2481 , "key":{ $CardKey$ "num":26} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2481 , "key":{ $CardKey$ "num":27} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2480 , "key":{ $CardKey$ "num":28} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2480 , "key":{ $CardKey$ "num":29} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2480 , "key":{ $CardKey$ "num":30} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2479 , "key":{ $CardKey$ "num":31} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2479 , "key":{ $CardKey$ "num":32} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2478 , "key":{ $CardKey$ "num":33} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2478 , "key":{ $CardKey$ "num":34} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2478 , "key":{ $CardKey$ "num":35} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2477 , "key":{ $CardKey$ "num":36} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2477 , "key":{ $CardKey$ "num":37} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2476 , "key":{ $CardKey$ "num":38} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2476 , "key":{ $CardKey$ "num":39} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2476 , "key":{ $CardKey$ "num":40} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2475 , "key":{ $CardKey$ "num":41} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2474 , "key":{ $CardKey$ "num":42} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2474 , "key":{ $CardKey$ "num":43} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2473 , "key":{ $CardKey$ "num":44} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2473 , "key":{ $CardKey$ "num":45} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2472 , "key":{ $CardKey$ "num":46} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2472 , "key":{ $CardKey$ "num":47} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2471 , "key":{ $CardKey$ "num":48} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2471 , "key":{ $CardKey$ "num":49} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2470 , "key":{ $CardKey$ "num":50} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2469 , "key":{ $CardKey$ "num":51} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2469 , "key":{ $CardKey$ "num":52} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2468 , "key":{ $CardKey$ "num":53} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2468 , "key":{ $CardKey$ "num":54} , "storedByUserId":-1 , "value":null , "visibleToUserIds":[]},{ $ServerEntry$ "changedTimeInMilliSeconds":2487 , "key":{ $CardKey$ "num":1} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Daimond" , "value":1} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2488 , "key":{ $CardKey$ "num":2} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Club" , "value":8} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2489 , "key":{ $CardKey$ "num":3} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Heart" , "value":2} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2491 , "key":{ $CardKey$ "num":4} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Spade" , "value":3} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2492 , "key":{ $CardKey$ "num":5} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Heart" , "value":5} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2493 , "key":{ $CardKey$ "num":6} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Club" , "value":11} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2494 , "key":{ $CardKey$ "num":7} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Club" , "value":1} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2495 , "key":{ $CardKey$ "num":8} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Club" , "value":3} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2496 , "key":{ $CardKey$ "num":9} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Heart" , "value":12} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2497 , "key":{ $CardKey$ "num":10} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Daimond" , "value":10} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2498 , "key":{ $CardKey$ "num":11} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Heart" , "value":8} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2499 , "key":{ $CardKey$ "num":12} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Spade" , "value":5} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2500 , "key":{ $CardKey$ "num":13} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Heart" , "value":13} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2501 , "key":{ $CardKey$ "num":14} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Club" , "value":7} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2502 , "key":{ $CardKey$ "num":15} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Daimond" , "value":5} , "visibleToUserIds":[42]},{ $ServerEntry$ "changedTimeInMilliSeconds":2503 , "key":{ $CardKey$ "num":16} , "storedByUserId":-1 , "value":{ $Card$ "sign":"Club" , "value":12} , "visibleToUserIds":[42]}]'
		
		
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
			if(isViewer)	return
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
			if(!isViewer)doStoreState([UserEntry.create(CardGameAction.create(CardGameAction.PUT_CARD),addedData)],revealKeys)
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
			if ((!isPlaying) || (canShowCards<=currentCard))	return;
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
			if(isViewer)	return;
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
			if(!isViewer)	doAllShuffleState(allCards)
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
				
			if(!isViewer)	doAllRevealState(revealEntries)
		}
		private var allPlayerIds:Array
		private var myUserId:int
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void{
			doTrace("start init of cardsAPI","start init of cardsAPI")
			isPlaying = true
			this.allPlayerIds = allPlayerIds.concat();
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,42) as int
			isViewer = (this.allPlayerIds.indexOf(myUserId) == -1)
			isSinglePlayer = (this.allPlayerIds.length == 1);
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
				for each(var userId:int in this.allPlayerIds){
					cardsOwners[userId] = new Dictionary()
				}
			}
			if(serverEntries.length > 0)	handleServerEntries(serverEntries,true)
			doTrace("end init of cardsAPI","end init of cardsAPI")
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
			handleServerEntries(serverEntries)
		}
		
		private function handleServerEntries(serverEntries:Array,isLoad:Boolean = false):void{
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
					if(!isLoad)	StaticFunctions.assert(deleteOldPosition(keyString),"can't delete a non existing key",keyString)
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
			
			if(!isViewer)	doAllEndMatch(finishedPlayers)
		}
		
		override public function gotMatchEnded(finishedPlayerIds:Array):void{
			isPlaying = false;
		}

	}
}
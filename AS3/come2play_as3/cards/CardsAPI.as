package come2play_as3.cards
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.StaticFunctions;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ClientGameAPI;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.cards.events.GotCardsEvent;
	
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
		private var computerCards:int
		private var userCards:int
		private var isSinglePlayer:Boolean
		public function CardsAPI(cardGraphics:MovieClip)
		{
			super(cardGraphics)
			StaticFunctions.assert(cardsData==null,"can only make one CardsAPI instance")
			cardsData = this;
			this.cardGraphics = cardGraphics;
			new Card().register()
			new CardKey().register()
			AS3_vs_AS2.waitForStage(cardGraphics,buildCardsAPI)
		}	
		protected function buildCardsAPI():void{
			doRegisterOnServer()
		}	
		protected function storeDecks(deckNum:int):void{
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
				key = CardKey.create(cardNum++)
				waitingCards[key.toString()] = key
				doAllStore.push(UserEntry.create(key,Card.createByNumber(5,0)))
				doAllShuffle.push(key)
				key = CardKey.create(cardNum++)
				waitingCards[key.toString()] = key
				doAllStore.push(UserEntry.create(key,Card.createByNumber(6,0)))
				doAllShuffle.push(key)
			}	
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
		
		public function singlePlayerDrawCards(isComputer:Boolean,amount:int):void{
			if(isComputer){
				computerCards +=amount;
			}else{
				userCards +=amount;
			}
			drawCards(allPlayerIds,amount,true);
		}
		public function drawCards(userIds:Array,amount:int,isByAll:Boolean):void{
			if(isByAll){
				var drawKey:Array = []
				for(var i:int =0;i<amount;i++){
					currentCard++
					drawKey.push(CardKey.create(currentCard))
				}
				var reavealArr:Array = []
				var keyStr:String
				for each(var key:CardKey in drawKey){
					keyStr = key.toString()
					deleteOldPosition(keyStr)
					drawingCards[keyStr] = key;
					reavealArr.push(RevealEntry.create(key,userIds))
				}
				doAllRevealState(reavealArr)
			}else{
				
			}
		}
		
		private var allPlayerIds:Array
		private var myUserId:int
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void{
			this.allPlayerIds = allPlayerIds;
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,42) as int
			isSinglePlayer = (allPlayerIds.length == 1);
			currentCard = 0
			waitingCards = new Dictionary();
			flippedCards = new Dictionary();
			deckCards = new Dictionary();
			cardsOwners = new Dictionary();
			drawingCards = new Dictionary()
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
			return false;
		}
		
		override public function gotStateChanged(serverEntries:Array):void{
			StaticFunctions.assert(allPlayerIds!=null,"must call super.gotMatchStarted to use cards API")
			var changedCards:Array = []
			for each(var serverEntry:ServerEntry in serverEntries){
				if(serverEntry.key is CardKey){
					var key:CardKey = serverEntry.key as CardKey
					StaticFunctions.assert(deleteOldPosition(key.toString()),"can't delete a non existing key")
					changedCards.push(key)
					if((serverEntry.visibleToUserIds == null) || (allPlayerIds.length == serverEntry.visibleToUserIds.length)){
						if(isSinglePlayer){
							if(userCards>0){
								cardsOwners[myUserId][key.toString()] = serverEntry.value
								userCards--
							}else if(computerCards>0){
								cardsOwners[0][key.toString()] = serverEntry.value
								computerCards--
							}else{
								StaticFunctions.assert(false,"bug in drawing cards");
							}
						}else
							flippedCards[key.toString()] = serverEntry.value
					}else if(serverEntry.visibleToUserIds.length ==0){
						deckCards[key.toString()] = key;
					}else{
						for each(var userId:int in serverEntry.visibleToUserIds){
							cardsOwners[userId][key.toString()] = serverEntry.value
						}
					}
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
			if(changedCards.length!=0)	cardGraphics.dispatchEvent(new GotCardsEvent(changedCards))
		}

	}
}
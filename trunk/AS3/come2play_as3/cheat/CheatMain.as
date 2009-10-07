package come2play_as3.cheat
{
	
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.ErrorHandler;
	import come2play_as3.api.auto_copied.Logger;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.cards.CardChange;
	import come2play_as3.cards.CardsAPI;
	import come2play_as3.cards.GotCardsEvent;
	import come2play_as3.cheat.ServerClasses.CallCheater;
	import come2play_as3.cheat.ServerClasses.CardsToHold;
	import come2play_as3.cheat.ServerClasses.JokerValue;
	import come2play_as3.cheat.ServerClasses.PlayerAction;
	import come2play_as3.cheat.ServerClasses.PlayerTurn;
	
	import flash.display.MovieClip;

	public class CheatMain extends CardsAPI
	{

		private var cardsGraphic:MovieClip
		private var myUserId:int
		private var rivalUserId:int
		private var cheatGraphics:CheatGraphics
		private var isSinglePlayer:Boolean
		private var allPlayerIds:Array
		private var isViewer:Boolean
		static public var sentData:Logger = new Logger("CheatSentData",12);
		static public var recievedData:Logger = new Logger("CheatRecievedData",12);
		static public var myTraces:Logger = new Logger("cheatTraces",20)
		public function CheatMain(cardsGraphic:MovieClip)
		{
			super(cardsGraphic)	
			new CardsToHold().register();
			new PlayerAction().register();
			new PlayerTurn().register();	
			new CallCheater().register();
			new JokerValue().register();
			cheatGraphics = new CheatGraphics()
			this.cardsGraphic = cardsGraphic;
			cardsGraphic.addChild(cheatGraphics)		
			AS3_vs_AS2.myAddEventListener("cheatGraphics",cheatGraphics,"CardsToHold",putCardsOnTableHidden)
			AS3_vs_AS2.myAddEventListener("cheatGraphics",cheatGraphics,"CallCheater",callCheater)	
			AS3_vs_AS2.myAddEventListener("cheatGraphics",cheatGraphics,"PlayerTurn",setTurn)	
			AS3_vs_AS2.myAddEventListener("cardsGraphic",cardsGraphic,GotCardsEvent.CARDS_CHANGED,handleChangedCards)
		}	

		private function callCheater(ev:CallCheater):void{
			if((!isPlaying) || (isViewer))	return;
			sentData.log("callCheater",ev)
			doStoreState([UserEntry.create(ev,ev)])
		}
		private function putCardsOnTableHidden(ev:CardsToHold):void{
			if((!isPlaying) || (isViewer))	return;
			sentData.log("putCardsOnTableHidden",ev)
			doStoreState([UserEntry.create(PlayerAction.create(myUserId,PlayerAction.PUT_HIDDEN),ev)])
		}
		private function handleChangedCards(ev:GotCardsEvent):void{
			var cardsChanged:Array = ev.cardsChanged;
			var cardToDraw:Array = []
			var cardsToPut:Array = []
			for each(var cardChange:CardChange in cardsChanged){
				if(cardChange.action == CardChange.USER_CARD){
					cardToDraw.push(cardChange)
				}else if (cardChange.action == CardChange.FLIPPED_CARD){
					cardsToPut.push(cardChange)
				}
			}
			cheatGraphics.setDeckSize(getCardsNumInDeck())
			if(cardToDraw.length>0){
				cheatGraphics.drawCards(cardToDraw)
			}else if(cardsToPut.length > 0){
				cheatGraphics.putFirst(cardsToPut,ev.addedAction as JokerValue)
			}	
		}
		
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void{
			recievedData.log("gotMatchStarted",allPlayerIds, finishedPlayerIds, serverEntries)
			this.allPlayerIds = allPlayerIds.concat();
			isSinglePlayer = (this.allPlayerIds.length == 1);
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,42) as int
			isViewer = this.allPlayerIds.indexOf(myUserId)==-1
			var sendMyUserId:int
			if(isViewer){
				sendMyUserId = this.allPlayerIds[0]
				rivalUserId = this.allPlayerIds[1]
			}else{
				sendMyUserId = myUserId
				rivalUserId = isSinglePlayer?0:(this.allPlayerIds[0]==myUserId?this.allPlayerIds[1]:this.allPlayerIds[0]);
			}
			
			
			cheatGraphics.init(isViewer,sendMyUserId,rivalUserId);
			super.gotMatchStarted(this.allPlayerIds, finishedPlayerIds, serverEntries)
			cheatGraphics.setRivalName()
			cheatGraphics.setUserName()
			if(isViewer){
				
			}else if(isSinglePlayer){	
				storeDecks(1,true)
				singlePlayerDrawCards(true,8)
				singlePlayerDrawCards(false,8)
			}else{
				if(serverEntries.length == 0){
					storeDecks(1,true)
					for each(var userId:int in this.allPlayerIds){
						drawCards([userId],8,true)	
					}	
				}else{
					//load game
				}				
			}
		}

		private function setTurn(playerTurn:PlayerTurn):void{
			var userTurn:int = allPlayerIds[playerTurn.turnNum%allPlayerIds.length];
			sentData.log("doAllSetTurn",userTurn)
			if(!isViewer)	doAllSetTurn(userTurn,-1)
			if(isSinglePlayer){
				cheatGraphics.setTurn((playerTurn.turnNum%2 == 1)?myUserId:rivalUserId)
			}else{
				cheatGraphics.setTurn(userTurn)
			}
		}
		override public function gotMatchEnded(finishedPlayerIds:Array):void{
			recievedData.log("gotMatchEnded",finishedPlayerIds)
			super.gotMatchEnded(finishedPlayerIds)
			cheatGraphics.gameEnded()
			animationStarted("waitForReset")
			ErrorHandler.myTimeout("waitForReset",function():void{
				animationEnded("waitForReset")
			},4000)
		}
		override public function gotStateChanged(serverEntries:Array):void{
			recievedData.log("gotStateChanged",serverEntries)
			super.gotStateChanged(serverEntries)
			for each(var serverEntry:ServerEntry in serverEntries){
				if(serverEntry.value is CardsToHold){
					var cardsToHold:CardsToHold = serverEntry.value as CardsToHold;
					cheatGraphics.putKeysInMiddle(cardsToHold)
				}else if(serverEntry.value is CallCheater){
					cheatGraphics.callCheater(serverEntry.value as CallCheater)
				}else if(serverEntry.value is PlayerAction){
					var playerAction:PlayerAction = serverEntry.value as PlayerAction;
				}
			}
			
		}
		

	}
}
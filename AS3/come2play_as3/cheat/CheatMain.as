package come2play_as3.cheat
{
	
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
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
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class CheatMain extends CardsAPI
	{

		private var cardsGraphic:MovieClip
		private var myUserId:int
		private var rivalUserId:int
		private var cheatGraphics:CheatGraphics
		private var isSinglePlayer:Boolean
		private var allPlayerIds:Array
		

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
			if(!isPlaying)	return;
			doStoreState([UserEntry.create(ev,ev)])
		}
		private function putCardsOnTableHidden(ev:CardsToHold):void{
			if(!isPlaying)	return;
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
			
			this.allPlayerIds = allPlayerIds;
			isSinglePlayer = (allPlayerIds.length == 1);
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,42) as int
			var isViewer:Boolean = allPlayerIds.indexOf(myUserId)==-1
			var sendMyUserId:int
			if(isViewer){
				sendMyUserId = allPlayerIds[0]
				rivalUserId = allPlayerIds[1]
			}else{
				sendMyUserId = myUserId
				rivalUserId = isSinglePlayer?0:(allPlayerIds[0]==myUserId?allPlayerIds[1]:allPlayerIds[0]);
			}
			
			
			cheatGraphics.init(isViewer,sendMyUserId,rivalUserId);
			super.gotMatchStarted(allPlayerIds, finishedPlayerIds, serverEntries)
			if(isSinglePlayer){	
				cheatGraphics.setRivalName(T.i18n("Computer"))
				cheatGraphics.setUserName(T.getUserValue(myUserId,USER_INFO_KEY_name,"Player") as String)
				storeDecks(1,true)
				singlePlayerDrawCards(true,8)
				singlePlayerDrawCards(false,8)
			}else{
				
				cheatGraphics.setRivalName(T.getUserValue(rivalUserId,USER_INFO_KEY_name,"Player") as String)
				cheatGraphics.setUserName(T.getUserValue(myUserId,USER_INFO_KEY_name,"Player") as String)
				if(serverEntries.length == 0){
					storeDecks(1,true)
					for each(var userId:int in allPlayerIds){
						drawCards([userId],8,true)	
					}	
				}else{
					//load game
				}				
			}
		}

		private function setTurn(playerTurn:PlayerTurn):void{
			var userTurn:int = allPlayerIds[playerTurn.turnNum%allPlayerIds.length];
			doAllSetTurn(userTurn,-1)
			if(isSinglePlayer){
				cheatGraphics.setTurn((playerTurn.turnNum%2 == 1)?myUserId:rivalUserId)
			}else{
				cheatGraphics.setTurn(userTurn)
			}
			
		}
		override public function gotMatchEnded(finishedPlayerIds:Array):void{
			super.gotMatchEnded(finishedPlayerIds)
			cheatGraphics.gameEnded()
		}
		override public function gotStateChanged(serverEntries:Array):void{
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
package come2play_as3.cheat
{
	
	import come2play_as3.CardChange;
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.cards.CardsAPI;
	import come2play_as3.cards.GotCardsEvent;
	import come2play_as3.cheat.ServerClasses.CallCheater;
	import come2play_as3.cheat.ServerClasses.CardsToHold;
	import come2play_as3.cheat.ServerClasses.PlayerAction;
	import come2play_as3.cheat.ServerClasses.PlayerTurn;
	import come2play_as3.cheat.events.CardDrawEndedEvent;
	
	import flash.display.MovieClip;

	public class CheatMain extends CardsAPI
	{

		private var cardsGraphic:MovieClip
		private var myUserId:int
		private var rivalUserId:int
		private var cheatGraphics:CheatGraphics
		private var isSinglePlayer:Boolean
		private var allPlayerIds:Array
		private var turnNumber:int = 0
		public function CheatMain(cardsGraphic:MovieClip)
		{
			super(cardsGraphic)	
			new CardsToHold().register();
			new PlayerAction().register();
			new PlayerTurn().register();	
			new CallCheater().register();
			cheatGraphics = new CheatGraphics()
			this.cardsGraphic = cardsGraphic;
			cardsGraphic.addChild(cheatGraphics)		
			AS3_vs_AS2.myAddEventListener("cheatGraphics",cheatGraphics,"CardsToHold",putCardsOnTableHidden)
			AS3_vs_AS2.myAddEventListener("cheatGraphics",cheatGraphics,"CallCheater",callCheater)
				
			AS3_vs_AS2.myAddEventListener("cheatGraphics",cheatGraphics,CardDrawEndedEvent.CARD_DRAW_ENDED,finishedDrawingCards)	
			AS3_vs_AS2.myAddEventListener("cardsGraphic",cardsGraphic,GotCardsEvent.CARDS_CHANGED,handleChangedCards)
		}	
		private function finishedDrawingCards(ev:CardDrawEndedEvent):void{
			
		}	
		private function callCheater(ev:CallCheater):void{
			doStoreState([UserEntry.create(ev,ev)])
		}
		private function putCardsOnTableHidden(ev:CardsToHold):void{
			doStoreState([UserEntry.create(PlayerAction.create(myUserId,PlayerAction.PUT_HIDDEN),ev)])
			//trace("CardsToHold: "+ev)
		}
		private function handleChangedCards(ev:GotCardsEvent):void{
			var cardsChanged:Array = ev.cardsChanged;
			setNextTurn()
			var noDraw:Boolean = true;	
			for each(var cardChange:CardChange in cardsChanged){
				if(cardChange.action == CardChange.USER_CARD){
					noDraw = false;
					cheatGraphics.drawCard(cardChange,cardChange.userId == myUserId)	
				}else if (cardChange.action == CardChange.FLIPPED_CARD){
					cheatGraphics.putFirst(cardChange,cardChange.userId == myUserId)	
				}
			}
			cheatGraphics.setDeckSize(getCardsNumInDeck())
			if(noDraw)	cheatGraphics.finishedDrawing()
	
		}
		
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void{
			super.gotMatchStarted(allPlayerIds, finishedPlayerIds, serverEntries)
			this.allPlayerIds = allPlayerIds;
			isSinglePlayer = (allPlayerIds.length == 1);
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,42) as int
			cheatGraphics.init(allPlayerIds.indexOf(myUserId)!=-1,myUserId);
			turnNumber = 0;
			if(allPlayerIds.length == 1){
				rivalUserId = 0;
				cheatGraphics.setRivalName(T.i18n("Computer"))
				cheatGraphics.setUserName(T.getUserValue(myUserId,USER_INFO_KEY_name,"Player") as String)
				storeDecks(1,true)
				singlePlayerDrawCards(true,8)
				singlePlayerDrawCards(false,8)
			}else{
				rivalUserId = allPlayerIds[0]==myUserId?allPlayerIds[1]:allPlayerIds[0];
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
		private function setNextTurn():void{
			turnNumber++;
			setTurn()
		}
		private function setTurn():void{
			var userTurn:int = allPlayerIds[turnNumber%allPlayerIds.length];
			doAllSetTurn(userTurn,-1)
			cheatGraphics.setTurn(userTurn)
		}
		override public function gotStateChanged(serverEntries:Array):void{
			super.gotStateChanged(serverEntries)
			for each(var serverEntry:ServerEntry in serverEntries){
				if(serverEntry.value is CardsToHold){
					var cardsToHold:CardsToHold = serverEntry.value as CardsToHold;
					setNextTurn()
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
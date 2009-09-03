package come2play_as3.cheat
{
	
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.cards.CardsAPI;
	import come2play_as3.cards.events.GotCardsEvent;
	
	import flash.display.MovieClip;

	public class CheatMain extends CardsAPI
	{

		private var cardsGraphic:MovieClip
		private var myUserId:int
		private var rivalUserId:int
		private var cheatGraphics:CheatGraphics
		private var isSinglePlayer:Boolean
		public function CheatMain(cardsGraphic:MovieClip)
		{
			super(cardsGraphic)	
			cheatGraphics = new CheatGraphics()
			this.cardsGraphic = cardsGraphic;
			cardsGraphic.addChild(cheatGraphics)
			AS3_vs_AS2.myAddEventListener("cardsGraphic",cardsGraphic,GotCardsEvent.CARDS_CHANGED,handleChangedCards)
		}	
		private function handleChangedCards(ev:GotCardsEvent):void{
			cheatGraphics.drawUserCards(getCardsInUserHand(myUserId))
			cheatGraphics.drawRivalCards(getCardsInUserHand(rivalUserId))
			cheatGraphics.setDeckSize(getCardsNumInDeck())
			
		}
		
		
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void{
			super.gotMatchStarted(allPlayerIds, finishedPlayerIds, serverEntries)
			isSinglePlayer = (allPlayerIds.length == 1);
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,42) as int
			cheatGraphics.init(allPlayerIds.indexOf(myUserId)!=-1);
			if(allPlayerIds.length == 1){
				rivalUserId = 0;
				cheatGraphics.setRivalName(T.i18n("Computer"))
				cheatGraphics.setUserName(T.getUserValue(myUserId,USER_INFO_KEY_name,"Player") as String)
				storeDecks(1)
				singlePlayerDrawCards(true,8)
				singlePlayerDrawCards(false,8)
			}else{
				rivalUserId = allPlayerIds[0]==myUserId?allPlayerIds[1]:allPlayerIds[0];
				cheatGraphics.setRivalName(T.getUserValue(rivalUserId,USER_INFO_KEY_name,"Player") as String)
				cheatGraphics.setUserName(T.getUserValue(myUserId,USER_INFO_KEY_name,"Player") as String)
				if(serverEntries.length == 0){
					storeDecks(1)
					for each(var userId:int in allPlayerIds){
						drawCards([userId],8,true)	
					}	
				}else{
					
				}				
			}
		}
		override public function gotStateChanged(serverEntries:Array):void{
			super.gotStateChanged(serverEntries)
		}
		

	}
}
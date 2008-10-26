package come2play_as3.cheat
{
	
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.cards.Card;
	import come2play_as3.cards.CardsAPI;
	
	import flash.display.MovieClip;

	public class CheatMain extends CardsAPI
	{
		private var cheatGraphics:CheatGraphic;
		public function CheatMain(graphics:MovieClip)
		{
			doTrace("asd","aaa");
			cheatGraphics = new CheatGraphic();
			graphics.addChild(cheatGraphics);
			super(cheatGraphics);
			doRegisterOnServer();
		}	
		override public function gotCards(cards:Array/*Card*/):void
		{
			//doTrace("me :"+myUserId,JSON.stringify(cards))
		}
		override public function gotChoosenCards(choosenCards:Array):void
		{
			/*for each(var card:Card in choosenCards)
			{
				
				trace("*******"+card.toString())
			}*/
			putInCenter(choosenCards);
		}
		override public function rivalGotCards(rivalId:int, amountOfCards:int):void
		{
			
			//doTrace("Rival "+rivalId,amountOfCards);
		}
		override public function gotMatchStarted2(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			storeDecks(1,true);
			for each(var playerId:int in allPlayerIds)
				drawCards(int(54/allPlayerIds.length),playerId);
			if(allPlayerIds.indexOf(myUserId) == 0)
				chooseCards(1,6);
				
		}
		override public function gotMatchLoaded(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{	
			doTrace("me","Load match");
			//storeDecks(2,false);
			//drawCards(3,allPlayerIds[0])
		}
		override public function gotStateChangedNoCards(serverEntries:Array):void
		{
			trace("*****************"+serverEntries)
		}
	}
}
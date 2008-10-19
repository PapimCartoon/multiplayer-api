package come2play_as3.cheat
{
	import come2play_as3.api.auto_copied.JSON;
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.cards.CardsAPI;
	
	import flash.display.MovieClip;

	public class cheatMain extends CardsAPI
	{
		public function cheatMain(graphics:MovieClip)
		{
			super(graphics);
			doRegisterOnServer();
		}	
		override public function gotCards(cards:Array/*Card*/):void
		{
			doTrace("me :"+myUserId,JSON.stringify(cards))
		}
		override public function rivalGotCards(rivalId:int, amountOfCards:int):void
		{
			doTrace("Rival "+rivalId,amountOfCards);
		}
		override public function gotMatchStarted2(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			storeDecks(1,true);
			for each(var playerId:int in allPlayerIds)
				drawCards(7,playerId)
			var userEntries:Array = new Array();
			for(var i:int=0;i<28;i++)
				userEntries.push(UserEntry.create("domino"+i,i,false))
			doAllStoreState(userEntries);
				
		}
		override public function gotMatchLoaded(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			doTrace("me","Load match");
			//storeDecks(2,false);
			//drawCards(3,allPlayerIds[0])
		}
		override public function gotStateChangedNoCards(serverEntries:Array):void
		{

		}
	}
}
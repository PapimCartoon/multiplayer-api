package come2play_as3.cheat
{
	import flash.display.MovieClip;
	import come2play_as3.cards.CardsAPI;
	import come2play_as3.api.auto_copied.AS3_vs_AS2;

	public class cheatMain extends CardsAPI
	{
		public function cheatMain(graphics:MovieClip)
		{
			super(graphics);
			doRegisterOnServer();
		}	
		override public function gotCards(cards:Array/*Card*/):void
		{
			trace("**********"+cards)
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			storeDecks(2,false);
			drawCards(3,allPlayerIds[0])
		}
	}
}
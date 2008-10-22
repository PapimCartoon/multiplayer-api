package come2play_as3.cheat
{
	import come2play_as3.cards.Card;
	import come2play_as3.cards.CardsAPI;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class CheatMain extends CardsAPI
	{
		public var textField:TextField;
		private var cheatGraphics:CheatGraphic;
		public function CheatMain(graphics:MovieClip)
		{
			cheatGraphics = new CheatGraphic();
			graphics.addChild(cheatGraphics);
			super(cheatGraphics);
			textField = new TextField();
			graphics.addChild(textField);
			doRegisterOnServer();
		}	
		override public function gotCards(cards:Array/*Card*/):void
		{
			textField.text ="";
			textField.multiline = true;
			textField.autoSize = TextFieldAutoSize.LEFT;
			for each(var card:Card in cards)
			{
				textField.appendText(card.value+" : "+card.sign+"\n");
			}
			//doTrace("me :"+myUserId,JSON.stringify(cards))
		}
		override public function rivalGotCards(rivalId:int, amountOfCards:int):void
		{
			
			//doTrace("Rival "+rivalId,amountOfCards);
		}
		override public function gotMatchStarted2(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			storeDecks(1,true);
			for each(var playerId:int in allPlayerIds)
				drawCards(int(54/allPlayerIds.length),playerId)
				
		}
		override public function gotMatchLoaded(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{	
			doTrace("me","Load match");
			//storeDecks(2,false);
			//drawCards(3,allPlayerIds[0])
		}
		override public function gotStateChangedNoCards(serverEntries:Array):void
		{
			cheatGraphics.devideCards();
		}
	}
}